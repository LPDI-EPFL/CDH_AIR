#!/bin/bash
srun /work/upcorreia/bin/Rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease -overwrite -out:file:renumber_pdb true -ex1 -ex2 -ignore_zero_occupancy false -parser:protocol motif_graft_and_design.xml -s $1 -mute all -ignore_unrecognized_res -nstruct 1 -out:path:all output_wt

echo "CASTOR: RUN FINISHED"
