#!/usr/bin/env bash
set -euo pipefail

# Default files
DEFAULT_CONFIG_FILE="online_config.yaml"
DEFAULT_NAMELIST_FILE="namelist_cfg"
DEFAULT_XIOS_CONFIG_FILE="file_def_nemo-oce.xml"
NAM_REBUILD_FILE="nam_rebuild"

# Handle arguments
if [ $# -eq 0 ]; then
    CONFIG_FILE="$DEFAULT_CONFIG_FILE"
    NAMELIST_FILE="$DEFAULT_NAMELIST_FILE"
    XIOS_CONFIG_FILE="$DEFAULT_XIOS_CONFIG_FILE"
elif [ $# -eq 3 ]; then
    CONFIG_FILE=$1
    NAMELIST_FILE=$2
    XIOS_CONFIG_FILE=$3
else
    echo "Usage: $0 [online_config.yaml namelist_cfg xios_config.xml]"
    exit 1
fi

# Extract restart path, number of steps, and xios_debug
RESTART_FILE=$(grep '^restart_path:' "$CONFIG_FILE" | awk '{print $2}')
NSTEPS=$(grep '^nsteps:' "$CONFIG_FILE" | awk '{print $2}')
XIOS_DEBUG=$(grep '^xios_debug:' "$CONFIG_FILE" | awk '{print $2}')

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
IT_BASE=$(printf "%.0f" $TIME_COUNTER)
NN_IT000=$(( IT_BASE + 1 ))
NN_ITEND=$(( NN_IT000 + NSTEPS - 1 ))
NN_ITSAVE=$(( NN_ITEND + 1 ))

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

# Enable or disable inst_debug file group
if [ "$XIOS_DEBUG" = "True" ] || [ "$XIOS_DEBUG" = "true" ]; then
    sed -i '/<file_group.*id="inst_debug"/ s/enabled *= *".*"/enabled=".TRUE."/g' "$XIOS_CONFIG_FILE"
else
    sed -i '/<file_group.*id="inst_debug"/ s/enabled *= *".*"/enabled=".FALSE."/g' "$XIOS_CONFIG_FILE"
fi

# Print summary
echo "Updated namelist_cfg:"
echo "  cn_ocerst_in = '${RESTART_BASENAME}'"
echo "  nn_it000     = ${NN_IT000}"
echo "  nn_itend     = ${NN_ITEND}"

if [ -f "$NAM_REBUILD_FILE" ]; then
    echo "Updated nam_rebuild:"
    echo "  filebase    = \"${NEW_FILEBASE}\""
fi

if [ "$XIOS_DEBUG" = "True" ] || [ "$XIOS_DEBUG" = "true" ]; then
    echo "Enabled XIOS file_group 'inst_debug'"
else
    echo "Disabled XIOS file_group 'inst_debug'"
fi
