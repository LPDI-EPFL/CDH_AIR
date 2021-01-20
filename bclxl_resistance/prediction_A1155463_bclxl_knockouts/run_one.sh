#!/bin/bash
CHAIN="A"
PARAMS_FILE=/home/gainza/lpdi_fs/protein_designs/car-project/aim1/bclxl_bh3/03-msd/prediction_A1155463_bclxl_knockouts/negative_design/3CQ.params
ROSETTASCRIPTS_EXECUTABLE=/work/upcorreia/bin/Rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease
FIXBB_EXECUTABLE=/work/upcorreia/bin/Rosetta/main/source/bin/fixbb.default.linuxgccrelease
source $1
echo "Residues $residue1 $residue2"
#### Residue 1
  if [ $residue1 == 15 ]; then
    MUTANT_AA1="F Y L I V"
  fi
  if [ $residue1 == 16 ]; then
    MUTANT_AA1="E S"
  fi
  if [ $residue1 == 20 ]; then
    MUTANT_AA1="F R K D E H"
  fi
  if [ $residue1 == 23 ]; then
    MUTANT_AA1="F L V I A"
  fi
  if [ $residue1 == 27 ]; then
    MUTANT_AA1="S A T L V"
  fi
  if [ $residue1 == 60 ]; then
    MUTANT_AA1="A F I L V"
  fi
  if [ $residue1 == 63 ]; then
    MUTANT_AA1="S D E V A"
  fi
  if [ $residue1 == 67 ]; then
    MUTANT_AA1="V A L I"
  fi
#### Residue 2
  if [ $residue2 == 15 ]; then
    MUTANT_AA2="F Y L I V"
  fi
  if [ $residue2 == 16 ]; then
    MUTANT_AA2="E S"
  fi
  if [ $residue2 == 20 ]; then
    MUTANT_AA2="F R K D E H"
  fi
  if [ $residue2 == 23 ]; then
    MUTANT_AA2="F L V I A"
  fi
  if [ $residue2 == 27 ]; then
    MUTANT_AA2="S A T L V"
  fi
  if [ $residue2 == 60 ]; then
    MUTANT_AA2="A F I L V"
  fi
  if [ $residue2 == 63 ]; then
    MUTANT_AA2="S D E V A"
  fi
  if [ $residue2 == 67 ]; then
    MUTANT_AA2="V A L I"
  fi
    for aa1 in $MUTANT_AA1; do
      for aa2 in $MUTANT_AA2; do
        posdir=positive_design/$residue1$aa1\_$residue2$aa2
        negdir=negative_design/$residue1$aa1\_$residue2$aa2
        mkdir -p $posdir
        mkdir -p $negdir
        cp positive_design/resfile_template $posdir/resfile
        cp negative_design/resfile_template $negdir/resfile
        sed -i "s/^$residue1 $CHAIN NATAA/$residue1 $CHAIN PIKAA $aa1/" $posdir/resfile
        sed -i "s/^$residue2 $CHAIN NATAA/$residue2 $CHAIN PIKAA $aa2/" $posdir/resfile
        sed -i "s/^$residue1 $CHAIN NATAA/$residue1 $CHAIN PIKAA $aa1/" $negdir/resfile
        sed -i "s/^$residue2 $CHAIN NATAA/$residue2 $CHAIN PIKAA $aa2/" $negdir/resfile
        cd $posdir
        rm *.pdb
        rm *.sc
        $FIXBB_EXECUTABLE -ex1 -ex2 \
            -s ../positive.pdb -use_input_sc -resfile resfile -overwrite \
            -out:prefix pos_
        echo "ENDING PACKER"
		$ROSETTASCRIPTS_EXECUTABLE \
	        -overwrite \
	        -out:file:renumber_pdb false\
	        -ex1 \
	        -ex2 -ignore_zero_occupancy false \
                -parser:protocol ../../relax.xml\
	        -s pos_positive_0001.pdb -out:prefix pos_
        POSITIVE_BOUND=$(tail -1 pos_score.sc | tr -s ' ' | cut -d " " -f2)
        echo "POSITIVE BOUND=$POSITIVE_BOUND"

        sed -i "s/.* K NATAA//" resfile
        $FIXBB_EXECUTABLE -ex1 -ex2 \
            -s ../positive_unbound.pdb -use_input_sc -resfile resfile \
        -overwrite -out:prefix pos_ub_
		$ROSETTASCRIPTS_EXECUTABLE \
	        -overwrite \
	        -out:file:renumber_pdb false\
	        -ex1 \
	        -ex2 -ignore_zero_occupancy false \
                -parser:protocol ../../relax.xml\
	        -s pos_ub_positive_unbound_0001.pdb -out:prefix pos_ub_
        POSITIVE_UNBOUND=$(tail -1 pos_ub_score.sc | tr -s ' ' | cut -d " " -f2)
        cd ../../
        
        
        # NEGATIVE BOUND STATE RUN 
        cd $negdir
        rm *.pdb
        rm *.sc
        echo "DIRECTORY:"
        pwd
        $FIXBB_EXECUTABLE -ex1 -ex2 \
            -s ../negative.pdb -use_input_sc -resfile resfile -overwrite \
            -extra_res_fa $PARAMS_FILE -out:prefix neg_
		$ROSETTASCRIPTS_EXECUTABLE \
	        -overwrite \
	        -out:file:renumber_pdb false\
	        -ex1 \
	        -ex2 -ignore_zero_occupancy false \
	        -parser:protocol ../../relax.xml\
	        -s neg_negative_0001.pdb\
            -extra_res_fa $PARAMS_FILE -out:prefix neg_
        NEGATIVE_BOUND=$(tail -1 neg_score.sc | tr -s ' ' | cut -d " " -f2)

        # NEGATIVE UNBOUND STATE RUN
        sed -i "s/^301 $CHAIN NATAA//" resfile
        $FIXBB_EXECUTABLE -ex1 -ex2 \
            -s ../negative_unbound.pdb -use_input_sc -resfile resfile -overwrite \
            -out:prefix neg_ub_
		$ROSETTASCRIPTS_EXECUTABLE \
	        -overwrite \
	        -out:file:renumber_pdb false\
	        -ex1 \
	        -ex2 -ignore_zero_occupancy false \
	        -parser:protocol ../../relax.xml\
	        -s neg_ub_negative_unbound_0001.pdb -out:prefix neg_ub_
        NEGATIVE_UNBOUND=$(tail -1 neg_ub_score.sc | tr -s ' ' | cut -d " " -f2)

        cd ../../

#        echo -e "$(($POSITIVE_BOUND + $NEGATIVE_UNBOUND - $POSITIVE_UNBOUND - $NEGATIVE_BOUND))"
        deltaG=$(python -c "print $POSITIVE_BOUND + $NEGATIVE_UNBOUND - $POSITIVE_UNBOUND - $NEGATIVE_BOUND")
        deltaG_only_bound=$(python -c "print $POSITIVE_BOUND - $NEGATIVE_BOUND")

        echo -e "$residue1$aa1 $residue2$aa2 $POSITIVE_BOUND $POSITIVE_UNBOUND $NEGATIVE_BOUND $NEGATIVE_UNBOUND $deltaG $deltaG_only_bound" >> positive_negative_scores.txt
      done
    done

