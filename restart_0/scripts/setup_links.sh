NEMO_EXECUTABLE=/lustre/fswork/projects/rech/omr/uym68qx/nemo_4.2.1/tests/DINO_GZ21/BLD/bin/nemo.exe
REBUILD_NEMO=/lustre/fswork/projects/rech/omr/uym68qx/nemo_4.2.1/tools/REBUILD_NEMO/rebuild_nemo.exe
RESTART_FILES=/lustre/fsn1/projects/rech/omr/romr004/data/restart_files/
ZB_DINO=/lustre/fsn1/projects/rech/omr/romr004/code/ZB_DINO/

echo "Setup symlinks"

ln -sfn $NEMO_EXECUTABLE nemo
ln -sfn $REBUILD_NEMO rebuild_nemo.exe
ln -sfn $RESTART_FILES restart_files
ln -sfn $ZB_DINO ZB_DINO

echo "Done"
