#!/bin/bash

# Define variables
KLEE_CONTAINER_NAME="klee_docker"
INFER_IMAGE_NAME="infer_image"

# Operations for Klee container
docker container start $KLEE_CONTAINER_NAME
docker exec $KLEE_CONTAINER_NAME /bin/sh -c "rm -rf verification && mkdir verification"
docker cp run_klee.sh $KLEE_CONTAINER_NAME:/home/klee/verification
docker cp klee_analysis.c $KLEE_CONTAINER_NAME:/home/klee/verification
docker exec $KLEE_CONTAINER_NAME clang -c -g -emit-llvm verification/klee_analysis.c
docker exec $KLEE_CONTAINER_NAME mv klee_analysis.bc verification
docker exec $KLEE_CONTAINER_NAME rm -f klee_results.txt
docker exec $KLEE_CONTAINER_NAME /bin/sh -c "script -q -c 'timeout 15 klee --libc=uclibc verification/klee_analysis.bc' /dev/null > klee_results.txt 2>&1"
rm -f klee_results.txt
docker cp $KLEE_CONTAINER_NAME:/home/klee/klee_results.txt .
docker exec $KLEE_CONTAINER_NAME /bin/sh -c "cd verification && ./run.sh"
rm -f error_report_klee.txt
docker cp $KLEE_CONTAINER_NAME:/home/klee/verification/output.txt error_report_klee.txt

docker container stop $KLEE_CONTAINER_NAME

# Operations for Infer
rm -f infer_report.txt
docker run --rm -it -v $PWD:/infer-examples $INFER_IMAGE_NAME /bin/bash -c "cd infer-examples; infer -- clang -c infer_analysis.c >infer_report.txt"
