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

## 9. Constraints & Safety

*   **No Git Commands:** Never run `git` commands inside a `.jj` repo.
*   **Pager Handling:** Always use `--no-pager` for Agent-initiated commands.
*   **Snapshotting:** `jj` snapshots the working copy on every command.

## 10. Troubleshooting

*   **Divergence:** If a change ID exists in two versions, use `jj rebase` or `jj abandon`.
*   **Push Failure:** `jj git fetch` first, then `jj rebase` your work onto the remote bookmark.
*   **"Working copy must not have children":** You likely tried `jj next` without `--edit`. If you want to move your focus to the next revision in the stack, use `jj next --edit`.

