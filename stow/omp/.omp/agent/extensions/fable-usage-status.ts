/**
 * Adds the Anthropic Fable weekly quota to the status line.
 *
 * The built-in `usage` status-line segment renders only the ranked primary and
 * secondary windows (`anthropic:5h` and `anthropic:7d`), so the tier-scoped
 * `anthropic:7d:fable` limit never appears there. This extension polls the
 * host's own cached usage report and publishes the missing window as a keyed
 * status, which the status line renders inline with other extension statuses.
 */

/** Limit id of the Fable-scoped weekly window in an Anthropic usage report. */
const FABLE_LIMIT_ID = "anthropic:7d:fable";

/**
 * Status key. Statuses are rendered sorted by key, and the `status` segment sits
 * immediately right of `usage`, so the leading digit keeps this window adjacent
 * to the built-in 5h/7d text instead of behind other extensions' statuses.
 */
const STATUS_KEY = "0-usage-fable";

/** How often the cached usage report is re-read. */
const REFRESH_MS = 60_000;

/** The fields this extension needs from one `reports[].limits[]` entry. */
type FableLimit = {
  usedFraction: number;
  resetsAt?: number;
};

/** Subset of the session context used here. */
type SessionContext = {
  ui: { setStatus: (key: string, text: string) => void };
  setInterval: (handler: () => void, ms: number) => unknown;
  clearTimer: (timer: unknown) => void;
};

/** Subset of the extension API used here. */
type ExtensionApi = {
  on: (
    event: string,
    handler: (event: unknown, ctx: SessionContext) => void | Promise<void>,
  ) => void;
};

/** Reads an object property off an unknown value, or `undefined` when absent. */
function objectAt(value: unknown, key: string): unknown {
  if (typeof value !== "object" || value === null || !(key in value)) return undefined;
  return (value as Record<string, unknown>)[key];
}

/** Extracts the Fable weekly window from a parsed `omp usage --json` payload. */
function findFableLimit(payload: unknown): FableLimit | undefined {
  const reports = objectAt(payload, "reports");
  if (!Array.isArray(reports)) return undefined;
  for (const report of reports) {
    const limits = objectAt(report, "limits");
    if (!Array.isArray(limits)) continue;
    for (const limit of limits) {
      if (objectAt(limit, "id") !== FABLE_LIMIT_ID) continue;
      const usedFraction = objectAt(objectAt(limit, "amount"), "usedFraction");
      if (typeof usedFraction !== "number") continue;
      const resetsAt = objectAt(objectAt(limit, "window"), "resetsAt");
      return { usedFraction, resetsAt: typeof resetsAt === "number" ? resetsAt : undefined };
    }
  }
  return undefined;
}

/** Formats a reset deadline the way the built-in usage segment does: `6d 16h`, `2h 45m`, `12m`. */
function formatResetIn(resetsAt: number | undefined, now: number): string | undefined {
  if (resetsAt === undefined || resetsAt <= now) return undefined;
  const totalMinutes = Math.floor((resetsAt - now) / 60_000);
  const days = Math.floor(totalMinutes / 1440);
  const hours = Math.floor((totalMinutes % 1440) / 60);
  const minutes = totalMinutes % 60;
  if (days > 0) return `${days}d ${hours}h`;
  if (hours > 0) return `${hours}h ${minutes}m`;
  return `${minutes}m`;
}

/**
 * Reads the Fable weekly limit out of the host's usage cache.
 *
 * Spawns the running `omp` executable instead of calling the Anthropic usage
 * endpoint directly, so the shared cached report is reused and no extra quota
 * request is made.
 */
async function readFableLimit(): Promise<FableLimit | undefined> {
  const proc = Bun.spawn([process.execPath, "usage", "--json", "--provider", "anthropic"], {
    stdout: "pipe",
    stderr: "ignore",
    env: { ...process.env, NO_COLOR: "1" },
  });
  const [stdout, exitCode] = await Promise.all([new Response(proc.stdout).text(), proc.exited]);
  if (exitCode !== 0) return undefined;
  try {
    return findFableLimit(JSON.parse(stdout));
  } catch {
    return undefined;
  }
}

/** Renders `fable 3% (6d 16h)`, or an empty string when the window is unavailable. */
function renderStatus(limit: FableLimit | undefined, now: number): string {
  if (!limit) return "";
  const percent = Math.round(limit.usedFraction * 100);
  const resetIn = formatResetIn(limit.resetsAt, now);
  return resetIn ? `fable ${percent}% (${resetIn})` : `fable ${percent}%`;
}

export default function (pi: ExtensionApi): void {
  pi.on("session_start", async (_event: unknown, ctx: SessionContext) => {
    const refresh = async (): Promise<void> => {
      ctx.ui.setStatus(STATUS_KEY, renderStatus(await readFableLimit(), Date.now()));
    };
    await refresh();
    const timer = ctx.setInterval(() => void refresh(), REFRESH_MS);
    pi.on("session_shutdown", () => ctx.clearTimer(timer));
  });
}
