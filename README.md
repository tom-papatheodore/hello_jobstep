# hello_jobstep

For each job step launched with srun, this program prints the hardware thread IDs that each MPI rank and OpenMP thread runs on, and the GPU IDs that each rank/thread has access to.

## Compiling

To compile on the AWS nodes, you'll need to load the `intelmpi` module


To compile, you'll need to have CUDA and MPI installed, and you'll need to use an OpenMP-capable compiler. 

## Usage

To run, set the `OMP_NUM_THREADS` environment variable and launch the executable with `srun`. For example...

```
export OMP_NUM_THREADS=8
srun -n4 -c8 --gpus=4 --gpu-bind=map_gpu:0,1,2,3 ./hello_jobstep | sort
```

```
[olcf1@ip-10-0-0-199 hello_jobstep]$ ls
hello_jobstep.cu  Makefile  README.md  submit.sh  test.sh


[olcf1@ip-10-0-0-199 hello_jobstep]$ make
/usr/local/cuda-11.4/bin/nvcc -arch=sm_70 -Xcompiler -fopenmp -I/opt/intel/mpi/2021.4.0/include -c hello_jobstep.cu
/usr/local/cuda-11.4/bin/nvcc -arch=sm_70 -Xcompiler -fopenmp -L/opt/intel/mpi/2021.4.0/lib/release -lmpi hello_jobstep.o -o hello_jobstep


[olcf1@ip-10-0-0-199 hello_jobstep]$ cat submit.sh
#!/bin/bash

#SBATCH -N 1
#SBATCH -t 10
#SBATCH -p eval-debug-gpu
#SBATCH --exclusive

module load intelmpi

export I_MPI_PMI_LIBRARY=/opt/slurm/lib/libpmi.so
export OMP_NUM_THREADS=8

srun -n4 -c8 --gpus=4 --gpu-bind=map_gpu:0,1,2,3 ./hello_jobstep | sort


[olcf1@ip-10-0-0-199 hello_jobstep]$ sbatch submit.sh
Submitted batch job 55


[olcf1@ip-10-0-0-199 hello_jobstep]$ squeue
             JOBID PARTITION     NAME     USER ST       TIME  NODES NODELIST(REASON)
                55 eval-debu submit.s    olcf1  R       0:01      1 eval-debug-gpu-dy-p38xlarge-1


[olcf1@ip-10-0-0-199 hello_jobstep]$ cat slurm-55.out
Loading intelmpi version 2021.4.0
MPI 000 - OMP 000 - HWT 016 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 1B
MPI 000 - OMP 001 - HWT 018 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 1B
MPI 000 - OMP 002 - HWT 019 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 1B
MPI 000 - OMP 003 - HWT 001 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 1B
MPI 000 - OMP 004 - HWT 000 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 1B
MPI 000 - OMP 005 - HWT 017 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 1B
MPI 000 - OMP 006 - HWT 002 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 1B
MPI 000 - OMP 007 - HWT 003 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 1B
MPI 001 - OMP 000 - HWT 022 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID 1C
MPI 001 - OMP 001 - HWT 020 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID 1C
MPI 001 - OMP 002 - HWT 005 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID 1C
MPI 001 - OMP 003 - HWT 023 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID 1C
MPI 001 - OMP 004 - HWT 006 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID 1C
MPI 001 - OMP 005 - HWT 004 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID 1C
MPI 001 - OMP 006 - HWT 021 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID 1C
MPI 001 - OMP 007 - HWT 007 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID 1C
MPI 002 - OMP 000 - HWT 008 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID 1D
MPI 002 - OMP 001 - HWT 027 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID 1D
MPI 002 - OMP 002 - HWT 026 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID 1D
MPI 002 - OMP 003 - HWT 025 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID 1D
MPI 002 - OMP 004 - HWT 024 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID 1D
MPI 002 - OMP 005 - HWT 011 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID 1D
MPI 002 - OMP 006 - HWT 010 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID 1D
MPI 002 - OMP 007 - HWT 009 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID 1D
MPI 003 - OMP 000 - HWT 028 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 1E
MPI 003 - OMP 001 - HWT 013 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 1E
MPI 003 - OMP 002 - HWT 015 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 1E
MPI 003 - OMP 003 - HWT 030 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 1E
MPI 003 - OMP 004 - HWT 012 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 1E
MPI 003 - OMP 005 - HWT 029 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 1E
MPI 003 - OMP 006 - HWT 031 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 1E
MPI 003 - OMP 007 - HWT 014 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 1E
```


```
$ export OMP_NUM_THREADS=4
$ srun -A stf016 -t 10 -N 2 -n 4 -c 4 --threads-per-core=1 --gpus-per-node=4 ./hello_jobstep | sort
MPI 000 - OMP 000 - HWT 000 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 000 - OMP 001 - HWT 001 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 000 - OMP 002 - HWT 002 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 000 - OMP 003 - HWT 003 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 001 - OMP 000 - HWT 016 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 001 - OMP 001 - HWT 017 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 001 - OMP 002 - HWT 018 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 001 - OMP 003 - HWT 019 - Node spock01 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 002 - OMP 000 - HWT 000 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 002 - OMP 001 - HWT 001 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 002 - OMP 002 - HWT 002 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 002 - OMP 003 - HWT 003 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 003 - OMP 000 - HWT 016 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 003 - OMP 001 - HWT 017 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 003 - OMP 002 - HWT 018 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
MPI 003 - OMP 003 - HWT 019 - Node spock13 - RT_GPU_ID 0,1,2,3 - GPU_ID 0,1,2,3 - Bus_ID c9,87,48,09
```

The different GPU IDs reported by the example program are:

* `GPU_ID` is the node-level (or global) GPU ID read from `ROCR_VISIBLE_DEVICES`. If this environment variable is not set (either by the user or by Slurm), the value of `GPU_ID` will be set to `N/A`.
* `RT_GPU_ID` is the CUDA runtime GPU ID as reported from, say `cudaGetDevice`).
* `Bus_ID` is the physical bus ID associated with the GPUs. Comparing the bus IDs is meant to definitively show that different GPUs are being used.

> NOTE: Although the two GPU IDs (`GPU_ID` and `RT_GPU_ID`) are the same in the example above, they do not have to be.
