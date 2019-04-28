library("magrittr")
library("Matrix")
library("ggplot2")
setwd("~/Dropbox/blog posts/zebrafish scRNA/analysis/")
expr = read.csv("data/TracerSeq embryo1/GSM3067196_TracerSeq1_nm.csv.gz", header = T, row.names = 1)
expr %<>% as.matrix %>% Matrix(sparse = T)
all_cell_barcodes = colnames(expr)
tol2 = read.csv("data/TracerSeq_CellTracerCounts/TracerSeq1_CellTracerCounts.csv", header = F) 
#metadata = read.csv("data/TracerSeq embryo1/GSM3067196_TracerSeq1_clustID.txt.gz", header = F) 
colnames(tol2) = c("cell_bc", "clone_number", "clone_bc", "count")

tol2_cellcount_dist = tol2$clone_bc %>% table %>% table %>% 
  as.data.frame %>% 
  set_colnames(c("cell_count", "frequency")) 
tol2_cellcount_dist$cell_count %<>% as.character %>% as.numeric
subset( tol2_cellcount_dist, cell_count != 1 ) %>%
  ggplot() + geom_bar(stat="identity", aes(x=cell_count, y=frequency))

cell_tol2count_dist = tol2$cell_bc %>% table %>% table %>% 
  as.data.frame %>% 
  set_colnames(c("tol2_count", "frequency")) 
cell_tol2count_dist$tol2_count %<>% as.character %>% as.numeric
ggplot(cell_tol2count_dist) + geom_bar(stat="identity", aes(x=tol2_count, y=frequency))
