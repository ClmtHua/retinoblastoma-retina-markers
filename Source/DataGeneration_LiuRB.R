# GenerateData
library(Seurat)
library(tidyverse)

# Load data
## Data RBSC11
df_RBSC11_metadata <- read_tsv("data/RBSC11_metadata.tsv")
df_RBSC11 <- read_tsv("data/df_NormExp.tsv")

## Gene lists
# Load data
RetinalGenes_GMT <- read_tsv("data/RetinalGenesMarkers_TableS3.tsv")

RetinalGenes_GMT_legend <- RetinalGenes_GMT %>%
  ungroup()%>%
  group_by(gene) %>%
  summarise(annotations = str_c(ID, collapse = "/"))%>%
  mutate(Enhanced_Gene = str_c(gene, annotations, sep = " - ")) %>%
  mutate(category = "Retinal markers (Liu in revision)") %>%
  mutate(subcategory = annotations)

# Custom Genes selection 
df_AdditionalGenes <- read_csv("data/CitedGenes_Enhanced.csv")
l_AdditionalGenes <- unique(df_AdditionalGenes$gene)

# Get dataframe with the genes on interest 
l_GOI_retinal_markers <- intersect(df_RBSC11$gene, RetinalGenes_GMT$gene)
l_GOI_custom <- intersect(df_RBSC11$gene, l_AdditionalGenes)
l_GOI <- c(l_GOI_custom, l_GOI_retinal_markers)

df_RBSC11_Norm_MarkersLiu <- df_RBSC11 %>%
  filter(gene %in% l_GOI) %>%
  column_to_rownames("gene") %>%
  as.matrix() %>% t() %>%
  as.data.frame() %>%
  rownames_to_column("barcode")

save(df_RBSC11_Norm_MarkersLiu, df_RBSC11_metadata, file = "data/RequiredData_RBSC11.Rdata", version = 2)
