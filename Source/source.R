# Load initial files 
library(tidyverse)
library(reshape2)
library(cowplot)
source("ggarrange_custom.R", local = TRUE)
load(file = "data/RequiredData.Rdata")
theme_set(theme_gray())

df_Lu2020_metadata <- df_Lu2020_metadata %>%
  mutate(age = factor(age, levels = c("24_Day", "30_Day", "42_Day", "59_Day", "Hgw9", "Hgw11",  "Hgw12",  "Hgw13",  "Hgw14",  "Hgw15",  "Hgw16",  "Hgw17", "Hgw18",  "Hgw19",  "Hgw20",  "Hgw22",  "Hgw24",  "Hgw27", "Hpnd8", "Adult"))) %>%
  mutate(umap2_CellType = factor(umap2_CellType, 
                                 levels = c("RPCs", 
                                          "Neurogenic Cells", "Retinal Ganglion Cells", 
                                          "AC/HC_Precurs", "Amacrine Cells", "Horizontal Cells",
                                          "BC/Photo_Precurs", "Cones", "Rods", "Bipolar Cells", 
                                          "Muller Glia")))

SelectedGenes_legend <- filter(SelectedGenes_legend, !is.na(Enhanced_Gene))
SelectedGenes_legend_NoMerge <- filter(SelectedGenes_legend_NoMerge, !is.na(Enhanced_Gene))
# Function to plot UMAP according of a GOI
fn_FeaturePlot_Lu2020 <- function(GOI){
  p1 <- df_Lu2020_Norm_MarkersLiu %>%
    left_join(df_Lu2020_metadata, by = "barcode") %>%
    arrange(umap3_coord)%>%
    ggplot(aes(x = umap1_coord, y = umap2_coord))+
    geom_point(aes(color = get(GOI)), size = 0.05, alpha = 0.5)+
    scale_color_gradient(low = "white", high = "red")+
    labs(color= GOI)
  
  p2 <- df_Lu2020_Norm_MarkersLiu %>%
    left_join(df_Lu2020_metadata, by = "barcode") %>%
    arrange(umap2_coord)%>%
    ggplot(aes(x = umap1_coord, y = umap3_coord))+
    geom_point(aes(color = get(GOI)), size = 0.05, alpha = 0.5)+
    scale_color_gradient(low = "white", high = "red")+
    labs(color= GOI)
  
  p3 <- df_Lu2020_Norm_MarkersLiu %>%
    left_join(df_Lu2020_metadata, by = "barcode") %>%
    arrange(umap1_coord)%>%
    ggplot(aes(x = umap2_coord, y = umap3_coord))+
    geom_point(aes(color = get(GOI)), size = 0.05, alpha = 0.5)+
    scale_color_gradient(low = "white", high = "red")+
    labs(color= GOI)
  
  return(ggarrange(plotlist = list(p1, p2, p3), common.legend = T, ncol = 1))
}


# Cell type plot
p_clusters  <- lapply( c("umap2_CellType"), function(GOI){
  p1 <- df_Lu2020_Norm_MarkersLiu %>%
    left_join(df_Lu2020_metadata, by = "barcode") %>%
    arrange(umap3_coord)%>%
    ggplot(aes(x = umap1_coord, y = umap2_coord))+
    geom_point(aes(color = get(GOI)), size = 0.05, alpha = 0.8)+
    labs(color= "")+
    theme(legend.text = element_text(size = 10))+
    guides(colour = guide_legend(override.aes = list(size=2.5), ncol = 3))+
    scale_color_manual(values = c("#437540", "#eee820","#353283","#e2b9c9","#d59819","#767676","#913582","#95ba26","#741da8","#af1518","#2b2724"))
  
  
  p2 <- df_Lu2020_Norm_MarkersLiu %>%
    left_join(df_Lu2020_metadata, by = "barcode") %>%
    arrange(umap2_coord)%>%
    ggplot(aes(x = umap1_coord, y = umap3_coord))+
    geom_point(aes(color = get(GOI)), size = 0.05, alpha = 0.8)+
    labs(color= "")+
    theme(legend.text = element_text(size = 10))+
    guides(colour = guide_legend(override.aes = list(size=2.5), ncol = 3))+
    scale_color_manual(values = c("#437540", "#eee820","#353283","#e2b9c9","#d59819","#767676","#913582","#95ba26","#741da8","#af1518","#2b2724"))
  
  p3 <- df_Lu2020_Norm_MarkersLiu %>%
    left_join(df_Lu2020_metadata, by = "barcode") %>%
    arrange(umap1_coord)%>%
    ggplot(aes(x = umap2_coord, y = umap3_coord))+
    geom_point(aes(color = get(GOI)), size = 0.05, alpha = 0.8)+
    labs(color= "")+
    theme(legend.text = element_text(size = 10))+
    guides(colour = guide_legend(override.aes = list(size=2.5), ncol = 3))+
    scale_color_manual(values = c("#437540", "#eee820","#353283","#e2b9c9","#d59819","#767676","#913582","#95ba26","#741da8","#af1518","#2b2724"))
  
  #return( list(p1, p2, p3))
  return(ggarrange(plotlist = list(p1, p2, p3), common.legend = T, ncol = 1))
})

p_clusters_small  <- lapply( c("umap2_CellType"), function(GOI){
  p1 <- df_Lu2020_Norm_MarkersLiu %>%
    left_join(df_Lu2020_metadata, by = "barcode") %>%
    arrange(umap3_coord)%>%
    ggplot(aes(x = umap1_coord, y = umap2_coord))+
    geom_point(aes(color = get(GOI)), size = 0.05, alpha = 0.8)+
    labs(color= "")+
    theme(legend.text = element_text(size = 9))+
    guides(colour = guide_legend(override.aes = list(size=1.5), ncol = 2))+
    scale_color_manual(values = c("#437540", "#eee820","#353283","#e2b9c9","#d59819","#767676","#913582","#95ba26","#741da8","#af1518","#2b2724"))
  
  
  p2 <- df_Lu2020_Norm_MarkersLiu %>%
    left_join(df_Lu2020_metadata, by = "barcode") %>%
    arrange(umap2_coord)%>%
    ggplot(aes(x = umap1_coord, y = umap3_coord))+
    geom_point(aes(color = get(GOI)), size = 0.05, alpha = 0.8)+
    labs(color= "")+
    theme(legend.text = element_text(size = 9))+
    guides(colour = guide_legend(override.aes = list(size=1.5), ncol = 2))+
    scale_color_manual(values = c("#437540", "#eee820","#353283","#e2b9c9","#d59819","#767676","#913582","#95ba26","#741da8","#af1518","#2b2724"))
  
  p3 <- df_Lu2020_Norm_MarkersLiu %>%
    left_join(df_Lu2020_metadata, by = "barcode") %>%
    arrange(umap1_coord)%>%
    ggplot(aes(x = umap2_coord, y = umap3_coord))+
    geom_point(aes(color = get(GOI)), size = 0.05, alpha = 0.8)+
    labs(color= "")+
    theme(legend.text = element_text(size = 9))+
    guides(colour = guide_legend(override.aes = list(size=1.5), ncol = 2))+
    scale_color_manual(values = c("#437540", "#eee820","#353283","#e2b9c9","#d59819","#767676","#913582","#95ba26","#741da8","#af1518","#2b2724"))
  
  #return( list(p1, p2, p3))
  return(ggarrange(plotlist = list(p1, p2, p3), common.legend = T, ncol = 1))
})

# Function dotplot
fn_plot_GeneralDotPlot <- function(list_genes){
  df <- df_Lu2020_Norm_MarkersLiu %>%
    select(barcode, eval(list_genes)) %>%
    left_join(select(df_Lu2020_metadata, barcode, umap2_CellType), by = "barcode") %>%
    add_count(umap2_CellType, name = "TotalCellType")%>%
    select(barcode, umap2_CellType, TotalCellType, everything()) %>%
    melt(variable.name = "Gene", value.name = "NormExp", id.vars = c("barcode", "umap2_CellType", "TotalCellType"))%>%
    mutate(NormExp = as.numeric(NormExp))%>%
    group_by(umap2_CellType, Gene, TotalCellType) %>%
    summarise(Mean = mean(NormExp), count_expressing = sum(NormExp != 0)) %>%
    mutate(percent_expressing = 100*count_expressing/TotalCellType)
  
  p <- ggplot(df)+
    geom_point(aes(y = umap2_CellType, x = Gene, size = percent_expressing, color = Mean))+
    scale_color_gradient(low = "blue", high = "red")+
    labs(x = "Gene", y = "Cell Type", size = "Pct expressing")+
    theme(axis.text.x = element_text(size = 12, hjust = 1, vjust = 0.5, angle = 90), 
          axis.text.y = element_text(size = 12))
  
  return(p)
}

# Function get counting data + for AgeDitOkit
fn_data_Counting <- function(list_genes, l_groupingvars = c("umap2_CellType", "age")){
  df <- df_Lu2020_Norm_MarkersLiu %>%
    select(barcode, eval(list_genes)) %>%
    left_join(select(df_Lu2020_metadata, barcode, eval(l_groupingvars)), by = "barcode") %>%
    group_by_(.dots = l_groupingvars) %>%
    add_tally()%>%
    rename(TotalCells = n) %>%
    ungroup()%>%
    melt(variable.name = "Gene", value.name = "NormExp", id.vars = c("barcode", "TotalCells", l_groupingvars))%>%
    ungroup() %>%
    group_by_(.dots = c(l_groupingvars, "Gene", "TotalCells")) %>%
    summarise(Mean = mean(NormExp), count_expressing = sum(NormExp != 0)) %>%
    mutate(percent_expressing = 100*count_expressing/TotalCells) %>%
    arrange(Gene)
  
  return(df)
}

fn_agedotplot <- function(l_genes){
  df_count <- fn_data_Counting(list_genes = l_genes, l_groupingvars = c("umap2_CellType", "age"))
  df_blank <- fn_data_Counting(list_genes = l_genes, l_groupingvars = c("umap2_CellType", "age")) %>%
    ungroup()%>%
    group_by(Gene, umap2_CellType)%>%
    filter(Mean == max(Mean)) %>%
    ungroup() %>% group_by(Gene) %>%
    mutate(Mean = 1.1*max(Mean))%>%
    mutate(age = levels(age)[1]) %>%
    select(umap2_CellType, age, Gene, Mean) %>%
    distinct()
  
  p <- df_count %>%
    ggplot(aes(x = age, y = Mean, color = umap2_CellType))+
    geom_point(aes(size = percent_expressing))+
    geom_line(aes(group = umap2_CellType))+
    geom_text(data = df_blank, 
              mapping = aes(x = age, y = Mean, label = umap2_CellType), 
              size = 3.5, hjust = "left", color = "black")+
    facet_grid(Gene ~ umap2_CellType, scales = "free_y")+
    theme(axis.text.x = element_text(size = 8, angle = 90, hjust = 1, vjust = 0.5), 
          strip.text = element_text(size = 12))+
    guides(colour = FALSE)+
    labs(y = "Mean of Normalised Expression", x = "Age", size = "Pct expressing")+
    scale_size_continuous(breaks =  c(0, 25, 50, 75, 100), limits = c(0, 100))+
    scale_color_manual(values = c("#437540", "#eee820","#353283","#e2b9c9","#d59819","#767676","#913582","#95ba26","#741da8","#af1518","#2b2724"))
  
  return(p)
}