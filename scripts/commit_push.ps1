param([string]$msg = "Update")
git add -A
git commit -m "$msg"
git push