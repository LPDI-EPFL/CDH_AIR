#!/bin/bash
#SBATCH --nodes 1
#SBATCH --ntasks-per-node 1
#SBATCH --cpus-per-task 1
#SBATCH --mem 4096
#SBATCH --time 10:00:00
#SBATCH --array=1-21
#SBATCH --output=/home/gainza/lpdi_fs/protein_designs/car-project/aim1/bclxl_bh3/03-msd/prediction_A1155463_bclxl_knockouts/out/splitfile.%A_%a.out
#SBATCH --error=/home/gainza/lpdi_fs/protein_designs/car-project/aim1/bclxl_bh3/03-msd/prediction_A1155463_bclxl_knockouts/err/splitfile.%A_%a.err

cd /home/gainza/lpdi_fs/protein_designs/car-project/aim1/bclxl_bh3/03-msd/prediction_A1155463_bclxl_knockouts/
echo -e "MUTATIONS POSITIVE_BOUND POSITIVE_UNBOUND NEGATIVE_BOUND \
NEGATIVE_UNBOUND RATIO_SCORE RATIO_SCORE_BOUND" >> positive_negative_scores.txt
srun /home/gainza/lpdi_fs/protein_designs/car-project/aim1/bclxl_bh3/03-msd/prediction_A1155463_bclxl_knockouts/run_one.sh /home/gainza/lpdi_fs/protein_designs/car-project/aim1/bclxl_bh3/03-msd/prediction_A1155463_bclxl_knockouts/in/${SLURM_ARRAY_TASK_ID}

echo "CASTOR: RUN FINISHED"
