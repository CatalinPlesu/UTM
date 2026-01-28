docker container stop openmp # stop openmp container
docker container rm openmp   # remove openmp container
docker run --name openmp  -it -v "$(pwd)":/home/student/lab1/openmp openmp