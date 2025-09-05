# Move to execution directory
cd ${SLURM_SUBMIT_DIR}
set -x
pwd

# job information
cat << EOF
------------------------------------------------------------------
Job submit on $SLURM_SUBMIT_HOST by $SLURM_JOB_USER
JobID=$SLURM_JOBID Running_Node=$SLURM_NODELIST
Node=$SLURM_JOB_NUM_NODES Task=$SLURM_NTASKS
------------------------------------------------------------------
EOF

set -e
ls -l

date

./jobs/prepare_job.sh

time srun --multi-prog ./jobs/run_file

date
