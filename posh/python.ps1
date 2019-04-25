# Load a python environment

if (!(Get-Variable python_venv_dir -Scope Global -ErrorAction SilentlyContinue))
{
	$python_venv_dir = "$env:userprofile\.virtualenvs"
}

# If it exists, load our python virtualenv
if (Test-path "$python_venv_dir")
{
	Write-Host "`nLoading python virtual env." -ForegroundColor Yellow
	if (Test-path "$python_venv_dir\default\Scripts")
	{
		$python_venv_invoke = $python_venv_dir + "\default\Scripts\activate.ps1"
	}
	else
	{
		$python_venv_invoke = $python_venv_dir + "\default\bin\activate.ps1"
	}
	Invoke-Expression $python_venv_invoke
}

# vim: ts=4 sw=4 sts=0 noexpandtab ffs=dos ft=ps1 :
