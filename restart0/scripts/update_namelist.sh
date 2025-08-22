#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 online_config.yaml namelist_cfg"
    exit 1
fi

CONFIG_FILE=$1
NAMELIST_FILE=$2

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
NN_IT000=$(( $(printf "%.0f" $TIME_COUNTER) + 1 ))  # add 1 here
NN_ITEND=$((NN_IT000 + NSTEPS))

# Update namelist_cfg
RESTART_BASENAME="${RESTART_FILE%.nc}"

sed -i "s|^\( *cn_ocerst_in *= *\).*|\1'${RESTART_BASENAME}'|" "$NAMELIST_FILE"
sed -i "s|^\( *nn_it000 *= *\).*|\1${NN_IT000}|" "$NAMELIST_FILE"
sed -i "s|^\( *nn_itend *= *\).*|\1${NN_ITEND}|" "$NAMELIST_FILE"

echo "Updated namelist_cfg:"
echo "  cn_ocerst_in = '${RESTART_BASENAME}'"
echo "  nn_it000     = ${NN_IT000}"
echo "  nn_itend     = ${NN_ITEND}"
