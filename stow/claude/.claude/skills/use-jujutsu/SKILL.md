---
name: use-jujutsu
description: Comprehensive skill for Jujutsu (jj) VCS operations. Use this when the user needs to manage version control, translate Git commands to jj, query repository history with revsets, or resolve conflicts in a jj-managed repository.
---

# Jujutsu (jj) VCS Command & Workflow Guide

Jujutsu is a Git-compatible VCS that uses a "working-copy-as-a-commit" model. There is no "index" or "staging area."

## 1. Core Concepts for the Agent

*   **The Working Copy (@):** Your current changes are always part of a commit. You don't "stage" files; you simply edit them and then "describe" the change or create a "new" one.
*   **Change IDs vs. Commit IDs:** Use Change IDs (shorter, stable) for most commands. Use Commit IDs only when specifically needed for low-level Git interop.
*   **Operations:** Every command creates an "operation" in a log. Use `jj op log` and `jj undo` to navigate your own command history.

## 2. Orientation & Visibility (Critical)

Unlike Git, where you usually know which branch you are on, jj workflows often involve many "anonymous" changes.

*   **The Map:** Always use `jj log` (or `jj log -r "nodes()"` for a dense view) to see where you are in the changeset graph.
*   **Your Location:** Look for the `@` symbol in the log output. This indicates the current working-copy commit.
*   **Inspect a Revision:** Use `jj show <revision>` to see the description and diff of a specific change without switching to it.
*   **State Check:** Use `jj st` frequently. It summarizes the current Change ID, its parent, and any modified files.
*   **No Pager:** When running these as an Agent, always append `--no-pager` to ensure the full context is captured in the interaction logs.

## 3. Common Git to Jujutsu Translation

| **Git Command** | **Jujutsu Equivalent** | **Notes** |
| :---: | :---: | :---: |
| `git status` | `jj st` | Shows current change ID and modified files. |
| `git add` | (N/A) | Files are tracked automatically once created. |
| `git commit -m "msg"` | `jj describe -m "msg"` | Adds a message to the *current* open change. |
| `git commit --amend` | `jj describe -m "new msg"` | Just re-describe the current change. |
| `git checkout -b branch` | `jj bookmark create <name>` | "Bookmarks" are the equivalent of branches. |
| `git checkout <branch>` | `jj edit <bookmark>` | Moves the working copy to that bookmark. |
| `git log` | `jj log` | Shows a functional graph of changes. |
| `git show <commit>` | `jj show <revision>` | Inspects description and diff of a revision. |
| `git diff` | `jj diff` | Shows changes in the working copy. |
| `git push` | `jj git push` | Explicitly pushes bookmarks to Git remotes. |
| `git reset --hard` | `jj abandon` | Discards the current change and its edits. |

## 4. Bookmarks (Branches)

Bookmarks are pointers to specific revisions. Unlike Git branches, they do not move automatically unless you are at the "tip" of one.

*   **Create:** `jj bookmark create <name> -r <revision>`
*   **Move:** `jj bookmark set <name> -r <revision>`
*   **Delete:** `jj bookmark delete <name>`
*   **List:** `jj bookmark list`
*   **Remote Tracking:** `jj git push --bookmark <name>` or `jj git fetch`.

## 5. Working with Stacked Changes

Jujutsu encourages "stacking" small, logical changes. Navigating these requires understanding the difference between moving the *working copy* and moving the *edit focus*.

*   **Move Up (Toward head):** `jj next --edit`

    *Note:* Use `--edit` to move the actual working copy to the child. Without it, jj tries to create a *new* empty commit as a child of the descendant, which fails if the current working copy isn't empty.
*   **Move Down (Toward root):** `jj prev --edit`
*   **Edit Specific Revision:** `jj edit <revision>` (equivalent to checking out a specific commit in Git).
*   **Create New Child:** `jj new` (creates a fresh, empty working copy on top of `@`).
*   **Rebase Stack:** `jj rebase -s <bottom_of_stack> -d <new_parent>`.
*   **View Stack:** `jj log -r "ancestors(@) & ~ancestors(main)"`.

## 6. Advanced History & Revsets

Revsets are the "query language" of jj. Use `-r` to specify them.

### Essential Selectors

*   `mine()`: Changes authored by the current user.
*   `empty()`: Changes with no file modifications.
*   `conflicts()`: Changes containing merge conflicts.
*   `root()`: The virtual empty base of the repo.
*   `heads(selection)`: The latest changes in a set.
*   `bookmarks()`: All changes associated with a bookmark.

### Powerful Revset Examples

*   `jj log -r "mine() & ~empty()"`: Show my non-empty changes.
*   `jj log -r "description(regex:'fix')"`: Search messages for "fix".
*   `jj log -r "ancestors(@, 5)"`: Show the last 5 ancestors of the current work.
*   `jj diff -r @--..@`: Show the diff of the grandparent to the current change.

## 7. Operational Commands

*   **Create New Work:** `jj new` (creates a new change on top of the current one).
*   **Merge Changes:** `jj new revision1 revision2` (creates a merge commit).
*   **Squash/Amend:** `jj squash` (moves changes from `@` into its parent `@-`).
*   **Splitting:** `jj split` (interactive tool to break one change into two).

## 8. Conflict Management

*   `jj` allows commits to exist in a "conflicted" state.
*   Conflict markers look like `<<<<<<<`, `=======`, and `>>>>>>>`.
*   To resolve: Edit the file to remove markers and keep desired code, then `jj describe` or just continue working.

## 9. Workspaces (Parallel Working Copies)

Workspaces are jj's equivalent of Git worktrees: additional working copies attached to the same repo, each with its own working-copy commit. In `jj log` they appear as `<name>@`. Use one to run a slow build or test suite while you keep editing in another.

**Always create workspaces under `<repo-root>/.workspaces/<name>/`.** In a devcontainer only the repo directory is mounted, so a workspace anywhere else is invisible inside the container. A subdirectory of the repo is reachable from both the host and the container.

### Create

```
mkdir -p .workspaces    # jj does not create missing parent directories
jj --no-pager workspace add -r <revision> .workspaces/jd-BCT-2169-api
```

*   Run from the repo root; the destination path is resolved against the current directory.
*   **Name the directory after the bookmark, with `/` replaced by `-`:** bookmark `jd/BCT-2169-api` becomes directory `.workspaces/jd-BCT-2169-api`. Directory names cannot contain `/`.
*   `--name` defaults to the directory basename, so pass it only when the workspace name should differ from the directory.
*   Without `-r`, the new working copy is created on the *parents* of `@` — an empty sibling of your current change, which is rarely what you want. Pass `-r` with a bookmark, `@`, or a change ID.

### Manage

*   **List:** `jj --no-pager workspace list` — name, path, and current change for each workspace. Paths are relative to the current directory.
*   **This workspace's root:** `jj --no-pager workspace root` — returns the *workspace* root, not the repo root. Inside a nested workspace it returns the nested directory.
*   **Locate in the graph:** `jj --no-pager log` marks each working copy as `default@`, `<name>@`.

### Remove

```
jj --no-pager workspace forget <name>
rm -rf .workspaces/<name>
```

`forget` only stops tracking the working-copy commit; it never touches the directory, so delete it yourself. Full cleanup is four steps, and skipping any of them leaves something behind:

*   `jj --no-pager bookmark delete <bookmark>` if the workspace had one and you no longer want it.
*   `jj --no-pager workspace forget <name>`.
*   `jj --no-pager abandon <change-id>` — **`forget` does not abandon a non-empty working-copy commit.** It survives as a descriptionless change off to one side of the graph. Note the change ID *before* forgetting; afterwards it is easy to overlook. Skip this step only when you mean to keep the work.
*   `rm -rf .workspaces/<name>`, plus any build output directory you pointed the workspace at.

Then confirm nothing survived: `jj --no-pager workspace list` shows only the workspaces you expect, and `jj --no-pager log -r 'description(exact:"") ~ empty()'` lists no stray changes.

### One change per workspace

jj will let two workspaces sit on the same change, but as soon as one of them edits a file the other becomes **stale** and every command there fails:

```
Error: The working copy is stale (not updated since operation ...).
```

Recover with `jj --no-pager workspace update-stale`. Avoid it by giving each workspace its own change and bookmark.

### Build output directories — Rust/cargo projects only

**This subsection applies only to cargo projects.** Other toolchains may need their own equivalent, or none at all; check before assuming.

**Give every workspace its own `target/` directory, and never point two workspaces at the same one.** Cargo derives a workspace member's `-C metadata` without reference to the checkout path, so two workspaces building the same crate write the *same* `libfoo-<hash>.rlib` and the same test binary. Last writer wins, and cargo's mtime-based freshness check then serves that stale binary to the other workspaces without recompiling. The gate passes, the numbers look plausible, and the results belong to a different checkout — a test you just added never runs, or a test that exists in no local source file does.

By default each workspace already builds into its own `<workspace>/target`, which is correct. Override it only for a reason — in a devcontainer on a macOS or Windows host, a workspace's `target/` lands on the host bind mount, where concurrent `rustc` writes intermittently fail with `E0463: can't find crate for <dep>` on the line after that dep compiled successfully. Put the directory on a native filesystem instead (inside the container's docker volume, for example), still one per workspace:

```toml
# <workspace>/.cargo/config.toml
[build]
target-dir = "/workspaces/<repo>/target/ws/<name>"
```

*   **If the workspace already has a `.cargo/config.toml`, edit it — never overwrite it.** Set or replace only the `build.target-dir` key and leave every other table alone; the file may carry registry definitions, target rustflags, or credential providers the build needs. A tracked `.cargo/config.toml` is copied into each new workspace, so expect to find one there.
*   The deepest `.cargo/config.toml` wins, so a per-workspace file overrides the repo-root one.
*   `build.target-dir` is resolved against the config file's own directory, but prefer an absolute path so the value cannot follow the workspace around.
*   **jj snapshots this file into your change.** `.cargo/config.toml` is untracked in most repos and nothing ignores it, so `jj st` reports `A .cargo/config.toml` and the next `jj describe` carries it into the commit — and into the push. What leaks is an absolute path valid on one machine, so merging it redirects every other developer's and CI's build output to a directory they do not have. Either add `.cargo/config.toml` to the repo's tracked `.gitignore` — it is then copied into every future workspace — or skip the file and use the inline export below.
*   **`CARGO_TARGET_DIR` is the safer choice for a short-lived workspace, but only inline.** Set it in the same command as the build (`CARGO_TARGET_DIR=/workspaces/<repo>/target/ws/<name> just clippy`), where it cannot reach a commit and cannot outlive the command. **Never put it in a shell profile or `mise.toml`:** one value applied tree-wide overrides every `build.target-dir` at once and silently puts all workspaces back in one directory — the clobbering this section exists to prevent. The cost of inline is that omitting it on a single command is quiet: cargo falls back to `<workspace>/target` on the host mount, and you get the `E0463` race described above, later and with no obvious cause.
*   Budget the disk: a full gate can leave tens of gigabytes per workspace. Remove the directory when you remove the workspace.

**Verify by name, not by exit code.** After a gate passes in a workspace, grep the run log for the name of a test that workspace added. Green proves the build ran; only the name proves it ran *your* code.

**Check `jj st` before you describe.** Setting a workspace up writes files — a build config, a tool cache, a scratch script — and jj snapshots every one of them that is not ignored. Run `jj --no-pager st` once after setup and again immediately before `jj describe`, and confirm the listing holds source files only. This catches the whole class, not just `.cargo/config.toml`.

### Ignore the workspace directory

jj does not snapshot nested workspaces into the parent working copy — it skips directories containing `.jj`, so `jj st` stays clean on its own, whatever your ignore rules say. Add `.workspaces/` to `.gitignore` anyway, so colocated `git`, ripgrep, test discovery, and IDE indexing skip it.

## 10. Constraints & Safety

*   **No Git Commands:** Never run `git` commands inside a `.jj` repo.
*   **Pager Handling:** Always use `--no-pager` for Agent-initiated commands.
*   **Snapshotting:** `jj` snapshots the working copy on every command.

## 11. Troubleshooting

*   **Divergence:** If a change ID exists in two versions, use `jj rebase` or `jj abandon`.
*   **Push Failure:** `jj git fetch` first, then `jj rebase` your work onto the remote bookmark.
*   **"The working copy is stale":** Another workspace moved the change you were on. Run `jj --no-pager workspace update-stale`, then give each workspace its own change.
*   **"Working copy must not have children":** You likely tried `jj next` without `--edit`. If you want to move your focus to the next revision in the stack, use `jj next --edit`.
*   **A test you just added never runs, or a test from another workspace does (cargo):** two workspaces are sharing a build directory and serving each other stale binaries. Give each its own — see *Build output directories* above.
*   **`E0463: can't find crate for <dep>` right after that dep compiled (cargo in a devcontainer):** the build directory is on a macOS or Windows host bind mount, where the write is not yet visible to the next `rustc`. It succeeds on retry; move the directory onto a native filesystem to stop it recurring.

