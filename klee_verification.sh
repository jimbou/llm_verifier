#!/bin/bash

docker container start klee_docker
docker exec klee_docker rm -f verification/klee_analysis.c
docker cp klee_analysis.c klee_docker:/home/klee/verification
docker exec klee_docker clang -c -g -emit-llvm verification/klee_analysis.c
docker exec klee_docker mv klee_analysis.bc verification
# docker exec klee_docker rm -f verification/help.txt
# docker exec klee_docker touch verification/help.txt
docker exec klee_docker  /bin/sh -c "klee --libc=uclibc verification/klee_analysis.bc" &> klee_results.txt
docker exec klee_docker /bin/sh -c "cd verification && ./run.sh"
docker cp klee_docker:/home/klee/verification/output.txt error_report_klee.txt


docker run -it -v $PWD:/infer-examples infer_image /bin/bash -c "cd infer-examples; infer -- clang -c infer_analysis.c >infer_report.txt"