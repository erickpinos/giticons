@echo off
if "%1"=="undo" (
  powershell -File "%~dp0undo_git_icons.ps1"
) else if "%1"=="folders" (
  powershell -File "%~dp0setup_git_parent_folder_icons.ps1"
) else if "%1"=="undo folders" (
  powershell -File "%~dp0undo_git_parent_folder_icons.ps1"
) else (
  powershell -File "%~dp0setup_git_icons.ps1"
)

REM TODO: add flexibility for which folders to scan
REM TODO: add different icons depending on who is the owner of git remote
REM ISSUE: giticons adds desktop.ini to all folders, which then gets caught in git commit