#!/usr/bin/env bash

# Load modules and environment
module purge

intel_version=19.0.4
module load intel-compilers/${intel_version}
module load intel-mpi/${intel_version}
module load hdf5/1.10.5-mpi
module load netcdf/4.7.2-mpi
module load netcdf-fortran/4.5.2-mpi
module load python/3.10.4

source $I_MPI_ROOT/intel64/bin/mpivars.sh release_mt

set -e  # exit on error
set -x  # echo commands

pwd

./scripts/setup_links.sh

# Step 1: Preproduction
echo "[INFO] Running preprod to generate namcouple..."
rm -f namcouple*
srun --mpi=pmi2 python3 ./main.py --exec preprod

# Check result
if [[ ! -f namcouple ]]; then
    echo "[ERROR] namcouple was not created — exiting."
    exit 1
fi

echo "[INFO] namcouple created successfully."

# Save logs if applicable
[[ -f eophis.out ]] && mv eophis.out eophis_preprod.out
[[ -f eophis.err ]] && mv eophis.err eophis_preprod.err

# Step 2: Run coupled job with srun
echo "[INFO] Launching simplified coupled run..."
time srun --multi-prog ./jobs/run_file_interactive
