library(tidyverse)

input_file <- ""
het_cutoff <- 100 ## Definition: windows with n<cutoff het calls are considered as homozygous
n_window_cutoff <- 5 ## Definition: more than n>=cutoff consecutive windows that are homozygous are considered as run of hom

# Read in
data <- read.table(file = input_file, header = TRUE)

# Remove trailing regions per LG with Het = 0
data_filtered <- tibble()
for (lg in data$LG %>% unique()){
  data_lg <- data %>% 
    filter(LG == lg)
  for (i in rev(1:nrow(data_lg))){
    if(data_lg[i,]$Het ==0){
      data_lg[i,]$Het <- NA
    }else{
      break
    }
  }
  data_filtered <- data %>% 
    bind_rows(data %>% filter(!is.na(Het)))
}

# Change Het to binary encoding
data_binary <- data_filtered %>% 
  mutate(Het = ifelse(Het < het_cutoff, FALSE, TRUE))

# Transform to rle data structure
get_rle_by_LG <- function(data){
  out <- list()
  for (lg in data$LG %>% unique()){
    out[[lg]] <- data %>% 
      filter(LG == lg) %>% 
      pull(Het) %>% 
      rle
  }
  out
}
data_rle <- data_binary %>% 
  get_rle_by_LG() 

# Summarize run of homozygosity by LG
summary_table <- tibble()
for (lg in names(data_rle)){
  rle <- data_rle[[lg]]
  rle_tb <- tibble(size = rle$lengths, state = rle$values) %>% 
    mutate(state = ifelse(state, "het", "hom")) ## This table is easier to work with
  rle_sig <- rle_tb %>% 
    filter(state == "hom") %>% 
    filter(size >= n_window_cutoff)
  summary_table <- summary_table %>% 
    bind_rows(tibble(LG = lg, n_regions = nrow(rle_sig), total_n_windows = rle_sig$size %>% sum()))
}
summary_table
