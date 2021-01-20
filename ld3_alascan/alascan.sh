#!/bin/bash
srun /work/upcorreia/bin/Rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease -overwrite -out:file:renumber_pdb true -ex1 -ex2 -ignore_zero_occupancy false -parser:protocol alascan.xml -s $1 -out:path:all . 

