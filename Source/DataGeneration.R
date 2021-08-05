# GenerateData
library(Seurat)
library(tidyverse)

# Load data
#setwd("Source/")
RetinalGenes_GMT <- read_tsv("data/RetinalGenesMarkers_TableS3.tsv")

RetinalGenes_GMT_legend_NoMerge <- RetinalGenes_GMT %>%
  ungroup()%>%
  mutate(annotations = ID) %>%
  mutate(category = "Retinal markers (Liu in revision)") %>%
  mutate(subcategory = annotations) %>%
  group_by(gene) %>%
  mutate(annotations_merge = str_c(ID, collapse = "/")) %>%
  mutate(Enhanced_Gene = str_c(gene, annotations_merge, sep = " - ")) %>%
  select(- ID, - term)

RetinalGenes_GMT_legend <- RetinalGenes_GMT %>%
  ungroup()%>%
  group_by(gene) %>%
  summarise(annotations = str_c(ID, collapse = "/"))%>%
  mutate(Enhanced_Gene = str_c(gene, annotations, sep = " - ")) %>%
  mutate(category = "Retinal markers (Liu in revision)") %>%
  mutate(subcategory = annotations)

# Custom Genes selection 
df_AdditionalGenes <- read_csv("data/CitedGenes_Enhanced.csv")

CustomGenes_legend <- df_AdditionalGenes %>%
  ungroup()%>%
  group_by(gene, category) %>%
  summarise(annotations = str_c(subcategory, collapse = "/"))%>%
  mutate(Enhanced_Gene = str_c(gene, annotations, sep = " - "))%>%
  mutate(subcategory = annotations)

CustomGenes_legend_NoMerge <- df_AdditionalGenes %>%
  ungroup()%>%
  mutate(annotations = subcategory) %>%
  group_by(gene, category) %>%
  mutate(annotations_merge = str_c(annotations, collapse = "/")) %>%
  mutate(Enhanced_Gene = str_c(gene, annotations_merge, sep = " - "))

SelectedGenes_legend <- bind_rows(CustomGenes_legend, RetinalGenes_GMT_legend)
SelectedGenes_legend_NoMerge <- bind_rows(CustomGenes_legend_NoMerge, RetinalGenes_GMT_legend_NoMerge)

# Load Lu et al. data, 2020
GSE138002_exp_mat <- Matrix::readMM("data/GSE138002_Final_matrix.mtx.gz")
GSE138002_features <- read_csv2("data/GSE138002_genes.csv.gz")
GSE138002_barcodes <- read_csv2("data/GSE138002_Final_barcodes.csv.gz")

GSE138002_exp_mat <- as(GSE138002_exp_mat, "dgCMatrix")
rownames(GSE138002_exp_mat) <- GSE138002_features$gene_short_name
colnames(GSE138002_exp_mat) <- GSE138002_barcodes$barcode

# Normalisation through Seurat
df_metadata <- GSE138002_barcodes %>% 
  select(barcode, sample, age, sample_type, starts_with("umap")) %>%
  as.data.frame()
rownames(df_metadata) <- df_metadata$barcode

SO_Lu2020 <- CreateSeuratObject(counts = GSE138002_exp_mat, meta.data = df_metadata)
remove(GSE138002_exp_mat)
SO_Lu2020 <- NormalizeData(SO_Lu2020)
gc()


# Get dataframe with the genes on interest 
l_GOI_retinal_markers <- intersect(rownames(SO_Lu2020), RetinalGenes_GMT$gene)
l_GOI_custom <- intersect(rownames(SO_Lu2020), unique(SelectedGenes_legend$gene))
l_GOI <- c(l_GOI_custom, l_GOI_retinal_markers) %>% unique()


df_Lu2020_Norm_MarkersLiu  <- as.data.frame(SO_Lu2020@assays$RNA@data[l_GOI, ]) %>% 
  as.matrix() %>% t() %>%
  as.data.frame() %>% 
  rownames_to_column("barcode")

df_Lu2020_metadata <- GSE138002_barcodes
save(# RetinalGenes_GMT, CustomGenes_GMT, 
  l_GOI, SelectedGenes_legend, SelectedGenes_legend_NoMerge, df_Lu2020_Norm_MarkersLiu, df_Lu2020_metadata, file = "data/RequiredData.Rdata", version = 3)