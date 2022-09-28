#!/bin/bash

module load intelmpi

export CUDA_ROOT=/usr/local/cuda
export PATH=/usr/local/cuda/bin/:${PATH}
