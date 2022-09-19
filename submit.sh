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
