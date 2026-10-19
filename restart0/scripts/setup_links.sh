#!/usr/bin/env bash
set -e

# Large forcing files are GitHub release assets (over the 100 MB file limit), downloaded once into CACHE.
CACHE=${DINO_CACHE:-/lustre/fswork/projects/rech/omr/romr004/etienne/cache}
RELEASE=https://github.com/Etienne-Meunier/Dinonline/releases/download/climatology-v1
CLIMATO=emp_climatology_1_4deg.nc
CLIMATO_SHA256=7d0a480683afb209883250c6e7a88e3efa47d73b09ede0a04cc7321bd4122561

mkdir -p "$CACHE"
if [ ! -f "$CACHE/$CLIMATO" ]; then
    echo "Downloading $CLIMATO -> $CACHE"
    curl -fL --retry 3 -o "$CACHE/$CLIMATO.part" "$RELEASE/$CLIMATO"
    mv "$CACHE/$CLIMATO.part" "$CACHE/$CLIMATO"
fi
echo "$CLIMATO_SHA256  $CACHE/$CLIMATO" | sha256sum -c -

echo "Setup symlinks:"
echo "                $CLIMATO -> $CACHE/$CLIMATO"
ln -sfn "$CACHE/$CLIMATO" "$CLIMATO"

echo "Done"
