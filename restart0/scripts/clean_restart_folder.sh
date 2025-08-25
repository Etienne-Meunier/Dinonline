#!/bin/bash

# Target directory to clean (change if needed)
TARGET_DIR="."

# Patterns of files/directories to remove
PATTERNS=(
    "DINO_*_restart_*.nc"
    "DINO_*_restart.nc"
    "DINO_10d_grid_inst_*.nc"
    "DINO_1m_grid_T_2D.nc"
    "DINO_3m_grid_*.nc"
    "DINO_1ts_*.nc"
    "core-python3-*"
    "debug.*"
    "DINO_MK25.*"
    "eophis*"
    "nout.*"
    "run.stat"
    "run.stat.nc"
    "time.step"
    "timing.output"
    "ocean.output"
    "ocean.output*"
    "namcouple"
    "core-nemo-*"
    "namcouple_ref"
    "communication_report.txt"
    "layout.dat"
    "output.namelist.dyn"
    "debug"
)


echo "Cleaning directory: $TARGET_DIR"
echo "The following items will be deleted based on wildcard patterns:"
for pattern in "${PATTERNS[@]}"; do
    echo "  - $pattern"
done

read -p "Are you sure you want to delete these files? [y/N]: " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 0
fi

# Perform deletion
for pattern in "${PATTERNS[@]}"; do
    matches=("$TARGET_DIR"/$pattern)
    for match in "${matches[@]}"; do
        if [[ -e "$match" ]]; then
            rm -rf "$match"
            echo "Deleted: $match"
        fi
    done
done

echo "Cleanup complete."
