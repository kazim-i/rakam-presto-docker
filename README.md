# rakam-presto-docker

On PrestoServer directory build the image:
docker build --build-arg P_VERSION=0.190 --build-arg U_VERSION='' --build-arg=R_VERSION='' -t rakam/prestoserver .
In order to run the image with the environment values provided in the defaults.env:
docker run --env-file defaults.env --name=rakamprestoserver rakam/prestoserver


On PrestoStreamer directory build the image:
docker build --build-arg P_VERSION=0.190 -t rakam/prestostreamer .
docker run  --env-file defaults.env --name=rakamprestostreamer rakam/prestostreamer
