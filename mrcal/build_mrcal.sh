#!/bin/sh

docker build --build-arg USER=jbecktor --build-arg _GID=20 --build-arg _UID=503 -t mrcal -f mrcal.Dockerfile .
