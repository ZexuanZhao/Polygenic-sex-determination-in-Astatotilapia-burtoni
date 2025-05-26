# Polygenic sex determination in *Astatotilapia burtoni* (Teleostei: Cichlidae)

The custom scripts used in "Polygenic sex determination in *Astatotilapia burtoni* (Teleostei: Cichlidae)" are contained here.

## `calculate_heterozygosity_from_vcf.R`
   
This script calculates heterozygosity from a .vcf in-file. It outputs both a file containing the heterozygous sites and a summary table of homozygosity, heterozygosity, and the fraction of heterozygous sites in the total. 

## `calculate_roh.R`
   
This script takes the output from bedtools windows of windowed heterozygosity and detects runs of homozygosity. The output is a table summarizing the number of runs (what is considered a run is adjustable by the user, here set to 5 100kbp windows) per chromosome, and the total number of windows in runs per chromosome. What is considered homozygous (here, < 2 is used for PacBio data, and < 100 is used for Illumina) is also determined by the user, and should be carefully considered. 

## `normalize_allele_frequency_nonzero.py`
   
This script takes a .sync file from Popoolation2 and normalizes each sex (here, population 1 and population 2) based on the user's calculation of coverage. The output is a corrected .sync file, which can be used for downstream analyses. This script is additionally designed so that when dividing, no value >= 1 is changed to zero. 
