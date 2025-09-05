# Load Environnment
# source ~/.bash_profile
module purge # purge modules inherited by default

# loading necessary modules
if command -v conda >/dev/null 2>&1; then
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        # make sure the conda shell functions are available
        source "$(conda info --base)/etc/profile.d/conda.sh"
        conda deactivate
    else
        echo "No conda environment active"
    fi
else
    echo "Skipping conda deactivate (conda not found)"
fi

source ./arch

source $I_MPI_ROOT/intel64/bin/mpivars.sh release_mt

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