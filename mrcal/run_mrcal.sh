#!/bin/sh
docker run -it -v /Users/jbecktor:/home/jbecktor -e DISPLAY=host.docker.internal:0 mrcal
