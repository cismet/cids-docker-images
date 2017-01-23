# cids-docker-images

[cids-docker-images](https://hub.docker.com/u/cismet/) + [cids-docker-volumes](https://github.com/cismet/cids-docker-volumes) = dockerized cids systems

## [cids-integration-base](https://github.com/cismet/cids-docker-images/tree/master/cids-integration-base)

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


## [cids-java-maven](https://github.com/cismet/cids-docker-images/tree/master/cids-java-maven)

Oracle JDK 1.8.x and Maven 3.3.x base [image](https://hub.docker.com/r/cismet/cids-java-maven/) for cids-distribution and cids-server-* images. Adds also [letsencrypt](https://letsencrypt.org/) certificates to the JRE's cacerts file!

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

## [cids-server](https://github.com/cismet/cids-docker-images/tree/master/cids-server)

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

- **CIDS_SERVER_STARTER:** name of the cids server starter JAR file (default: cids-server-4.0-starter.jar), only relevant for custom distributions. 

- **CIDS_SERVER_START_OPTIONS** optional arguments that are passed to CIDS_SERVER_STARTER

##### Exposed Ports
- **9986** default cids broker port

##### Volumes
- name-volume:/cidsDistribution 

- ~/host-mounted-volume:/import/cids-server/

##### Links
- [cids-integration-base](#cids-integration-base) container

#### Examples

- **[cids-reference/cids-server](https://github.com/cismet/cids-docker-volumes/tree/master/cids-reference/cids-server)** (volume): Builds a standalone cids-server distribution and links to cidsreference_cids-integration-base postgres container.

- **[switchon/cids-server](https://github.com/switchonproject/switchon-docker-volumes/tree/master/switchon/cids-server)** (volume): Builds a standalone custom ([cids-custom-switchon-server](https://github.com/switchonproject/cids-custom-switchon-server)) cids-server distribution and links to switchon_cids-integration-base

## [cids-server-rest-legacy](https://github.com/cismet/cids-docker-images/tree/master/cids-server-rest-legacy)

Generic cids-server-rest-legacy runtime [image](https://hub.docker.com/r/cismet/cids-server-rest-legacy/) for local testing and integration tests. Builds and runs a standalone cids-server rest legacy instance. The image is based on [cids-java-maven](#cids-java-maven) and must be linked to a [cids-server](#cids-server) container.

#### Tags

- latest

- [1.1](https://github.com/cismet/cids-docker-images/releases/tag/cidsServerRestLegacy-1.1)


#### Image Contents

See [cids-java-maven](#cids-java-maven)

#### Volume Contents

Uses the named /cidsDistribution/ volume from the linked [cids-server](#cids-server) container and thus reuses the settings.xml imported into this volume.

- **/import/cids-server-rest-legacy/**

    The host-mounted volume contains the build (pom.xml) and run (runtime.properties and log4j.properties) configuration. The settings.xml file can be reused from the linked cids-server container and is therfore not required. These configuration files are updated by the container startup script [startup.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-server/startup.sh), e.g. to replace template variables by the actual environment variables passed to the docker run command, and the **copied** to the cidsDistribution directory (named volume).

#### Running

See start.sh, run.sh, etc. in **Examples** for running and starting the container.
The command of the container is the container startup script [startup.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-server-rest-legacy/startup.sh) which checks the connection to a [cids-server](#cids-server) container, builds the standalone cids-server rest legacy distribution and starts the cids-server rest legacy java process.

##### Environment Variables

In addition to environment variables  from  [cids-java-maven](#cids-java-maven):

- **LOG4J_HOST** target host for log4j remote logging. If not provided, the IP address of docker host is used. Not relevant, if remote logging is disabled in log4j.properties 

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

## [cids-distribution](https://github.com/cismet/cids-docker-images/tree/master/cids-distribution)

General abstract cids distribution runtime base [image](https://hub.docker.com/r/cismet/cids-distribution/) for complete dockerized cids systems. Supports LEGACY and AUTO DISTRIBUTIONS. The image is based on [cids-java-maven](#cids-java-maven) and may be linked to a [cids-integration-base](#cids-integration-base) container. The image is just a template with some build and control scripts. 

The main difference between cids-server-* and cids-distribution images is, that the cids-distribution **image** contains the actual distribution libraries (internal and external dependencies) while in case of the cids-server-* container, the libraries are put into a volume. Thus, a cids-distribution image represents an immutable snapshot (updating the distribution requires to build a new image), while a cids-server-* distribution *can* be updated (see UPDATE_SNAPSHOTS environment variable) on each container start. 

The main differences between a LEGACY and AUTO DISTRIBUTIONS cids-distribution image is that in case of the LEGACY the libraries are copied (COPY instruction in Dockerfile) into the image when the image is built while in case of the AUTO DISTRIBUTION a maven build is performed when the image is built. In both cases, runtime information (runtime.properties, res.jar, server_resources, etc.) is not contained within the image but is stored on a host-mounted volumes.

#### Tags

- latest

- [1.0](https://github.com/cismet/cids-docker-images/releases/tag/cidsDistribution-1.0)


#### Image Contents

The general structure of the /cidsDistribution/ directory is explained in [cids-distribution-scaffold](#cids-distribution-scaffold).

In addition to [cids-java-maven](#cids-java-maven):

- **[/cidsDistribution/](https://github.com/cismet/cids-docker-images/tree/master/cids-distribution/cidsDistribution/)**

Contains the [cids_ctl.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/cids_ctl.sh) services control script for starting, stopping and restarting either all or one specific service. The script checks also for available .PID files and tries to gracefully stop services before killing the respective java process.

- **[/cidsDistribution/utils/](https://github.com/cismet/cids-docker-images/tree/master/cids-distribution/cidsDistribution/utils)**

    Utilities for running and building the custom distribution (in docker image)
The content of this folder is part of the custom cids-distribution IMAGE!

    - [_build_autodistribution.master.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/utils/_build_autodistribution.master.sh)
        
        Master script for bulding AUTO-DISTRIBUTIONS. Requires cidsDistribution/.private/server.pwd, keystore and keystore.pwd to be present during maven build (files deleted after maven build). Processes all pom.xml files in subdirectories of the generator directory cidsDistribution/gen and builds the respective maven projects. Supports MAVEN_BUID_COMMAND and UPDATE_SNAPSHOTS environment variables

    - [build_autodistribution.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/utils/build_autodistribution.sh)

        Uses _build_autodistribution.master.sh with MAVEN_BUID_COMMAND `clean package` to build the respective maven project

    - [prepare_autodistribution.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/utils/prepare_autodistribution.sh)
    
        Uses _build_autodistribution.master.sh with MAVEN_BUID_COMMAND `dependency:go-offline --fail-never` to download all dependencies of the respective maven project

    - [_cids_service_ctl.master.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/utils/_cids_service_ctl.master.sh)
        
        Master script for starting, stopping and restarting cids-servers instances. This master script is used by the individual *[cs_ctl.sh](https://github.com/switchonproject/switchon-docker-volumes/blob/master/cids-distribution-switchon/cidsDistribution/server/030_switchon/cs_ctl.sh)* scripts (from host-mounted volume) that are located in the /cidsDistribution/server/###-server-name directories. It created .PID and .OUT files in the respective [server directories](https://github.com/cismet/cids-docker-images/tree/master/cids-distribution-scaffold/cidsDistribution/server/000-DemoService.1). If present, it invokes startup_hook.sh and shutdown_hook.sh found in these directories after service start and stop (Refer to [cids-distribution-scaffold](#cids-distribution-scaffold) for example).

    - [cs_ctl.template.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/utils/cs_ctl.template.sh)

        Template file for individual cs_ctl.sh server control scripts that have to be placed in the respective server/###-server-name directories.  

    - [create_impostor.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/utils/create_impostor.sh)

        Creates an "IMPOSTOR.JAR" (needed to naming java processes) for a specific server starter. Requires the variables STARTER_JAR and SERVICE (name of the service and thus name of the IMPOSTOR.JAR) to be set in the respective *cs_ctl.sh* script. "IMPOSTOR.JAR" is created only if it does not already exist. 

    - [create_security_jar](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/utils/create_security_jar.sh)

        Creates the "SECUTIRY.JAR" that contains signed JNLP files of Java Webstart client applications. Requires cidsDsitribution/.private/keystore and cidsDsitribution/.private/keystore.pwd files to be present. Replace either the *security-jar-template.jar* classpath entry in JNLP files generated by AUTO-DISTRIBUTIONS or replaces ${JNLP_BASE}_security.jar in LEGACY DISTRIBUTIONS JNLP created by cids ABF.

    - [sign.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/utils/sign.sh)

        Signs a JAR file with cismet certificate. Checks if the JAR file is already signed with the cismet certificate, removes existing certificates if present and updates JAR Manifests with proper Permissions and Codebase instructions.

    - [sign_all.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/utils/sign_all.sh)

        Uses sign.sh to sign all JAR files in the provided lib dir (e.g. /cidsDistribution/lib/m2/). Signs only JAR files that have been modified since the last run sign_all.sh to speed up the signing process when building an image based on [cids-distribution-cache](#cids-distribution-cache)).

    - [update_configuration.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/utils/update_configuration.sh)

        Checks runtime.properties and log4j.properties in the host-mounted volume directories and replaces template variables __DB_HOST__, __DOCKER_HOST__, __LOG4J_HOST__, etc. with actual values from environment variables. Warning: Modifies these files on the host! Don't use template variables if this behavior is not desired.
    
- **/import/**

    The import directory contains the container [container_ctl.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/import/container_ctl.sh) container control, script and the [default nginx webserver configuration](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/import/nginx/default) (the files are copied to the respective image directories, see [Dockerfile](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/Dockerfile)).


Additional image contents depend on LEGACY and AUTO-DISTRIBUTION. See [cids-distribution-wunda](#cids-distribution-wunda) and [cids-distribution-switchon](#cids-distribution-switchon) for more details.

#### Volume Contents

- **/cidsDistribution/client/**
- **/cidsDistribution/server/**
- **/cidsDistribution/lib/localXXX**

The host-mounted volumes contain server and client runtime configurations and (runtime.properties, log4j.properties, navigator.cfg, server_resources, etc.). Configuration files can updated by [update_configuration.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/utils/update_configuration.sh), e.g. to replace template variables by the actual environment variables passed to the docker run command. The lib/localXXX directory contains local libraries /e.g. res.jar) that are not part of the image. When mounting those volumes from the host, it is important to note that any content available at the respective path in the image and container, respectively, will be overlaid by the content of the volume!

#### Running

See start.sh, run.sh, etc. in **Examples** for running and starting the container.
The entrypoint of the container is the container control script[container_ctl.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/import/container_ctl.sh) which conditionally checks the connection to a [cids-integration-base](#cids-integration-base), starts all configured cids-server java processes and conditionally starts the nginx webserver process (required for serving Java Webstart client content). Note that for building AUTO-DISTRIBUTION (empty) template local libraries (e.g. [/cidsDistribution/lib/localSwitchon/](https://github.com/switchonproject/switchon-docker-images/tree/master/cids-distribution-switchon/cidsDistribution/lib/localSwitchon)) have to be present when the image is build (they will be overlaid with the real local libraries (e.g. [cidsDistribution/lib/localSwitchon](https://github.com/switchonproject/switchon-docker-volumes/tree/master/cids-distribution-switchon/cidsDistribution/lib/localSwitchon)) when the respective container is started)

##### Environment Variables

In addition to environment variables  from  [cids-java-maven](#cids-java-maven):

- **LOG4J_HOST** target host for log4j remote logging. If not provided, the IP address of docker host is used. Not relevant, if __LOG4J_HOST__ template variable is not set or remote logging is disabled in log4j.properties.  

- **CIDS_CODEBASE** Codebase required for JNLP files, default is http://localhost

- **CIDSCTL_CHECK_DATABASE_CONNECTION** Check connection to [cids-integration-base](#cids-integration-base) on container start (default: true)

- **CIDSCTL_START_WEBSERVER** Start nginx webserver on container start (default: true)

##### Exposed Ports

Depends on child image. Usually

- **9986** cids broker
- **8890** cids REST service
- **80** nginx webserver

##### Volumes

Depends on child image. Usually

- ~/host-mounted-volume:/cidsDistribution/client
- ~/host-mounted-volume:/cidsDistribution/server´
- ~/host-mounted-volume:/cidsDistribution/lib/localXXX

##### Links
Depends on child image. Usually to cids-integration-base container.

#### Examples

- **[cids-distribution-scaffold](https://github.com/cismet/cids-docker-images/tree/master/cids-distribution-scaffold)**: Simple Scaffold project that can be used as template for new cids-distribution images (both AUTO- and LEGACY DISTRIBUTIONS).

- **[cids-distribution-switchon](https://github.com/switchonproject/switchon-docker-images/tree/master/cids-distribution-switchon)**: Example AUTO DISTRIBUTION image and [volume](https://github.com/switchonproject/switchon-docker-volumes/tree/master/cids-distribution-switchon) for custom [SWITCH-ON](http://switchonproject.github.io/) distributions.

- **[cids-distribution-wunda](https://github.com/cismet/developer-space/tree/dockerized-wuppertal/wunda-docker-images/cids-distribution-wunda)** Example LEGACY DISTRIBUTION and [volumes](https://github.com/cismet/developer-space/tree/dockerized-wuppertal/wunda-docker-volumes/cids-distribution-wunda) for custom WuNDa distributions.

- **[cids-distribution-belis-rest](https://github.com/cismet/developer-space/tree/dockerized-wuppertal/wunda-docker-images/cids-distribution-belis-rest)** Example AUTO DISTRIBUTION and [volumes](https://github.com/cismet/developer-space/tree/dockerized-wuppertal/wunda-docker-volumes/cids-distribution-belis-rest/) for custom BELIS distributions. Legacy rest server (without client and nginx), requires link to cids-distribution-wunda container.

## [cids-distribution-cache](https://github.com/cismet/cids-docker-images/tree/master/cids-distribution-cache)

Optional abstract cache [image](https://hub.docker.com/r/cismet/cids-distribution-cache/) that contains a pre-filled lib/m2 repository for faster image build. It depends on [cids-distribution][#cids-distribution] and can be used as base image for individual cids-distributions. The repository can be updated with the contents of a running cids-distribution-xxx AUTO-DISTRIBUTION container, e.g. [cids-distribution-switchon](https://github.com/switchonproject/switchon-docker-images/tree/master/cids-distribution-switchon), with the command

``
docker cp cidsdistributionswitchon_cids-distribution-switchon:/cidsDistribution/lib/m2 ~/git_work/cids-docker-images/cids-distribution-cache/cidsDistribution/lib/
``

The cids-distribution-cache image is not automatically build on [dockerhub](https://hub.docker.com/u/cismet) but has to be pushed manually with help of [push.sh](https:/github.com/cismet/cids-docker-images/blob/master/cids-distribution-cache/push.sh).

#### Tags

- latest

- [1.0](https://hub.docker.com/r/cismet/cids-distribution-cache/tags/)

#### Image Contents

Contains in addition to [cids-distribution](#cids-distribution) and [cids-java-maven](#cids-java-maven) a pre-filled lib/m2 repository in cidsDistribution/lib/m2

#### Volume Contents

See [cids-distribution](#cids-distribution).

#### Running

See [cids-distribution](#cids-distribution).

#### Examples

- **[cids-distribution-switchon](https://github.com/switchonproject/switchon-docker-images/tree/master/cids-distribution-switchon)**

- **[cids-distribution-belis-rest](https://github.com/cismet/developer-space/tree/dockerized-wuppertal/wunda-docker-images/cids-distribution-belis-rest)**

## [cids-distribution-scaffold](https://github.com/cismet/cids-docker-images/tree/master/cids-distribution-scaffold)

Scaffold cids distribution Runtime [image](https://hub.docker.com/r/cismet/cids-distribution-scaffold/). Simple Scaffold project that can be used as template for new cids-distribution images (both AUTO- and LEGACY DISTRIBUTIONS). It depends on [cids-distribution][#cids-distribution] but can also use [cids-distribution-cache][#cids-distribution-cache] as base image (for AUTO DISTRIBUTIONS only)

#### Tags

- latest

- [1.0](https://github.com/cismet/cids-docker-images/releases/tag/cidsDistributionScaffold-1.0)

#### Image Contents

The image contains the following scaffold structure that is both applicable to LEGACY and AUTO-DISTRIBUTIONS:

- **/cidsDistribution/.private/**   
    
    This is the private configuration directory that is need during image build for the AUTO DISTRIBUTION and for signing JAR files. Although the directory is removed during the docker image build process, private data is still present in intermediate image layers! Therfore the image must not be pushed to public registries (hub.docker.com) The possibility to 'flatten' docker images (--squash) will be added in the next docker release. See https://github.com/docker/docker/issues/13490 and https://github.com/docker/docker/pull/22641#issuecomment-266156133

- **/cidsDistribution/client/**   

    This is the client configuration directory (host mounted volume). Empty in docker image! **All contents in the image will be overlaid by a HOST-MOUNTED DOCKER VOLUME!**

- **/cidsDistribution/server/**   

    This is the server configuration directory (host mounted volume). All contents in the image will be overlaid by a HOST-MOUNTED DOCKER VOLUME! Each subdirectory (###-service-name) represents a java service that is controlled by [cids_ctl.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/cids_ctl.sh). Each service directory has to contain at least the the service control script [cs_ctl.sh](https://github.com/cismet/cids-docker-images/blob/master/cids-distribution/cidsDistribution/utils/cs_ctl.template.sh), optional startup- and shutdown-hook scripts (shutdown_hook.sh and startup_hook.sh) and any configuration files required by the service (e.g. runtime.properties, log4j.properties, ...)

- **/cidsDistribution/gen/**   

    This is maven generator directory and is only used in an AUTO-DISTRUBUTION during image build! (in docker image) It has to contain the maven settings.xml file and one or more subdirectories containing  a single pom.xml file. Environment variables can directly be substituted in pom.xml and settings.xml, e.g. <m2codebase>${env.MAVEN_LIB_DIR}</m2codebase>.

- **/cidsDistribution/lib/cidsLibBase/**

    cids ABF Library Management Configuration Files (local on docker host). The content of this folder is neither part of the custom cids-distribution IMAGE nor
mounted as VOLUME, thus it is not present in the running custom cids-distribution CONTAINER! It is required when manually updating (with cidsABF) the custom cids-distribution IMAGE (e.g. add new dependency) or when modifying the RUNTIME configuration (e.g. rebuild res.jar) of a custom cids-distribution CONTAINER.

- **/cidsDistribution/lib/classpath/**

    Generated classpath JARS for AUTO DISTRIBUTIONS (in docker image) The content of this folder is part of the custom cids-distribution IMAGE!
Not used for MANUAL DISTRIBUTIONs (classpath dependencies go directly into starters instead!)
custom cids-distributions may use their own classpath directories e.g. classpathSwitchon

- **cidsDistribution/lib/local/**

    Local runtime dependent configuration template JARs (empty JARs) for custom cids-distributions containers (local on docker host **and** host-mounted volume). Empty in docker image but not empty on docker host during image build of AUTO-DISTRIBUTIONS! Local runtime dependent configurations are not part of the image but need to be present 
during automated builds of AUTO DISTRIBUTIONS since they are put into the lib/classpath JARs! When building an AUTO DISTRIBUTION, the JARs in this directory are copied into the image to lib/local. The cids maven plugin adds those local dependencies to lib/classpath JARs and the client JNLPs. When the
container is started, the empty JAR in container:lib/local are overlaid with the actual JAR from the host-mounted volume! Custom cids-distributions may use their own local.scaffold directories e.g. localSwitchon

- **/cidsDistribution/lib/ext/**

    EXTERNAL dependencies for LEGACY DISTRIBUTIONS maintained with cidsABF (in docker image). The content of this folder is part of the custom cids-distribution IMAGE! Not used for AUTO DISTRIBUTIONs (dependencies go into /cidsDistribution/lib/m2 instead)


- **/cidsDistribution/lib/int/**
    
    INTERNAL cids dependencies for LEGACY DISTRIBUTIONS maintained with cidsABF (in docker image) The content of this folder is part of the custom cids-distribution IMAGE! Not used for AUTO DISTRIBUTIONs (dependencies go into /cidsDistribution/lib/m2 instead)

- **/cidsDistribution/lib/m2/**

    This is apache maven's localRepository (MAVEN_BIB_DIR or lib/m2) and is only used
in an AUTO-DISTRUBUTION! The base image [cids-java-maven](#cids-java-mave) adds some 'problematic' dependencies that cannot retrieved from public maven repositories, [cids-distribution-cache](#cids-distribution-cache) (if used as base image) adds common dependencies required by cids distributions

- **/cidsDistribution/lib/starter/**
    
    Starters for AUTO- and LEGACY DISTRIBUTIONS maintained with cidsABF (in docker image). The content of this folder is part of the custom cids-distribution IMAGE! Custom cids-distributions shall use their own starter directories e.g. starterWunda

#### Volume Contents

See [cids-distribution](#cids-distribution) volume content. In general the image directories /cidsDistribution/client/, /cidsDistribution/server/ and /cidsDistribution/localXXX/ are overlaid by host-mounted volumes.

#### Running

See shellscripts in [cids-distribution-scaffold](https://github.com/cismet/cids-docker-images/tree/master/cids-distribution-scaffold)

#### Examples

See [cids-distribution-scaffold/cidsDistribution/server](https://github.com/cismet/cids-docker-images/tree/master/cids-distribution-scaffold/cidsDistribution/server).
