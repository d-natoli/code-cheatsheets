---------------------
Apply puppet manifest
---------------------
sudo puppet apply --verbose manifests/site.pp

-----------------
Test run manifest
-----------------
sudo puppet apply --noop --verbose --show_diff manifests/site.pp
