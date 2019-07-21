library(Seurat)
library(thymusatlastools2)
library(freezr)
library(magrittr)
library(Matrix)
atlas_inv_loc = "~/Dropbox/AtlasQuickRef/seurat_objects/"
View(inventory_show(atlas_inv_loc)[c(1, 5)]) # What's available
dge_tcell = "Tcell_nodub" %>% inventory_get(atlas_inv_loc) %>% readRDS %>% UpdateSeuratObject %>% MakeSparse
dge_tecs = "TECS_12_P0_bag_labeled" %>% inventory_get(atlas_inv_loc) %>% readRDS %>% UpdateSeuratObject %>% MakeSparse

custom_feature_plot(dge_tcell, "eday") + ggtitle("Hello, old friend!")
custom_feature_plot(dge_tecs, "eday")

test = list(cells = sample(dge_tcell@cell.names, 100))
train = list( cells = setdiff(dge_tcell@cell.names, ))