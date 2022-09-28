#!/bin/bash

#SBATCH -N 1
#SBATCH -t 10
#SBATCH -p eval-gpu
#SBATCH --exclusive

source ./setup_environment_aws.sh

export OMP_NUM_THREADS=6
export OMP_PROC_BIND=close

srun -n8 --ntasks-per-node=8 -c6 --gpus-per-node=8 --gpu-bind=map_gpu:0,1,2,3,4,5,6,7 --cpu-bind=mask_cpu:0x3f,0xfc0,0x3f000,0xfc0000,0x3f000000,0xfc0000000,0x3f000000000,0xfc0000000000 ./hello_jobstep | sort
