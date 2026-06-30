#!/bin/bash

BASEIMAGE=`grep FROM Dockerfile | awk '{print $2}'`
docker pull ${BASEIMAGE}
docker build -t "fullaxx/alpdev" .
