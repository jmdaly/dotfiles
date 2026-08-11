# Global Development Workflow

These are my default working expectations across all projects. A repo's own
`CLAUDE.md` overrides anything here.

## Version control — Jujutsu (jj)

I use **Jujutsu (`jj`)** for version control across all my repos. Always read
and follow the `use-jujutsu` skill for command references. Never run raw `git`
commands inside a repo.

- **Changeset descriptions** use Conventional Commits (see below).
- **Bookmark naming:**
  - With a Jira ticket: `<initials>/<TICKET>-N-<short-description>`, e.g.
    `jd/BCT-2169-2-configure-modes-api`. `N` increments for each changeset in a
    stack (omit for the first if preferred).
  - Without a Jira ticket: `<initials>/<short-description>`, e.g.
    `jd/add-scalar-ui`.
- Every changeset must have a description **and** a bookmark before it is
  considered complete.
- Always use `--no-pager` when running `jj` commands non-interactively.
- **Targeted edits to a specific changeset in a stack:** create a new empty
  child on top of the target changeset, make the change there, verify it
  compiles and tests pass, then squash it in:
  ```
  jj new <target-change-id>          # empty child anchored to the right changeset
  # ... make changes, build, test ...
  jj squash --from @ --into <target-change-id> -- <files>
  ```
  This keeps verification safe (you're working in an isolated child) and avoids
  accidentally dirtying the wrong changeset in the stack. After squashing,
  remember to push any bookmarks that were rebased as a result.
- **Leave the fixup commit's description empty before squashing:** do not pass
  `-m` when creating a fixup child with `jj new`. If both commits have
  descriptions, `jj squash` opens an interactive editor, which blocks in
  non-interactive (agent) contexts. If a description was accidentally set, clear
  it first: `jj describe <fixup> -m ""`.
- **Inspecting a changeset: use `jj show`, never `jj new`:** use
  `jj show <revision>` or `jj diff -r <revision>`. Never use `jj new <revision>`
  for inspection — it moves `@` and updates the working directory, detaching the
  rest of the stack and creating orphaned commits.
- **Verify `@` after any squash into a lower changeset:** run `jj log` to
  confirm `@` is still sitting on top of the correct head. Squashing across a
  large stack gap rebases descendants and can silently leave `@` attached to the
  wrong point in the graph.

## Jira tickets

Work should be tracked by a Jira ticket. If the current task has no associated
Jira ticket, **prompt me before starting** and offer to create one. If I
accept, create the issue via the Jira/Atlassian tooling, assign it to me, and
fill in a useful description (what the work is, why, and acceptance criteria
where they're clear). Then use that ticket in the bookmark name.

## Small, stacked changesets

Split work into small changesets, each building on the previous. Aim for
**≤~300 total lines** per changeset (production, tests, docs, and config all
count). Review quality drops sharply beyond 200–400 lines.

- Plan the changeset boundaries up front.
- Each changeset includes the tests for the code it introduces — a changeset
  is not complete without passing tests covering its new behavior.
- Each changeset must independently pass all CI checks.
- Pause at the end of each changeset and collect feedback before moving on to
  the next one.

## Conventional Commits

Commit/changeset descriptions use [Conventional Commits](https://www.conventionalcommits.org/):
`<type>(<scope>): <short summary>` — e.g. `feat(api): add pagination`.
Common types: `feat`, `fix`, `chore`, `refactor`, `test`, `docs`.

## CI gate — every changeset must pass

Before considering a changeset complete, verify (using whatever the repo's
task runner / toolchain provides):

1. Format check
2. Build / compile
3. Lint
4. Tests (or the relevant subset)

A changeset that breaks any of these is not ready for review.

## Test-Driven Development

Follow **red → green → refactor**:

1. **Red:** write a failing test describing the desired behavior.
2. **Green:** write the minimum code to make it pass.
3. **Refactor:** clean up while keeping tests green.

## Code review before complete

Once a changeset passes CI, run the `/code-review` skill for an adversarial
review of the diff before considering it complete — it surfaces bugs, security
issues, and correctness problems rather than style. Exercise judgment on each
finding and address what matters before presenting the changeset.

## Plan validation

For any non-trivial task (multiple files, architectural decisions, unfamiliar
code), spawn a subagent to sanity-check the plan **before** implementing —
course-corrections are cheapest then. Optionally do the same after implementing
to check test coverage and edge cases.

## Documentation

Document all new and modified items — **public and private** — using the
language's doc-comment convention (Rustdoc, JSDoc, docstrings, etc.).

- Public items: summary, detailed description, arguments, errors, examples,
  cross-references where appropriate.
- Private items: at least a brief summary of what it is for and why it exists.
- Module-level docs describe the module's purpose and key types.

## Outward-facing prose

Load the `orwell-writing` skill before writing any Jira description or comment,
MR/PR description, Slack message, or Confluence page — including when the writing
is incidental to a coding task and I never asked for prose.

Keep these short: **Jira and MR descriptions are ~10 lines** — the problem, the
fix, acceptance criteria. Cut blame archaeology, "why it matters" essays, and
design-alternative weighing; one sentence suffices when a decision genuinely needs
recording. Keep reproduction steps, acceptance criteria, and cross-links.

This does **not** apply to doc comments, which stay thorough per the section
above.
