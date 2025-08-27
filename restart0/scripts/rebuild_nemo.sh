#!/usr/bin/env bash

if ./rebuild_nemo.exe | tee /tmp/rebuild.log | grep -q "NEMO rebuild completed successfully"; then
    rm DINO_*_restart_*.nc
fi