First, set up the global gitignore file location:
git config --global core.excludesfile ~/.gitignore_global

Then, add the patterns you want to ignore to that file (using UTF-8 encoding):
echo "desktop.ini" | Out-File -FilePath ~/.gitignore_global -Encoding utf8

The first command tells Git where to find your global ignore file, and the second command actually adds the pattern to ignore desktop.ini files, saving it in UTF-8 encoding.

You can verify that both worked by:
Checking if the file exists and has content:
cat ~/.gitignore_global

Checking if Git is actually ignoring the file:
git check-ignore -v desktop.ini

To remove the global gitignore configuration, you can run:
git config --global --unset core.excludesfile

This will remove the global gitignore file setting. If you also want to delete the actual .gitignore_global file, you can run:
rm ~/.gitignore_global

Testing
echo test > desktop.ini  
git check-ignore -v desktop.ini

Only working scripts are setup_git_icons and undo_git_icons
TODO: dev branch