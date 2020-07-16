#!/bin/bash

# This script updates the covid-19-community knowledge graph

cd $COVID19/notebooks/dataprep
 
LOGDIR="$NEO4J_IMPORT"/logs/`date +%Y-%m-%d`
mkdir -p "$LOGDIR"

# enable conda in bash (see: https://github.com/conda/conda/issues/7980)
eval "$(conda shell.bash hook)"

# create conda environment
conda env remove -n covid-19-sandiego &>> $LOGDIR/update.log
conda env create -f $COVID19/environment.yml &>> $LOGDIR/update.log
conda activate covid-19-sandiego &>> $LOGDIR/update.log

# run Jupyter Notebooks to download, clean, and standardize data for the knowledge graph
# To check for any errors, look at the executed notebooks in the $LOGDIR directory

for f in *.ipynb 
do 
  echo "Processing $f file.."
  papermill $f "$LOGDIR"/$f
done

# deactivate conda environment
conda deactivate &>> $LOGDIR/update.log
