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

echo "[INFO] Loading system variable to find qmake path"
#source /etc/environment
echo "[INFO] Building application..."
PROJ_NAME=Txt2XL
PROJ_ROOT_DIR=$PWD
cd ..
APP_RELEASE_DIR=$PWD/build-Txt2XL/linux/desktop/x64/release

echo "Project root directory : $PROJ_ROOT_DIR"
echo "Release directory : $APP_RELEASE_DIR"

checkAndMakeDirectories (){

if [ -e $APP_RELEASE_DIR ]
   then 
   	echo "Release directory already exists."
   	return 0;
   else
   	
   	if [ -w $PWD ]
   	   then
   	       echo "The current directory is writabale."
   	       echo "Release directory not exists."
   	       echo "Creating sub-directories for application release..."
   	       cd ..
   	       mkdir -p $APP_RELEASE_DIR
   	       cd $APP_RELEASE_DIR
		dir_STATUS=$?
		if [ $dir_STATUS == 0 ]
	   	   then
	       	echo "Release and its sub-directories created successfully."
	       	return 0;
	   	   else
	       	echo "Failed to create release and its sub-directories."
	       	return 1;
		fi
   	   else
   	       echo "The current directory is not writable."   
   	       return 1;
   	fi
fi
}  	        
   

checkIfGccInstalled (){
	gcc -v	&> /dev/null
	gcv_STATUS=$?
	if [ $gcv_STATUS == 0 ]
	   then
	       echo "GCC compiler toolchains are installed."
	       return 0;
	   else
	       echo "GCC compiler toolchains are not installed."
	       return -1;
	 fi
}

checkIfCmakeInstalled (){
	cmake -version	&> /dev/null
	cmv_STATUS=$?
	if [ $cmv_STATUS == 0 ]
	   then
	       echo "Cmake is installed."
	       return 0;
	   else
	       echo "Cmake is not installed."
	       return -1;
	 fi
}      	 


checkIfQmakeInstalled (){
	qmake -v &> /dev/null	
	qmv_STATUS=$?
	if [ $qmv_STATUS == 0 ]
	   then
	       echo "QT C++ Framework is installed."
	       return 0;
	   else
	       echo "QT C++ Framework is not installed."
	       return -1;
	 fi
}      	 



buildToolsStatus (){

source /etc/environment  		 

checkIfGccInstalled
gc_STATUS=$?

if [ $gc_STATUS == 0 ]
   then
       checkIfCmakeInstalled
       cm_STATUS=$?
   	if [ $cm_STATUS == 0 ]
   	   then 
   	   	checkIfQmakeInstalled
   	   	qt_STATUS=$?
   	       if [ $qt_STATUS == 0 ]
   		  then
   		      echo "Build tools setup done correctly..."    
   		      return 0;      
   		  else
       	      echo "Install Qt c++ framework to proceed."
       	      return 2;
              fi      
          else
              echo "Install cmake to proceed."
              return 2;
       fi       
   else
       echo "Install gcc to proceed."   
       return 2;         	      
fi

}


buildAppStatus (){

if [ $bt_STATUS == 0 ] 
   then 
   	echo "Ready to build..."
   	
       checkAndMakeDirectories 
	cm_STATUS=$?

	if [ $cm_STATUS == 0 ]
   	   then
               echo "------------------------" 
               echo "Cx Bx Dir : $PWD"
               cd $APP_RELEASE_DIR
               echo "Release dir : $APP_RELEASE_DIR" 
		qmake ../../../../../$PROJ_NAME/
		make
		mk_Status=$?
		if [ $mk_Status == 0 ]
		   then 
			echo "[INFO] Cleaning directory..."
			echo "[INFO] Current directory $PWD"
			echo "[INFO] Application build successfully."
			#$APP_BUILD_STATUS=0;
			return 0;
		   else
		   	echo "Failed to build the application."
		   	#$APP_BUILD_STATUS=1;	
		   	return 1;
	       fi
   	   else
       	echo "Move your project to writable location and try again building the application."
       	return 1;
       fi
    else
        echo "Building tools setup failed..!"
        return 1;
fi        
}
   	
	            
#Execution entry point

buildToolsStatus
bt_STATUS=$?
buildAppStatus $bt_STATUS
APP_BUILD_STATUS=$?
echo "BS : $APP_BUILD_STATUS"            	
export APP_BUILD_STATUS              		
		
