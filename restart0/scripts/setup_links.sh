REBUILD_NEMO=/lustre/fswork/projects/rech/omr/uym68qx/nemo_4.2.1/tools/REBUILD_NEMO/rebuild_nemo.exe
CLIMATO=/lustre/fswork/projects/rech/omr/romr004/data/dino_files/emp_climatology_1_4deg.nc

echo "Setup symlinks:"

echo "                rebuild_nemo.exe -> $REBUILD_NEMO"
ln -sfn $REBUILD_NEMO rebuild_nemo.exe

echo "                emp_climatology_1_4deg.nc -> $CLIMATO"
ln -sfn $CLIMATO emp_climatology_1_4deg.nc

echo "Done"
