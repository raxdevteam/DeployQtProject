#:------------------------------------------------------------------------+
#:              SHELL SCRIPT TO CALL LINUX_DEPLOY_QT_IMAGE                |
#:------------------------------------------------------------------------+
#: Author      : Rajeevkumar Rai                                          |
#: Date        : 11th Nov, 2020                                           |
#: Program     : Text2Excel                                               |
#: Description : Convert any Text file to Excel with customization option |
#: Copyright   : GNU GPL V3 #DARE DRDO @2020                              |
#:------------------------------------------------------------------------+
#: This file will create a stand alone x64 application by bundling all    |
#: dependencies files generated required to run on linux system.          |
#:------------------------------------------------------------------------+

DEPLOY_DIR=$PWD #Deploy directory
cd ..  #Move to project root directory
PROJ_ROOT_DIR=$PWD
cd ..
APP_RELEASE_DIR=$PWD/build-Txt2XL/linux/desktop/x64/release/build
LNX_QT_DEPLOYER=$DEPLOY_DIR/tools/Linux/linuxdeployqt-5.AppImage
cd Txt2XL
echo "Project directory : $PROJ_ROOT_DIR"
echo "Release directory : $APP_RELEASE_DIR"
echo "DEPLOYER TOOL PATH : $LNX_QT_DEPLOYER"

#Check if application executable file build or not 
checkDeployerToolStatus (){
if [ -e $LNX_QT_DEPLOYER ]
   then 
   	echo "QT Linux Deployer found and exists."
   	if [ -x $LNX_QT_DEPLOYER ]
	   then
   	       echo "Application has execute permission."
   	       return 0;    
	   else
   	       echo "Application does not have execute permission."
   	       return 1;
	fi   

   else
   	echo "$LNX_QT_DEPLOYER could not found..."
   	echo "Copy the above file to its location and try again.!"
   	return 1;
fi 
}

copyResources (){

	echo "Copying resources..." 
	sleep 2
	cd deploy
	echo "Deploy directory : $PWD"
	echo "Copying icon file to release directory..."
	cp ./tools/Linux/resource/icon.png $APP_RELEASE_DIR/
	sleep 1
	echo "Copying desktop file to release directory..."
	cp ./tools/Linux/resource/Txt2XL.desktop.desktop $APP_RELEASE_DIR/
	sleep 1
}

deployApp (){

echo "Collecting dependencies..."
sleep 3

./tools/Linux/linuxdeployqt-5.AppImage $APP_RELEASE_DIR/Txt2XL -exclude-libs=lib/libgcrypt.so.20,lib/libgssapi_krb5.so.2,lib/libk5crypto.so.3,lib/libkrb5.so.3,lib/libkrb5support.so.0,lib/liblz4.so.1,lib/liblzma.so.5,lib/libpng16.so.16,lib/libQt5VirtualKeyboard.so.5,lib/libQt5Network.so.5,lib/libQt5Qml.so.5,lib/libQt5QmlModels.so.5,lib/libQt5Quick.so.5,plugins/platforminputcontexts/libqtvirtualkeyboardplugin.so -no-translations -always-overwrite  -verbose=2 -appimage

echo "Packaging runtime binaries and libararies..."
sleep 5
echo "Application deployed successfully.!"

echo "Creating directory for standalone app..."
sleep .5
echo "Moving generated app..."
sleep 1
mv $DEPLOY_DIR/Txt2XL-x86_64.AppImage $APP_RELEASE_DIR/
sleep 2
echo "The application can be found in directroy : $APP_RELEASE_DIR"

}



checkDeployerToolStatus
dt_STATUS=$?

if [ $dt_STATUS == 0 ]
   then 
   	copyResources
   	deployApp
   else	
       echo "Can not deploy application."
fi       
