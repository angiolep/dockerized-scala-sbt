# scala-sbt
This Docker image provides:

* [SBT - the interactive build tool](https://www.scala-sbt.org)
* [OpenJDK](http://openjdk.java.net/)  1.8.0_191
* [GNU Bash](https://www.gnu.org/software/bash/)  4.4.19
* [Linux Alpine](https://www.alpinelinux.org)  3.8


## Build
You can build and tag this Docker image either for local usage or for GitLab.

### Local

```bash
version="0.13.18"
docker image build \
  --build-arg version=$version \
  --tag scala-sbt:$version \
  .

docker image tag \
  scala-sbt:$version \
  registry.alpinedata.tech/pangiolet/scala-sbt:$version

docker login \
  registry.alpinedata.tech

docker image push \
  registry.alpinedata.tech/pangiolet/scala-sbt:$version
```

You can list available versions at https://github.com/sbt/sbt/releases


### GitLab

```bash
version="1.2.8"
tag="registry.alpinedata.tech/pangiolet/scala-sbt:$version"

docker image build \
  --build-arg version=$version \
  --file Gitlabfile \
  --tag $tag-gitlab \
  .

docker push $tag-gitlab
```


## Example
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
  scala-sbt:1.2.8
```
