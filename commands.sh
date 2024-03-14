clang -c -g -emit-llvm test1.c
rm help.txt
klee --libc=uclibc test1.bc &>help.txt

docker container start klee_docker
docker cp error_report.txt klee_docker:/home/klee
docker exec klee_docker cp error_report.txt error_report2.txt

docker-compose up --build
