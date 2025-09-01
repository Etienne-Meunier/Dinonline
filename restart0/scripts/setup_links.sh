#!/usr/bin/env bash

NEMO_EXECUTABLE=/lustre/fswork/projects/rech/cli/udp79td/nemo_v4.2.1/cfgs/DINO/BLD/bin//nemo.exe
REBUILD_NEMO=/lustre/fswork/projects/rech/omr/romr004/data/executables/david_v1/rebuild_nemo.exe
RESTART_FILES=/lustre/fswork/projects/rech/omr/romr004/data/restart_files/
ZB_DINO=/lustre/fsn1/projects/rech/omr/romr004/code/ZB_DINO/

echo "Setup symlinks:"

echo "                nemo -> $NEMO_EXECUTABLE"
ln -sfn $NEMO_EXECUTABLE nemo

echo "                rebuild_nemo.exe -> $REBUILD_NEMO"
ln -sfn $REBUILD_NEMO rebuild_nemo.exe

echo "                restart_files -> $RESTART_FILES"
ln -sfn $RESTART_FILES restart_files

echo "                ZB_DINO -> $ZB_DINO"
ln -sfn $ZB_DINO ZB_DINO

echo "Done"
