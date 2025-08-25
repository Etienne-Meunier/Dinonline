#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 online_config.yaml namelist_cfg"
    exit 1
fi

CONFIG_FILE=$1
NAMELIST_FILE=$2
NAM_REBUILD_FILE="nam_rebuild"

# Extract restart path and number of steps from YAML
RESTART_FILE=$(grep '^restart_path:' "$CONFIG_FILE" | awk '{print $2}')
NSTEPS=$(grep '^nsteps:' "$CONFIG_FILE" | awk '{print $2}')

if [ -z "$RESTART_FILE" ] || [ -z "$NSTEPS" ]; then
    echo "ERROR: online_config.yaml missing restart_path or nsteps"
    exit 1
fi

if [ ! -f "$RESTART_FILE" ]; then
    echo "ERROR: restart file $RESTART_FILE not found"
    exit 1
fi

# Extract time_counter from restart
TIME_COUNTER=$(ncks -H -C --trd -v time_counter "$RESTART_FILE" | sed 's/.*=//')
IT_BASE=$(printf "%.0f" $TIME_COUNTER)              # raw time counter
NN_IT000=$(( IT_BASE + 1 ))                         # restart step + 1
NN_ITEND=$(( NN_IT000 + NSTEPS - 1 ))               # last iteration
NN_ITSAVE=$(( NN_ITEND + 1 ))                         # for nam_rebuild

# Update namelist_cfg
RESTART_BASENAME="${RESTART_FILE%.nc}"

sed -i "s|^\( *cn_ocerst_in *= *\).*|\1'${RESTART_BASENAME}'|" "$NAMELIST_FILE"
sed -i "s|^\( *nn_it000 *= *\).*|\1${NN_IT000}|" "$NAMELIST_FILE"
sed -i "s|^\( *nn_itend *= *\).*|\1${NN_ITEND}|" "$NAMELIST_FILE"

# Update nam_rebuild if present
if [ -f "$NAM_REBUILD_FILE" ]; then
    FILEBASE_PREFIX=$(grep 'filebase=' "$NAM_REBUILD_FILE" | sed 's/.*"\(.*\)_[0-9]\+_restart".*/\1/')
    NEW_FILEBASE="${FILEBASE_PREFIX}_${NN_ITSAVE}_restart"
    sed -i "s|^\( *filebase *= *\).*|\1\"${NEW_FILEBASE}\"|" "$NAM_REBUILD_FILE"
fi

echo "Updated namelist_cfg:"
echo "  cn_ocerst_in = '${RESTART_BASENAME}'"
echo "  nn_it000     = ${NN_IT000}"
echo "  nn_itend     = ${NN_ITEND}"

if [ -f "$NAM_REBUILD_FILE" ]; then
    echo "Updated nam_rebuild:"
    echo "  filebase    = \"${NEW_FILEBASE}\""
fi