# cids-docker-images

cids-docker-images + [cids-docker-volumes](https://github.com/cismet/cids-docker-volumes) = dockerized cids systems

## cids-integration-base

PostgreSQL + PostGIS RDBMS [docker images](https://hub.docker.com/r/cismet/cids-integration-base/) for cids-integration-base dumps (plain sql + pgdump backups)

#### Tags

- latest

- **[postgres-9.6.1-2.0](https://github.com/cismet/cids-docker-images/releases/tag/postgres-9.6.1-2.0)**: PostgreSQL 9.6.1 with PostGIS 2.3.0 for cids-distrubution images

- **[postgres-9.0.3-2.0](https://github.com/cismet/cids-docker-images/releases/tag/postgres-9.0.3-2.0)**: PostgreSQL 9.0.3 with PostGIS 1.5.5 for cids-distrubution images

- **[postgres-9.6.1](https://github.com/cismet/cids-docker-images/releases/tag/postgres-9.6.1)**: Legacy PostgreSQL 9.6.1 with PostGIS 2.3.0 (deprecated)

- **[postgres-9.0.3](https://github.com/cismet/cids-docker-images/releases/tag/postgres-9.0.3)**: Legacy PostgreSQL 9.0.3 with PostGIS 1.5.5 (deprecated)

#### Image Contents

- **/cidsIntegrationBase**:  Control and import scripts for running the RDMBS. The content of this folder (.dockerignore) is part of image. 

#### Volume Contents

- **/cidsIntegrationBase/pg_data**

  The actual PostgreSQL data directory. (in data volume) This directory is mounted as *named volume* (in docker-compose.yaml or run_container.sh), thus the data is stored on the host directly!
  
- **/import/cidsIntegrationBase/**

    This directory contains init-scripts, dumps and role definitions that are imported by [utils/import.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-integration-base/cidsIntegrationBase/utils/import.sh) into the PostgreSQL data base upon container creation (run) when the *import* flag is set. (host-mounted volume) The contents of this directory are overlaid by a host-mounted volume that contains the actual dump files. WARNING: Existing databases in pg_data (data volume) are deleted if *import' flag is set! 
    
    - **/import/cidsIntegrationBase/roles/**
    
        This directory contains optional global role definitions (roles.sql) that are imported into main postgres database
        
    - **/import/cidsIntegrationBase/cids-init/**
    
        This directory contains optional init and post-init scripts (cids_init_script.sql and post_init_script.sql) that are applied for each dump in the dumps directory
    
    - **/import/cidsIntegrationBase/dumps/**

        This directory contains the actual database dump files (supported formats: .gz, .sql and .backup) that are imported into PostgeSQL database when the 'import' flag  is passed to the [cids_ctl.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-integration-base/cidsIntegrationBase/cids_ctl.sh) startup script. For each dump file, a database with the same name is created and optional init and post-init scripts are executed before and after the dump is imported. 

#### Running

See start.sh, run.sh, etc. in **Examples** for running and starting the container. Entrypoint of the container is the container control script [container_ctl.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-integration-base/import/container_ctl.sh) which accepts the arguments 'start' (the default), 'start import' (use with care, it overwrites existing databases with dumps from the host-mounted import volume), 'stop' and 'restart'. 
Use docker exec with [/cidsIntegrationBase/cids_ctl.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-integration-base/cidsIntegrationBase/cids_ctl.sh) to control a running container.

``
docker exec -it cids-integration-base-container-name /cidsIntegrationBase/cids_ctl.sh start | start import | restart | stop
``

##### Environment Variables
- **POSTGRES_PASSWORD** set var to override the default specified in the [Dockerfile](https://github.com/cismet/cids-docker-images/blob/master/cids-integration-base/Dockerfile)

##### Exposed Ports
- **5432** Default PostgreSQL Server Port

##### Links
- none

##### Volumes
- name-volume:/cidsIntegrationBase/pg_data (optional, recommended to store postgres data on host)

- ~/host-mounted-volume:/import/cidsIntegrationBase/ (optional, required when importing dumps)

#### Examples

- **[cids-reference/cids-integration-base](https://github.com/cismet/cids-docker-volumes/tree/master/cids-reference/cids-integration-base)**: Loads latest [cids-init-script](https://raw.githubusercontent.com/cismet/cids-init/dev/cids_init_script.sql) from github and imports [cids-reference](https://github.com/cismet/cids-docker-volumes/blob/master/cids-reference/cids-integration-base/import/dumps/cids_reference.sql) dump, uses *latest* image

- **[switchon/cids-integration-base](https://github.com/switchonproject/switchon-docker-volumes/tree/master/switchon/cids-integration-base)**, uses a local dump of the [SWITCH-ON](https://github.com/switchonproject) database.

-  **[dockerized-wuppertal](https://github.com/cismet/developer-space/tree/dockerized-wuppertal/scripts)**: Uses *postgres-9.0.3-2.0* and *postgres-9.6.1-2.0* images to upgrade local PostgeSQL 9.0.x dumps to 9.6.x. 

-  **[cids-distribution-wunda/cidsIntegrationBase](https://github.com/cismet/developer-space/tree/dockerized-wuppertal/wunda-docker-volumes/cids-distribution-wunda/cidsIntegrationBase)**: Imports local wuppertal dumps and roles (no init script applied), uses *postgres-9.0.3-2.0* image


## cids-java-maven

Java 1.8.x and Maven 3.3.x base [images](https://hub.docker.com/r/cismet/cids-java-maven/) for cids-distribution and cids-server-* images.

#### Tags

- latest

- **[jdk-1.8u112-1.1](https://github.com/cismet/cids-docker-images/releases/tag/jdk-1.8u112-1.1)**: JDK 1.8u112 with Maven 3.3.9 for cids-distribution images


#### Image Contents

- **/cidsDistribution/**

    Contains a default *policy.file* to grant all permissions to java applications

- **/cidsDistribution/lib/m2**

    This is apache maven's localRepository (MAVEN_BIB_DIR or lib/m2) and is only used in an AUTO-DISTRUBUTION. The image contains some 'problematic' dependencies that cannot be retrieved from public maven repositories. For **AUTO-DISTRUBUTIONs**, this directory can safely declared a DATA VOLUME, since if the container’s base image contains data at the specified mount point, that existing data is copied into the new volume upon volume initialization. (Note that this does not apply when mounting a host directory!). For **LEGCY-DISTRUBUTIONs** this directory must not be declared as volume!

#### Volume Contents

See [cids-distribution](#cids-distribution) or cids-server-* images for a description of volume contents.

#### Running

This base image is not run directly.

##### Environment Variables
- **CIDS_ACCOUNT_EXTENSION** Account extension (e.g. WuNDa, Switchon, CidsReference) for naming local libs, starters, client directories and java processes

- **UPDATE_SNAPSHOTS** Maven update snapshots flag for building AUTO-DISTRIBUTIONs. Default value is `-U`, set to `-nsu -o` for offline builds (Example: [use-local-repository.yml](https://github.com/cismet/cids-docker-volumes/blob/master/cids-reference/use-local-repository.yml) in [cids-docker-volumes/cids-reference/](https://github.com/cismet/cids-docker-volumes/tree/master/cids-reference))

##### Exposed Ports
- none

##### Volumes
- none

##### Links
- none

#### Examples

See [cids-distribution](#cids-distribution) and cids-server-* images

## cids-server

Generic or custom cids-server runtime [image](https://hub.docker.com/r/cismet/cids-server/) for local testing and integration tests. Builds and runs a standalone cids-server instance. No client support, no signing of jar files! The image is based on [cids-java-maven](#cids-java-maven) and must be linked to a  [cids-integration-base](#cids-integration-base) container.

#### Tags

- latest

- [1.1](https://github.com/cismet/cids-docker-images/releases/tag/cidsServer-1.1)


#### Image Contents

In addition to image contents from  [cids-java-maven](#cids-java-maven):

- **/cidsDistribution/cids-server/icons**

    Contains some default icons

#### Volume Contents

- **/cidsDistribution/**
    
    The complete cids-distribution directory is mounted as reusable named volume. Thus, builds can use the existing maven repository in lib/m2

- **import/cids-server/**

    The host-mounted volume contains the build (settings.xml and pom.xml) and run (runtime.properties and log4j.properties) configuration. These configuration files are updated by the container startup script [startup.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-server/startup.sh), e.g. to replace template variables by the actual environment variables passed to the docker run command, and the **copied** to the cidsDistribution directory (named volume).

#### Running

See start.sh, run.sh, etc. in **Examples** for running and starting the container.
The command of the container is the container startup script [startup.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-server/startup.sh) which checks the connection to a [cids-integration-base](#cids-integration-base) container, builds the standalone cids-server distribution and starts the cids-server java process.

##### Environment Variables

In addition to environment variables  from  [cids-java-maven](#cids-java-maven):

- **LOG4J_HOST** target host for log4j remote logging. If not provided, the ip of docker host is used. Not relevant, if remote logging is disabled in log4j.properties 

- **CIDS_SERVER_STARTER:** name of the cids server starter JAR file (default: cids-server-2.0-SNAPSHOT-starter.jar), only relevant for custom distributions. 

- **CIDS_SERVER_START_OPTIONS** optional arguments that are passed to CIDS_SERVER_STARTER

##### Exposed Ports
- **9986** default cids broker port

##### Volumes
- name-volume:/cidsDistribution 

- ~/host-mounted-volume:/import/cids-server/

##### Links
- [cids-integration-base](#cids-integration-base) container

#### Examples

- **[cids-reference/cids-server](https://github.com/cismet/cids-docker-volumes/tree/master/cids-reference/cids-server)**: Builds a standalone cids-server distribution and links to cidsreference_cids-integration-base postgres container.

- **[switchon/cids-server](https://github.com/switchonproject/switchon-docker-volumes/tree/master/switchon/cids-server)**: Builds a standalone custom ([cids-custom-switchon-server](https://github.com/switchonproject/cids-custom-switchon-server)) cids-server distribution and links to switchon_cids-integration-base

## cids-server-rest-legacy

Generic cids-server-rest-legacy runtime [image](https://hub.docker.com/r/cismet/cids-server-rest-legacy/) for local testing and integration tests. Builds and runs a standalone cids-server rest legacy instance. The image is based on [cids-java-maven](#cids-java-maven) and must be linked to a [cids-server](#cids-server) container.

#### Tags

- latest

- [1.1](https://github.com/cismet/cids-docker-images/releases/tag/cidsServerRestLegacy-1.1)


#### Image Contents

See [cids-java-maven](#cids-java-maven)

#### Volume Contents

Uses the named /cidsDistribution/ volume from the linked [cids-server](#cids-server) container and thus reuses the settings.xml imported into this volume.

- **/import/cids-server-rest-legacy/**

    The host-mounted volume contains the build (pom.xml) and run (runtime.properties and log4j.properties) configuration. These configuration files are updated by the container startup script [startup.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-server/startup.sh), e.g. to replace template variables by the actual environment variables passed to the docker run command, and the **copied** to the cidsDistribution directory (named volume).

#### Running

See start.sh, run.sh, etc. in **Examples** for running and starting the container.
The command of the container is the container startup script [startup.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-server-rest-legacy/startup.sh) which checks the connection to a [cids-server](#cids-server) container, builds the standalone cids-server rest legacy distribution and starts the cids-server rest legacy java process.

##### Environment Variables

In addition to environment variables  from  [cids-java-maven](#cids-java-maven):

- **LOG4J_HOST** target host for log4j remote logging. If not provided, the ip of docker host is used. Not relevant, if remote logging is disabled in log4j.properties 

##### Exposed Ports
- **8890** default cids rest server port

##### Volumes
- name-volume:/cidsDistribution  (via volumes-from [cids-server](#cids-server) container)

- ~/host-mounted-volume:/import/cids-server-rest-legacy/

##### Links
- [cids-server](#cids-server) container

#### Examples

- **[cids-reference/cids-server-rest-legacy](https://github.com/cismet/cids-docker-volumes/tree/master/cids-reference/cids-server-rest-legacy)**: Builds a standalone cids-server-rest-legacy distribution.

- **[switchon/cids-server-rest-legacy](https://github.com/switchonproject/switchon-docker-volumes/tree/master/switchon/cids-server-rest-legacy)**: Builds a standalone cids-server-rest-legacy distribution and links to switchon_cids-integration-base

