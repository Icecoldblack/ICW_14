@echo off
cd /d "%~dp0"
git init
git add .
git commit -m "ICW 14: Firebase Cloud Messaging in Flutter"
git branch -M main
git remote add origin https://github.com/Icecoldblack/ICW_14.git
git push -u origin main
pause
