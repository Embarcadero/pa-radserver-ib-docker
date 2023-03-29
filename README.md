# pa-radserver-ib-docker

Docker script to build RAD Studio Linux deployment including RAD Server engine and InterBase database

- Container available on [Docker Hub](https://hub.docker.com/r/radstudio/pa-radserver-ib)
- DocWiki [PAServer Documentation](http://docwiki.embarcadero.com/RADStudio/en/PAServer,_the_Platform_Assistant_Server_Application)
- DocWiki [RAD Server Docker Deployment](https://docwiki.embarcadero.com/RADStudio/en/RAD_Server_Docker_Deployment)
- More information on [InterBase](https://docwiki.embarcadero.com/InterBase/2017/en)
- More information on [RAD Studio](https://www.embarcadero.com/products/rad-studio)
- Other containers: [PAServer](https://github.com/Embarcadero/paserver-docker) and [RAD Server container](https://github.com/Embarcadero/pa-radserver-docker).

The image defaults to running **PAServer** on port `64211` with the _password_ `securepass`, and **Broadwayd** on port `8082`

The 10.x images use Ubuntu 18.04.6 LTS (Bionic Beaver) while the 11.x images use Ubuntu 22.04.1 LTS (Jammy Jellyfish)

## Instructions

If you want to modify or build from GitHub without using [Docker Hub](https://hub.docker.com/r/radstudio/pa-radserver-ib), you can build the Dockerfile use the `build.sh` script. Note: The Dockerfile requires the `radserver_docker.sh` script in the same directory
```
./build.sh 
```

To pull the [Docker Hub version of pa-radserver-ib](https://hub.docker.com/r/radstudio/pa-radserver-ib) image use the `pull.sh` script
```
./pull.sh
```
or
```
docker pull radstudio/pa-radserver-ib:latest
```
Where `latest` is the desired tag.

To pull and run the [Docker Hub](https://hub.docker.com/r/radstudio/pa-radserver-ib) version of pa-radserver-ib Docker for a debug/non-production environment use the `pull-run.sh` script
```
./pull-run.sh
```

To run the [Docker Hub version of pa-radserver-ib Docker](https://hub.docker.com/r/radstudio/pa-radserver-ib) use the `run.sh` script
```
./run.sh
```

To run the [Docker Hub version of pa-radserver-ib Docker](https://hub.docker.com/r/radstudio/pa-radserver-ib) for in InterBase only mode use the `run-interbase-only.sh` script
```
./run-interbase-only.sh
```

To configure the `emsserver.ini` file of an already running instance of *pa-radserver-ib* run the `config.sh` script
```
./config.sh
```
The config.sh script will restart apache automatically. 

The Solutions directory contains possible usage scenarios for using the *pa-radserver-ib Docker* image. 
The `Custom-RAD_Server-Module` solution is for the scenario in which the user has a custom module they want to deploy to RAD Server. The custom endpoint resource module needs to be in the same directory as the Dockerfile when the `build-run.sh` script is called. 
Usage: `./build-run.sh [module file name]`

Example:
```
./build-run.sh samplemodule.so
```
--- 

This software is Copyright &copy; 2023 by [Embarcadero Technologies, Inc.](https://www.embarcadero.com/)

_You may only use this software if you are an authorized licensee of an Embarcadero developer tools product. See the latest [software license agreement](https://www.embarcadero.com/products/rad-studio/rad-studio-eula) for any updates._

![Embarcadero(Black-100px)](https://user-images.githubusercontent.com/821930/211648635-c0db6930-120c-4456-a7ea-dc7612f01451.png#gh-light-mode-only)
![Embarcadero(White-100px)](https://user-images.githubusercontent.com/821930/211649057-7f1f1f07-a79f-44d4-8fc1-87c819386ec6.png#gh-dark-mode-only)
