# Aliases for git.  This is done seperately to oh-my-posh in case I want the
# aliases without loading the entire environment.
Write-Host "Loading git-aliases" -ForegroundColor Yellow

# originally I had to do this, but maybe posh-git takes care of it?  Uncertain,
# leaving this for now.  It's also super slow.
# Install-Module git-aliases -Scope CurrentUser -AllowClobber
Import-Module git-aliases

# Override
function gst { git status -uno -sb $args }

# vim: ts=4 sw=4 sts=0 noexpandtab ffs=dos ft=ps1 :
