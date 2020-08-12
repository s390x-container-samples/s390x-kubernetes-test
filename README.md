How to build a minimal Docker Image for Kubernetes Tests

Building a Dockerimage for Kubernetes tests can have a size about 1,2GB.
The size is reducable with the Experimental flag and the docker option --squash.

```
export DOCKER_CLI_EXPERIMENTAL=enabled
docker build --squash --tag kub-container .
```
