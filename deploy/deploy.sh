#:------------------------------------------------------------------------+
#:                  SHELL SCRIPT TO BUILD APPLICATION                     |
#:------------------------------------------------------------------------+
#: Author      : Rajeevkumar Rai                                          |
#: Date        : 11th Nov, 2020                                           |
#: Program     : MERS_X                                                   |
#: Description : Convert any Text file to Excel with customization option |
#: Copyright   : GNU GPL V3 #DARE DRDO                                    |
#:------------------------------------------------------------------------+
#: This file will call QtDeployer to collect all dependencies & supported |
#: files to run the binary as standalone application on any system        |
#:------------------------------------------------------------------------+

echo "-------------DEPLOYING------------"
PROJ_ROOT_DIR=$PWD
cd ..
APP_FILE=$PWD/build-Txt2XL/linux/desktop/x64/release/bin/Txt2XL
cd Txt2XL
echo "Dx di : $PWD"
echo "Project root directory : $PROJ_ROOT_DIR"
echo "Application file path  : $APP_FILE"
echo "----------------------------------"
echo "Checking environment variables..."
source /etc/environment	
echo "Changing file permission for build script..."
chmod 777 ./build.sh
echo "Changing file permission for setup_x64 script..."
chmod 777 ./deploy/setup_x64.sh
echo "Changing file permission for linuxdeployqt-5 executable..."
chmod 777 ./deploy/tools/Linux/linuxdeployqt-5.AppImage

#Check if application executable file build or not 
checkValidAppFile (){
if [ -e $APP_FILE ]
   then 
   	echo "Application file build and exists."
   	if [ -x $APP_FILE ]
	   then
   	       echo "File has execute permission."
   	       if [ -s $APP_FILE ]
   	          then 
   	              echo "File size is not zero."
   	              return 0;
   	          else
   	              echo "File size is zero."
   	              return -1;
   	       fi    
	   else
   	       echo "File does not have execute permission."
   	       return -1;
	fi   

   else
   	echo "Application file not build yet."
   	return -1;
fi 
}

#Check whether deploy or first build and then deploy 
buildAndDeploy (){
	
	checkValidAppFile
	af_STATUS=$?
	if [ $af_STATUS == 0 ]
	   then
	       echo "Start deploying application..."
	           return 0;
	   else
	       echo "Start building application..."
	           return 1;
	fi

}


#Entry point for execution
	
buildAndDeploy
STATUS=$?
echo "Status : $STATUS"
if [ $STATUS == 0 ]
   then
	echo "[INFO] Deploying application..."
	cd $PROJ_ROOT_DIR/deploy
	echo "[INFO] Current directory : $PWD"
	./setup_x64.sh 

	
	
   elif [ $STATUS == 1 ]
        then
            #./build.sh
            source ./build.sh
             cd $PROJ_ROOT_DIR/deploy
             
	     echo "App build status : $APP_BUILD_STATUS"
	     if [ $APP_BUILD_STATUS == 0 ]
	         then
	             echo "Deploying application..."
	     	     echo "Dx Current directory $PWD"
	    	     ./setup_x64.sh 
                 else
                     echo "App could not be deployed."
	     fi	
	else
	    echo "Can not build or deploy application..."
fi	    







   



