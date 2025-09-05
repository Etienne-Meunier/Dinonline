#!/usr/bin/env bash
######################
## JEANZAY IDRIS ##
######################
#SBATCH --job-name=DINO_MK25
#SBATCH --output=DINO_MK25.out
#SBATCH --error=DINO_MK25.err
#SBATCH --ntasks-per-node=40
#SBATCH --cpus-per-task=1
#SBATCH --nodes=4
#SBATCH --gres=gpu:4
#SBATCH --hint=nomultithread
#SBATCH --time=00:10:00
#SBATCH --account=omr@v100
#SBATCH --qos=qos_gpu-dev

./jobs/launch_job.sh