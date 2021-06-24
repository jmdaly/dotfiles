# Troubleshooting

Last time the agent wouldn't connect while I was ssh'ed into khea:
- Use `journalctl -f` to get better output.  In my case it was the pinentry program
- Issue:
```bash
export GPG_TTY=$(tty)
gpg-connect-agent updatestartuptty /bye >/dev/null
```
- May want to force a tty pinentry in in `~/.gnupg/gpg-agent.conf`
```
pinentry-program /usr/bin/pinentry-tty
```
then reload with
```bash
gpg-connect-agent reloadagent /bye
```

- I'm not sure why zsh only sets GPG_TTY if gconf doesn't exist... That seems wrong.
