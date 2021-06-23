@echo off 
SET BASE_DIR=%~dp0
SET PATH=%BASE_DIR%\lib\;%PATH%

call "%BASE_DIR%\bin\cqtdeployer.exe" %* 
