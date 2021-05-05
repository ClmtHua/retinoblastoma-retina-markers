# Load initial files 
library(tidyverse)
library(reshape2)
#library(cowplot)
#load(file = "data/RequiredData.Rdata")
load(file = "data/RequiredData_RBSC11.Rdata")

# # Error message if there is genes that are not in the data
# fn_warningmessage <- function(list_genes){
#   all_genes_Lu <- names(df_Lu2020_Norm_MarkersLiu)[-1]
#   all_genes_Liu <- names(df_RBSC11_Norm_MarkersLiu)[-1]
#   setdiff_Liu <- setdiff(list_genes, all_genes_Liu)
#   setdiff_Lu <- setdiff(list_genes, all_genes_Lu)
#   test <- length(setdiff_Liu) != 0 | length(setdiff_Lu) != 0
#   warning_text_Liu <- ifelse(length(setdiff_Liu) != 0, 
#                              yes = str_c("These genes are not present in retinoblastoma RBSC11 data: ", str_c(setdiff_Liu, collapse = ", "), "."), 
#                              no = "")
#   warning_text_Lu <- ifelse(length(setdiff_Lu) != 0, 
#                             yes = str_c("These genes are not present in Lu data: ", str_c(setdiff_Lu, collapse = ", "), "."), 
#                             no = "")
#   warning_text_final <- str_c(warning_text_Lu, warning_text_Liu, sep = "\n")
#   
#   return(list(test = test,  warning_text_final = warning_text_final))
# }


# Pre loaded plot
df_RBSC11_label <- df_RBSC11_metadata %>%
  group_by(cluster) %>%
  summarise(tSNE_1 = mean(tSNE_1), tSNE_2 = mean(tSNE_2)) %>%
  left_join(tibble(cluster = c(0:6), 
                   name = c("CRX+/EBF3+/GAP43+", "CRX+/ARR3+", "Prolif.\nCRX+/EBF3+/GAP43+", "Hypoxia", "Prolif.\nCRX+/ARR3+", "Monocyte\nMicroglia", "T-cells"), 
                   label = c("0.\nCRX+/EBF3+/GAP43+", "1. CRX+/ARR3+", "2. Prolif.\nCRX+/EBF3+/GAP43+", "3. Hypoxia", "4. Prolif.\nCRX+/ARR3+", "5\nMonocyte\nMicroglia", "6. T-cells"), 
                   label_small = c("0.\nCRX+/EBF3+/GAP43+", "1.\nCRX+/ARR3+", "2. Prolif.\nCRX+/EBF3+/GAP43+", "3.\nHypoxia", "4. Prolif.\nCRX+/ARR3+", "5\nMonocyte\nMicroglia", "6.\nT-cells")
                   ), by = "cluster") %>%
  mutate(cluster = factor(cluster, levels = c(0, 2, 1, 4, 3, 5, 6)))

p_clusters_RBSC11 <- df_RBSC11_Norm_MarkersLiu %>%
  left_join(df_RBSC11_metadata, by = "barcode") %>%
  mutate(cluster = factor(cluster, levels = c(0, 2, 1, 4, 3, 5, 6)))%>%
  ggplot(aes(x = tSNE_1, y = tSNE_2))+
  geom_point(aes(color = factor(cluster)), size = 0.6, alpha = 0.9)+
  geom_label(data = df_RBSC11_label, mapping = aes(label = label, fill = factor(cluster)), 
             alpha = 0.4, size = 4.5)+
  theme(legend.position = "None", 
        axis.text = element_text(size = 11), axis.title = element_text(size = 12))+
  coord_fixed()+
  theme(plot.margin = unit(c(5, 5, 5, 5), "pt"))


p_clusters_RBSC11_small <- df_RBSC11_Norm_MarkersLiu %>%
  left_join(df_RBSC11_metadata, by = "barcode") %>%
  mutate(cluster = factor(cluster, levels = c(0, 2, 1, 4, 3, 5, 6)))%>%
  ggplot(aes(x = tSNE_1, y = tSNE_2))+
  geom_point(aes(color = factor(cluster)), size = 0.6, alpha = 0.9)+
  geom_label(data = df_RBSC11_label, mapping = aes(label = label_small, fill = factor(cluster)), 
             alpha = 0.4, size = 4)+
  theme(legend.position = "None", 
        axis.text = element_text(size = 11), axis.title = element_text(size = 12))+
  coord_fixed()+
  theme(plot.margin = unit(c(5, 5, 5, 5), "pt"))


rm(df_RBSC11_label)


# Function for Feature plots
fn_FeaturePlot_RBSC11 <- function(GOI){
  p <- df_RBSC11_Norm_MarkersLiu %>%
    left_join(df_RBSC11_metadata, by = "barcode") %>%
    mutate(cluster = factor(cluster, levels = c(0, 2, 1, 4, 3, 5, 6)))%>%
    ggplot(aes(x = tSNE_1, y = tSNE_2))+
    geom_point(aes(color = get(GOI)), size = 0.6, alpha = 0.9)+
    scale_color_gradient(low = "white", high = "red")+
    theme(axis.text = element_text(size = 11), axis.title = element_text(size = 12),
          legend.text = element_text(size = 11), legend.title = element_text(size = 11),
          legend.key.size = unit(12, units = "pt"), strip.text = element_text(size = 12)
          )+
    labs(color= GOI)+
    coord_fixed()+
    theme(plot.margin = unit(c(5, 5, 5, 5), "pt"))
  
  return(p)
}

#  Function for plotting
df_RBSC11_MarkersLiu_melt <- df_RBSC11_Norm_MarkersLiu %>%
  left_join(select(df_RBSC11_metadata, barcode, cluster), by = "barcode") %>%
  add_count(cluster, name = "TotalCellType")%>%
  select(barcode, cluster, TotalCellType, everything()) %>%
  melt(variable.name = "Gene", value.name = "NormExp", id.vars = c("barcode", "cluster", "TotalCellType")) %>%
  mutate(NormExp = as.numeric(NormExp))

fn_DotPlot_RBSC11 <- function(list_genes){
  df_RBSC11_MarkersLiu_joined_ForDotPlot <- df_RBSC11_MarkersLiu_melt %>%
    filter(Gene %in% list_genes) %>%
    mutate(cluster = factor(cluster, levels = c(0, 2, 1, 4, 3, 5, 6)))%>%
    group_by(cluster, Gene, TotalCellType) %>%
    summarise(Mean = mean(NormExp), count_expressing = sum(NormExp != 0)) %>%
    mutate(percent_expressing = 100*count_expressing/TotalCellType)
  
  df_RBSC11_forplot <- filter(df_RBSC11_MarkersLiu_melt, Gene %in% list_genes) %>%
    mutate(cluster = factor(cluster, levels = c(0, 2, 1, 4, 3, 5, 6)))
  
  plot <- ggplot(mapping = aes(x = factor(cluster), group = cluster))+
    geom_jitter(data = df_RBSC11_forplot, mapping = aes(y = NormExp), size = 0.2)+
    geom_violin(data = df_RBSC11_forplot, mapping = aes(y = NormExp, color = factor(cluster)), 
                outlier.size = 0.5, alpha = 0)+
    geom_point(data = filter(df_RBSC11_MarkersLiu_joined_ForDotPlot, Gene %in% list_genes), 
               mapping = aes(y = Mean, size = percent_expressing, color = factor(cluster)), alpha = 0.8)+
    facet_grid(Gene ~ "Retinoblastoma", scales = "free_y")+
    theme(axis.text = element_text(size = 11), axis.title = element_text(size = 12),
          legend.text = element_text(size = 11), legend.title = element_text(size = 11),
          legend.key.size = unit(12, units = "pt"), strip.text = element_text(size = 12))+
    guides(colour = FALSE)+
    labs(y = "Normalised Expression", x = "Cluster", size = "Pct expressing")
  
  return(plot)
}



