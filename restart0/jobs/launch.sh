#!/usr/bin/env bash
#SBATCH --job-name=Blandine_C1_1_4deg
#SBATCH --hint=nomultithread       # 1 MPI process per physical core (no hyperthreading)
#SBATCH --time=12:00:00
#SBATCH --output=Blandine_C1_1_4deg.out
#SBATCH --ntasks-per-node=40
#SBATCH --nodes=15
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=david.kamm@locean.ipsl.fr
#SBATCH --account=omr@cpu # cpu accounting
#SBATCH --qos=qos_cpu-t3 # QoS
######################

# initial and last time step in namelist.cfg

cd ${SLURM_SUBMIT_DIR}

pwd; hostname; date

# --- STEP 1: update namelist_cfg from restart.config ---
# restart.config format:
# cn_ocerst_in=my_restart_file.nc
RESTART_FILE=$(grep '^cn_ocerst_in=' restart.config | cut -d'=' -f2)

if [ -z "$RESTART_FILE" ]; then
    echo "ERROR: restart.config missing or cn_ocerst_in not set"
    exit 1
fi

# Replace in namelist_cfg (preserving rest of file)
sed -i "s|^\( *cn_ocerst_in *= *\).*|\1'${RESTART_FILE}'|" namelist_cfg
echo "Updated namelist_cfg with cn_ocerst_in='${RESTART_FILE}'"

# --- STEP 2: launch the run ---


module purge # purge modules inherited by default

# loading necessary modules
intel_version=19.0.4
module load intel-compilers/${intel_version}
module load intel-mpi/${intel_version}
module load hdf5/1.10.5-mpi
module load netcdf/4.7.2-mpi
module load netcdf-fortran/4.5.2-mpi

source $I_MPI_ROOT/intel64/bin/mpivars.sh release_mt

time srun  --multi-prog ./jobs/mpmd.conf

date

