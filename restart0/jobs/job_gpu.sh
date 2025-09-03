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
#SBATCH --time=6:00:00
#SBATCH --account=omr@v100
#SBATCH --qos=qos_gpu-t3

# Load Environnment
# source ~/.bash_profile
module purge # purge modules inherited by default

# loading necessary modules
command -v conda >/dev/null 2>&1 && conda deactivate || echo "Skipping conda deactivate (conda not found)"

source arch

source $I_MPI_ROOT/intel64/bin/mpivars.sh release_mt

# Move to execution directory
cd ${SLURM_SUBMIT_DIR}
set -x
pwd

date

# job information
cat << EOF
------------------------------------------------------------------
Job submit on $SLURM_SUBMIT_HOST by $SLURM_JOB_USER
JobID=$SLURM_JOBID Running_Node=$SLURM_NODELIST
Node=$SLURM_JOB_NUM_NODES Task=$SLURM_NTASKS
------------------------------------------------------------------
EOF

# Begin of section with executable commands
set -e
ls -l

./scripts/setup_links.sh
./scripts/update_namelist.sh

# run eophis in preproduction mode to generate namcouple
touch namcouple
rm namcouple*
python3 ./main.py --exec preprod

# save eophis preproduction logs
mv eophis.out eophis_preprod.out
mv eophis.err eophis_preprod.err

# check if preproduction did well generate namcouple
namcouple=namcouple
if [ ! -e ${namcouple} ]; then
        echo "namcouple can not be found, preproduction failed"
        exit 1
else
        echo "preproduction successful"
fi

module list
# run coupled NEMO-Python
time srun --multi-prog ./jobs/run_file

date
