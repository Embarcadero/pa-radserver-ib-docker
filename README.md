# pa-radserver-ib-docker
Docker script for RAD Studio Linux deployment including RAD Server engine and InterBase database

To build using the Dockerfile use the build.sh script. Note: The Dockerfile requires the radserver_docker.sh script in the same directory
./build.sh 

To pull the Docker Hub version of pa-radserver-ib Docker use the pull.sh script
./pull.sh

To pull and run the Docker Hub version of pa-radserver-ib Docker for a non-production environment use the pull-run.sh script
./pull-run.sh

To run the Docker Hub version of pa-radserver-ib Docker use the run.sh script
./run.sh

To run the Docker Hub version of pa-radserver-ib Docker for in interbase only mode use the run-interbase-only.sh script
./run-interbase-only.sh

To configure the emsserver.ini file of an already running instance of pa-radserver-ib run the config.sh script
./config.sh
The config.sh script will restart apache automatically. 

The Solutions directory contains possible usage scenarios for using the pa-radserver-ib Docker image. 
The Custom-RAD_Server-Module solution is for the scenario in which the user has a custom module they want to deploy to RAD Server. The custom endpoint resource module needs to be in the same directory as the Dockerfile when the build-run.sh script is called. 
./build-run.sh [module file name]
./build-run.sh samplemodule.so

This software is Copyright 2019,2022 Embarcadero Technologies, Inc.

You may only use this software if you are an authorized licensee of an Embarcadero developer tools product. This software is considered a Redistributable as defined in the software license agreement that comes with the Embarcadero Products and is governed by the terms of such software license agreement (https://www.embarcadero.com/products/rad-studio/rad-studio-eula).
