# hello_jobstep

For each job step launched with srun, this program prints the hardware thread IDs that each MPI rank and OpenMP thread runs on, and the GPU IDs that each rank/thread has access to.

## Compiling

To compile on the AWS nodes, you'll need to load the `intelmpi` module and to make sure `nvcc` is in your `PATH`. To do so,

```
$ source setup_environment.sh
```

...then compile

```
$ make
nvcc -arch=sm_70 -Xcompiler -fopenmp -I/opt/intel/mpi/2021.4.0/include -c hello_jobstep.cu
nvcc -arch=sm_70 -Xcompiler -fopenmp -L/opt/intel/mpi/2021.4.0/lib/release -lmpi hello_jobstep.o -o hello_jobstep
```

## Usage

To run, set the `OMP_NUM_THREADS` environment variable and launch the executable with `srun` and any relevant options. For example...

```
$ cat submit.sh
#!/bin/bash

#SBATCH -N 1
#SBATCH -t 10
#SBATCH -p eval-debug-gpu
#SBATCH --exclusive

source ./setup_environment.sh

export I_MPI_PMI_LIBRARY=/opt/slurm/lib/libpmi.so

export OMP_NUM_THREADS=4
export OMP_PROC_BIND=close

srun -n4 -c4 --gpus=4 --gpu-bind=map_gpu:0,1,2,3 --cpu-bind=mask_cpu:0xf,0xf0,0xf00,0xf000 ./hello_jobstep | sort



$ sbatch submit.sh
Submitted batch job 80



$ cat slurm-80.out
Loading intelmpi version 2021.4.0
MPI 000 - OMP 000 - HWT 000 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 1B
MPI 000 - OMP 001 - HWT 001 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 1B
MPI 000 - OMP 002 - HWT 002 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 1B
MPI 000 - OMP 003 - HWT 003 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 0 - Bus_ID 1B
MPI 001 - OMP 000 - HWT 004 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID 1C
MPI 001 - OMP 001 - HWT 005 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID 1C
MPI 001 - OMP 002 - HWT 006 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID 1C
MPI 001 - OMP 003 - HWT 007 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 1 - Bus_ID 1C
MPI 002 - OMP 000 - HWT 008 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID 1D
MPI 002 - OMP 001 - HWT 009 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID 1D
MPI 002 - OMP 002 - HWT 010 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID 1D
MPI 002 - OMP 003 - HWT 011 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 2 - Bus_ID 1D
MPI 003 - OMP 000 - HWT 012 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 1E
MPI 003 - OMP 001 - HWT 013 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 1E
MPI 003 - OMP 002 - HWT 014 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 1E
MPI 003 - OMP 003 - HWT 015 - Node eval-debug-gpu-dy-p38xlarge-1 - RT_GPU_ID 0 - GPU_ID 3 - Bus_ID 1E
```

The different GPU IDs reported by the example program are:

* `GPU_ID` is the node-level (or global) GPU ID read from `ROCR_VISIBLE_DEVICES`. If this environment variable is not set (either by the user or by Slurm), the value of `GPU_ID` will be set to `N/A`.
* `RT_GPU_ID` is the CUDA runtime GPU ID as reported from, say `cudaGetDevice`).
* `Bus_ID` is the physical bus ID associated with the GPUs. Comparing the bus IDs is meant to definitively show that different GPUs are being used.
