#!/bin/sh
docker run -it -v /Users/jbecktor:/home/jbecktor -v /Volumes/ExtremeJPL:/Volumes/ExtremeJPL -e DISPLAY=host.docker.internal:0 mrcal
