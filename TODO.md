x small tweak:  change this text in feature-merge: "You may want to push this branch to the remote origin now. 'git push'"
x small change: remove helpful merge reminder from 'git flux feature status' output
x small change: in 'git flux publish' output, drop prefix from first 2 bullets of action summary
- might need a way to delete remote feature branches, ie: `git flux feature delete <name>`. should delete local, and if remote exists, delete it too? or '-r' to delete remote?
- might need a `git flux feature clean` to remove any local feature branches that are no longer on the remote.

- allow multiple environments on `git flux feature merge FEATURE [env, env, env, ...]`
- allow multiple feature or env branches on `git flux publish ..`
x after `git flux feature merge`, switch back to current branch instead of the merged environment branch
x update 'contributing' section of readme to say that git-flow should be installed
