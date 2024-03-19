#!/bin/bash

# Define variables
KLEE_CONTAINER_NAME="klee_docker1"
KLEE_IMAGE_NAME="docker.io/klee/klee "

# Operations for Klee container
docker run -dit --name $KLEE_CONTAINER_NAME $KLEE_IMAGE_NAME /bin/bash
#docker container start $KLEE_CONTAINER_NAME
docker exec $KLEE_CONTAINER_NAME /bin/sh -c "rm -rf verification && mkdir verification"
chmod +x run_klee.sh
docker cp run_klee.sh $KLEE_CONTAINER_NAME:/home/klee/verification
docker cp klee_analysis.c $KLEE_CONTAINER_NAME:/home/klee/verification
docker exec $KLEE_CONTAINER_NAME clang -c -g -emit-llvm verification/klee_analysis.c
docker exec $KLEE_CONTAINER_NAME mv klee_analysis.bc verification
docker exec $KLEE_CONTAINER_NAME rm -f klee_results.txt
docker exec $KLEE_CONTAINER_NAME /bin/sh -c "script -q -c 'timeout 15 klee --libc=uclibc verification/klee_analysis.bc' /dev/null > klee_results.txt 2>&1"
rm -f klee_results.txt
docker cp $KLEE_CONTAINER_NAME:/home/klee/klee_results.txt .
docker exec $KLEE_CONTAINER_NAME /bin/sh -c "cd verification && ./run_klee.sh"
rm -f error_report_klee.txt
docker cp $KLEE_CONTAINER_NAME:/home/klee/verification/output.txt error_report_klee.txt

docker container stop $KLEE_CONTAINER_NAME
docker container rm $KLEE_CONTAINER_NAME

