#!/usr/bin/env bash
######################
## JEANZAY IDRIS ##
######################
#SBATCH --job-name=DINO_MK25
#SBATCH --output=DINO_MK25.out
#SBATCH --error=DINO_MK25.err
#SBATCH --ntasks=10
#SBATCH --time=0:30:00
#SBATCH --account=cli@cpu
#SBATCH --partition=prepost

# Process distribution
NPROCS_NEMO=8
NPROCS_PYTHON=2

# loading necessary modules
module purge
module load pytorch-gpu/py3/2.2.0
module load netcdf-c/4.7.4-mpi-cuda
module load netcdf-fortran/4.5.3-mpi-cuda
module load hdf5/1.12.0-mpi-cuda
module load DCM/4.2.1
module load nco/4.9.3

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

# write multi-prog file
touch run_file
rm -r run_file
echo 0-$((NPROCS_NEMO - 1)) ./nemo >> run_file
echo ${NPROCS_NEMO}-$((NPROCS_NEMO + NPROCS_PYTHON - 1)) python3 ./main.py --exec prod >> run_file

module list
# run coupled NEMO-Python
time srun --multi-prog ./run_file

date
