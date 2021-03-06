# response to reviewer
suppressMessages(require(Seurat))
suppressMessages(require(ggplot2))
suppressMessages(require(cowplot))
suppressMessages(require(scater))
suppressMessages(require(scran))
suppressMessages(require(BiocParallel))
suppressMessages(require(BiocNeighbors))
library(data.table)
setwd("~/covid19/result01/singlecell_data")

hms_individual_integrated<-readRDS(file="hms_individual_integrated_OK.rds")
p1 <- DimPlot(hms_individual_integrated, reduction = "umap", group.by = "celltype")
p1
hms_individual_integrated<- FindNeighbors(hms_individual_integrated, dims = 1:10)
hms_individual_integrated <- FindClusters( hms_individual_integrated, resolution = 0.5)
pbmc <- RunTSNE(object = hms_individual_integrated)
DimPlot(object = pbmc, reduction = "tsne")
new.cluster.ids <- c("Macrophage", "Macrophage", "Macrophage", "Macrophage", "Neutrophils", "Macrophage", "Naive CD4+ T", "NK", "Neutrophils", "Dendritic", "T", "T","Basal","Plasma","T") 
names(new.cluster.ids) <- levels(pbmc)

hms_tsne <- RenameIdents(pbmc, new.cluster.ids)
DimPlot(hms_tsne, reduction = "tsne", label = TRUE, pt.size = 0.5,label.size = 6)

saveRDS(hms_tsne, file = "hms_tsne.rds")

hms_tsne<-readRDS(file="hms_tsne.rds")

Macrophage<-subset(hms_tsne, idents=c('Macrophage'))
DimPlot(Macrophage, reduction = "tsne")
saveRDS(Macrophage, file="Macrophage_tsne.rds")

Neutrophils<-subset(hms_tsne, idents=c('Neutrophils'))
DimPlot(Neutrophils, reduction = "tsne")
saveRDS(Neutrophils, file="Neutrophils_tsne.rds")

Naive_CD4_T<-subset(hms_tsne, idents=c('Naive CD4+ T'))
DimPlot(Naive_CD4_T, reduction = "tsne")
saveRDS(Naive_CD4_T, file="Naive_CD4_T_tsne.rds")

NK<-subset(hms_tsne, idents=c('NK'))
DimPlot(NK, reduction = "tsne")
saveRDS(NK, file="NK_tsne.rds")

Dendritic<-subset(hms_tsne, idents=c('Dendritic'))
DimPlot(Dendritic, reduction = "tsne")
saveRDS(Dendritic, file="Dendritic_tsne.rds")

Basal<-subset(hms_tsne, idents=c('Basal'))
DimPlot(Basal, reduction = "tsne")
saveRDS(Basal, file="Basal_tsne.rds")

T<-subset(hms_tsne, idents=c('T'))
DimPlot(T, reduction = "tsne")
saveRDS(T, file="T_tsne.rds")

Plasma<-subset(hms_tsne, idents=c('Plasma'))
DimPlot(Plasma, reduction = "tsne")
saveRDS(Plasma, file="Plasma_tsne.rds")

DimPlot(Neutrophils, reduction = "tsne", split.by = "tech")
DimPlot(Basal, reduction = "tsne", split.by = "tech")
DimPlot(Dendritic, reduction = "tsne", split.by = "tech")
DimPlot(Macrophage, reduction = "tsne", split.by = "tech")
DimPlot(Naive_CD4_T, reduction = "tsne", split.by = "tech")
DimPlot(NK, reduction = "tsne", split.by = "tech")
DimPlot(Plasma, reduction = "tsne", split.by = "tech")
DimPlot(T, reduction = "tsne", split.by = "tech")
