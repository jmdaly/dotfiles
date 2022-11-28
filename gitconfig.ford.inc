[user]
	email = mruss100@ford.com
	signingkey = DE8210182994327F
[http]
	cookiefile = ~/dotfiles/dotfiles-secret/ford/gitcookies
[url "https://github.ford.com"]
	insteadOf = ssh://github.ford.com
[url "https://gist.github.ford.com"]
	insteadOf = ssh://gist.github.ford.com

[url "file:///f/phoenix/shallow-mirror/PHX-Codelinaro-LA.AU.1.4.6.r1-00600-with-widevine-and-vms"]
	insteadOf = ssh://gerrit.ford.com:29418/CODEAURORA/quic/la
	insteadOf = ssh://gerrit.ford.com:29418/AOSP
	insteadOf = ssh://gerrit-read.ford.com:29418/CODEAURORA/quic/la
	insteadOf = ssh://gerrit-read.ford.com:29418/AOSP

; vim: ft=gitconfig :
