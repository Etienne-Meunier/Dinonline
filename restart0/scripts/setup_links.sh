#!/usr/bin/env bash

DATA=/lustre/fswork/projects/rech/omr/romr004/data/

# NEMO Execution
NEMO_EXECUTABLE=$DATA/executables/alexis_v2/nemo.exe
REBUILD_NEMO=$DATA/executables/alexis_v2/rebuild_nemo.exe
ARCH=$DATA/executables/alexis_v2/local_libs/arch_files/modules_source_gcc_pt

# Data
RESTART_FILES=$DATA/restart_files/

# Code
ZB_DINO=/lustre/fsn1/projects/rech/omr/romr004/code/ZB_DINO/

echo "Setup symlinks:"

echo "                nemo -> $NEMO_EXECUTABLE"
ln -sfn $NEMO_EXECUTABLE nemo

echo "                rebuild_nemo.exe -> $REBUILD_NEMO"
ln -sfn $REBUILD_NEMO rebuild_nemo.exe

echo "                arch -> $ARCH"
ln -sfn $ARCH arch

echo "                restart_files -> $RESTART_FILES"
ln -sfn $RESTART_FILES restart_files

echo "                ZB_DINO -> $ZB_DINO"
ln -sfn $ZB_DINO ZB_DINO

echo "Done"
