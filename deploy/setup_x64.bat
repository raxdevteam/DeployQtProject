@ECHO OFF &SETLOCAL

:------------------------------------------------------------------------+
:                BATCH SCRIPT TO CALL QtDEPLOYER  x64                    |
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

	    cmd /c %cd%\tools\Windows\Script\deployQtCppAppRelease_x64.bat 

	    SET deployBaseDir=%cd%

:ECHO [INFO] Digitally signing application with self-signed certificate...
:/t http://timestamp.digicert.com -->use this when internet connected
:signtool.exe sign /t http://timestamp.digicert.com /f %deployBaseDir%\tools\Windows\SignApp\rajeev.pfx /p r9820112511r %deployBaseDir%\buildInstaller\windows\tmp\Txt2Excel.exe
:ECHO [INFO] Verifying signature...
:signtool.exe verify /pa /v %deployBaseDir%\buildInstaller\windows\tmp\Txt2Excel.exe
ECHO [INFO] .....................

ECHO ---------------------------------------
ECHO [INFO] Creating inno compiler script...
ECHO ---------------------------------------
	
ECHO [INFO] Deploy base directory %deployBaseDir%
	SET "file=%cd%\tools\Windows\Script\createInstaller_x64.iss"
:change line number of property rootDir in createInstaller_x64.iss
	SET /a Line#SearchDistKitDir=19   
:change line number of property baseDir in createInstaller_x64.iss
	SET /a Line#SearchBaseDir=20  
	SET "ofile=%cd%\buildInstaller\windows\tmp\installer_x64.iss"

	SET replaceDistKitDir=#define DistKitDir "%cd%\buildInstaller\windows\DistributionKit_x64"
	SET replaceBaseDir=#define BaseDir "%cd%"

ECHO [INFO] Distribution kit directory : %replaceDistKitDir%
ECHO [INFO] Base directory : %replaceBaseDir%

	(FOR /f "tokens=1*delims=:" %%a IN ('findstr /n "^" "%file%"') DO (
     		SET "Line=%%b"
         		IF %%a equ %Line#SearchDistKitDir% SET "Line=%replaceDistKitDir%"
         		IF %%a equ %Line#SearchBaseDir% SET "Line=%replaceBaseDir%"
     		SETLOCAL ENABLEDELAYEDEXPANSION
   	   ECHO(!Line!
   	   ENDLOCAL
	 ))>"%ofile%"

	    TYPE "%ofile%"

	SET setupFileName=%cd%\buildInstaller\windows\tmp\installer_x64.iss
ECHO [INFO] Script : %setupFileName%
	    %cd%\tools\Windows\InoCompiler\iscc "%setupFileName%"

:ECHO [INFO] Digitally signing installer with self-signed certificate...
:/t http://timestamp.digicert.com -->use this when internet connected
:signtool.exe sign /t http://timestamp.digicert.com /f %deployBaseDir%\tools\Windows\SignApp\rajeev.pfx /p r9820112511r %deployBaseDir%\buildInstaller\windows\Txt2Excel_x64_setup.exe
:ECHO [INFO] Verifying signature...
:signtool.exe verify /pa /v %deployBaseDir%\buildInstaller\windows\Txt2Excel_x64_setup.exe


ECHO [INFO] Cleaning directories...
ECHO [INFO] Removing DistributionKit_x64 content...
	    %cd%\tools\Windows\Util\rm -rf %cd%\buildInstaller\windows\DistributionKit_x64
ECHO [INFO] Removing Qml content...
	    %cd%\tools\Windows\Util\rm -rf %cd%\buildInstaller\windows\tmp
ECHO [INFO] Directory cleaning done..!

ECHO --------------------------------
ECHO  Setup created successfully..! 
ECHO --------------------------------
