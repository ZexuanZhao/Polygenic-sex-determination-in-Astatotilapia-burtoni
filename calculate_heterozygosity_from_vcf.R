library(tidyverse)
# Input vcf file
vcf_file <- ""
# Read in header
line <- readLines(vcf_file, n = 10000)
comment_lines <- line[str_detect(line, "#")]
tbl_header <- comment_lines[length(comment_lines)] %>% 
  str_remove("#") %>% 
  str_split_1("\t")
tbl_header[length(tbl_header)] <- "call"
rm(line, comment_lines)
# Read in table
vcf_tbl <- read_tsv(file.path(path, vcf_file), comment = "#", col_names = tbl_header) %>% 
  select(chr = CHROM, pos = POS, call) %>% 
  mutate(genotype = genotype %>% str_extract("[^:]+"))

# Check your genotype and define heterozugous/homozygous genotype
vcf_tbl$genotype %>% unique()
stop()
# TODO: modify below if necessary
homo_type <- c("0/0", "1/1")
het_type <- c("0/1")

# Calculate heterozygosity
genotype %>% #
  summarize(n_het = sum(genotype %in% het_type),
            n_hom = sum(genotype %in% homo_type)) %>% 
  mutate(p = n_het/(n_hom+n_het))