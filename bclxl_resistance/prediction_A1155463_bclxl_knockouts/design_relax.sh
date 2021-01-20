#!/bin/bash 
if [ $# -eq 0 ]; then
  echo $0 "[pdb_file]"
  exit
fi
mkdir output_tmp > /dev/null 2>&1
# First compute the unminimized energy
/work/upcorreia/bin/Rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease \
	-overwrite \
	-out:file:renumber_pdb false\
	-ex1 \
	-ex2 -ignore_zero_occupancy false \
	-parser:protocol ~/lpdi_fs/rosettascripts/compute_pdb_energy.xml\
	-s $1\
	-ignore_unrecognized_res -nstruct 1 \
	-out:path:all ./output_tmp
# Move the minimized structure to this directory and change its name.
MY_BASENAME=$(echo $1| sed -e 's#.pdb##' )
mv output_tmp/*.pdb ./$MY_BASENAME\_unmin.pdb
# Now do the actual minimization
/work/upcorreia/bin/Rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease \
	-overwrite \
	-out:file:renumber_pdb false\
	-ex1 \
	-ex2 -ignore_zero_occupancy false \
	-parser:protocol ~/lpdi_fs/rosettascripts/minimize_pdb_energy.xml\
	-s $1\
	-ignore_unrecognized_res -nstruct 1 \
	-out:path:all ./output_tmp
# Move the minimized structure to this directory and change its name.
MY_BASENAME=$(echo $1| sed -e 's#.pdb##' )
mv output_tmp/*.pdb ./$MY_BASENAME\_min.pdb
# Copy the scores
cp output_tmp/score.sc ./minimizationScores.txt
rm -rf output_tmp
