@ECHO OFF &SETLOCAL

:------------------------------------------------------------------------+
:                  BATCH SCRIPT TO DEPLOY APPLICATION                    |
:------------------------------------------------------------------------+
: Author      : Rajeevkumar Rai                                          |
: Date        : 11th Nov, 2020                                           |
: Program     : MERS_X                                                   |
: Description : Convert any Text file to Excel with customization option |
: Copyright   : GNU GPL V3 #DARE DRDO                                    |
:------------------------------------------------------------------------+
: This file will call QtDeployer to collect all dependencies & supported |
: files to run the binary as standalone application on any system        |
:------------------------------------------------------------------------+

ECHO [INFO] Building application...
cd deploy
ECHO [INFO] Current directory %cd%
cmd /c %cd%\setup_x64.bat 

ECHO [INFO] Cleaning directory...
ECHO [INFO] Application build successfully.
echo ---------------------------------------
echo [INFO] Deploy Director : %cd%
     cd ..
echo [INFO] Base Directory : %cd%

echo [INFO] Building project documents...
     doxygen Doxyfile
wcho [INFO] Project documentation can be found in docs directory.
echo ---------------------------------------
echo 
