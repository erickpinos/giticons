giticons replaces the icons of folders related to git projects so you can easily see which projects are git enabled.

When running giticons.bat, a desktop.ini file gets added to each folder that contains a .git file.

Since by default, desktop.ini will be committed, you have to add it to .gitignore_global by doing the following:

First, open PowerShell and set up the global gitignore file location:
git config --global core.excludesfile "$env:USERPROFILE\.gitignore_global"

Then, add the patterns you want to ignore to desktop.ini files (using UTF-8 encoding):
echo "desktop.ini" | Out-File -FilePath "$env:USERPROFILE\.gitignore_global" -Encoding utf8

You can verify that both worked by:
Checking if the file exists and has content:
cat "$env:USERPROFILE\.gitignore_global"

Checking if Git is actually ignoring the file:
git check-ignore -v desktop.ini

To remove the global gitignore configuration, you can run:
git config --global --unset core.excludesfile

This will remove the global gitignore file setting. If you also want to delete the actual .gitignore_global file, you can run:
rm "$env:USERPROFILE\.gitignore_global"

Only working scripts are setup_git_icons and undo_git_icons

Run this on PowerShell to add the giticons folder on Path to run giticons from anywhere
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\your\folder\path", "User")

Run this in admin PowerShell to allow scripts:
Set-ExecutionPolicy RemoteSigned

Choose Y to confirm


TODO: dev branch