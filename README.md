# scala-sbt
This Docker image provides:

* [SBT - the interactive build tool](https://www.scala-sbt.org)
* [OpenJDK](http://openjdk.java.net/)  1.8.0_191
* [GNU Bash](https://www.gnu.org/software/bash/)  4.4.19
* [Linux Alpine](https://www.alpinelinux.org)  3.8


## build
Build and tag this Docker image as follows:

```bash
docker image build \
  --build-arg SBT_VERSION=0.13.18 \
  --tag scala-sbt:0.13.18 \
  .
```

Or, if you wish to build something newer, then do:

```bash
docker image build \
  --build-arg SBT_VERSION=1.2.8 \
  --tag scala-sbt:1.2.8 \
  .
```

## example
Under the `example` directory you will find a simple example of usage.

```bash
cd example
./sbt
```

> NOTE  
> The `./sbt` wrapper script will run the _"dockerized"_ SBT provided by this project.


## usage
Use this Docker image as follows:

```bash
# 1. Create a Docker network
docker network create docker.net

# 2. Create a Docker volume
docker volume create cache

# 3. Run it!
cd /path/to/my-project
docker container run \
  -it --rm --name $(basename $(pwd)) \
  --mount type=bind,src=$(pwd),dst=/project \
  --mount type=bind,src=/var/run/docker.sock,dst=/var/run/docker.sock \
  --mount type=volume,src=cache,dst=/cache \
  --network docker.net \
  scala-sbt:1.2.3
```
