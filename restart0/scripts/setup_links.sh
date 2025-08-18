REBUILD_NEMO=/lustre/fswork/projects/rech/omr/uym68qx/nemo_4.2.1/tools/REBUILD_NEMO/rebuild_nemo.exe
RESTART_FILES=/lustre/fsn1/projects/rech/omr/romr004/data/diffusion_states/

echo "Setup symlinks:"

echo "                rebuild_nemo.exe -> $REBUILD_NEMO"
ln -sfn $REBUILD_NEMO rebuild_nemo.exe

echo "                diffusion_states -> $RESTART_FILES"
ln -sfn $RESTART_FILES diffusion_states

echo "Done"
