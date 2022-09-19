NVCC      = nvcc
NVFLAGS   = -arch=sm_70 -Xcompiler -fopenmp

INCLUDES  = -I${I_MPI_ROOT}/include
LIBRARIES = -L${I_MPI_ROOT}/lib/release -lmpi

hello_jobstep: hello_jobstep.o
	${NVCC} ${NVFLAGS} ${LIBRARIES} hello_jobstep.o -o hello_jobstep

hello_jobstep.o: hello_jobstep.cu
	${NVCC} ${NVFLAGS} ${INCLUDES} -c hello_jobstep.cu

.PHONY: clean

clean:
	rm -f hello_jobstep *.o
