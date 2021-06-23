@ECHO OFF &SETLOCAL

:------------------------------------------------------------------------+
:                  BATCH SCRIPT TO BUILD APPLICATION                     |
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

SET buildDir=%cd%
ECHO Build directory %buildDir%

mkdir build
cd build

mkdir windows
cd windows

mkdir desktop
cd desktop

mkdir x64
cd x64

mkdir release
cd release

ECHO Current directory %cd%
ECHO Build directory %buildDir%

qmake %buildDir%

make

ECHO [INFO] Cleaning directory...
ECHO [INFO] Application build successfully.

