#!/bin/bash
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 4096
#SBATCH --time 10:00:00
#SBATCH --array=1-1000
#SBATCH --output=/scratch/gainza/lpdi_fs/protein_designs/car-project/aim1/bcl2_bh3/02e-scaffold_search_design_mediumMotif_largedb/exelogs/out/splitfile.%A_%a.out
#SBATCH --error=/scratch/gainza/lpdi_fs/protein_designs/car-project/aim1/bcl2_bh3/02e-scaffold_search_design_mediumMotif_largedb/exelogs/err/splitfile.%A_%a.err

mkdir -p /scratch/gainza/lpdi_fs/protein_designs/car-project/aim1/bcl2_bh3/02e-scaffold_search_design_mediumMotif_largedb/results/${SLURM_ARRAY_TASK_ID}
srun /work/upcorreia/bin/Rosetta/main/source/bin/rosetta_scripts.default.linuxgccrelease -overwrite -out:file:renumber_pdb true -ex1 -ex2 -ignore_zero_occupancy false -parser:protocol motif_graft_and_design.xml -l /scratch/gainza/lpdi_fs/protein_designs/car-project/aim1/bcl2_bh3/02e-scaffold_search_design_mediumMotif_largedb/exelogs/in/splitfile.${SLURM_ARRAY_TASK_ID}.split -mute all -ignore_unrecognized_res -nstruct 1 -out:path:all /scratch/gainza/lpdi_fs/protein_designs/car-project/aim1/bcl2_bh3/02e-scaffold_search_design_mediumMotif_largedb/results/${SLURM_ARRAY_TASK_ID}

echo "CASTOR: RUN FINISHED"
