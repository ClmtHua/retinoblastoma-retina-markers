# Function
fn_CoExp_GetData <- function(l_GOI, all_combi = TRUE, df_data =  df_Lu2020_Norm_MarkersLiu){
  df_temp <- df_data %>%
    select(barcode, eval(l_GOI))%>%
    group_by(barcode)%>%
    mutate_all(function(x) 1*(x != 0)) %>%
    melt(value.name = "IsExpressed", variable.name = "gene") %>%
    mutate(IsExpressed = ifelse(IsExpressed == 0, yes = "-", no = "+"))%>%
    group_by(barcode)%>%
    summarise(CoExpression = str_c(str_c(gene, IsExpressed), collapse = "/"))
  
  if(all_combi){
    return(df_temp)
  }
  else{
    AllPos <- str_c(str_c(l_GOI, collapse = "+/"), "+", sep = "")
    df_coexpressed <- df_temp%>%
      mutate(CoExpression = ifelse(CoExpression == AllPos, 
                                   yes = AllPos, 
                                   no = "Not all expressed"))
    levels = c(str_subset(unique(df_coexpressed$CoExpression), "Not all expressed", negate = TRUE), "Not all expressed")
    df_coexpressed <- df_coexpressed %>% 
      mutate(CoExpression = factor(CoExpression, levels = levels))
    return(df_coexpressed)
  }
}

fn_CoExp_TableRes <- function(df_coexpressed, l_groupingvars = c("umap2_CellType", "age"), df_metadata = df_Lu2020_metadata){
  df_Res <- df_coexpressed %>%
    left_join(df_metadata, by = "barcode")  %>%
    group_by_(.dots = l_groupingvars) %>%
    add_tally()%>%
    rename(TotalCells = n)%>%
    group_by_(.dots = c(l_groupingvars, "TotalCells"))%>%
    count(CoExpression) %>%
    mutate(Proportion = round(n/TotalCells, digits = 4))
  
  return(df_Res)
}

fn_CoExp_PlotBar <- function(df_coexpressed, l_GOI, df_metadata =  df_Lu2020_metadata){
  df_label <- fn_CoExp_TableRes(df_coexpressed, l_groupingvars = c("umap2_CellType", "age")) %>%
    ungroup()%>%
    filter(str_count(CoExpression, "\\+") == length(l_GOI))%>%
    mutate(label = str_c(n, "/", TotalCells, " (", 100*Proportion, "%)"))%>%
    mutate(age = factor(age, levels = c("24_Day", "30_Day", "42_Day", "59_Day", "Hgw9", "Hgw11",  "Hgw12",  "Hgw13",  "Hgw14",  "Hgw15",  "Hgw16",  "Hgw17", "Hgw18",  "Hgw19",  "Hgw20",  "Hgw22",  "Hgw24",  "Hgw27", "Hpnd8", "Adult")))
  
  
  p <- df_coexpressed %>%
    left_join(df_metadata, by = "barcode") %>%
    mutate(age = factor(age, levels = c("24_Day", "30_Day", "42_Day", "59_Day", "Hgw9", "Hgw11",  "Hgw12",  "Hgw13",  "Hgw14",  "Hgw15",  "Hgw16",  "Hgw17", "Hgw18",  "Hgw19",  "Hgw20",  "Hgw22",  "Hgw24",  "Hgw27", "Hpnd8", "Adult"))) %>% 
    ggplot()+
    geom_bar(aes(x = age, fill = CoExpression), position = "fill")+
    geom_text(data = df_label, mapping = aes(label = label, x = age), y = 0.5, size = 4)+
    coord_flip()+
    facet_wrap(~ umap2_CellType, nrow = 2) + 
    theme(axis.text = element_text(size = 11), axis.title = element_text(size = 12),
          legend.text = element_text(size = 11), legend.title = element_text(size = 11),
          legend.position = "bottom", legend.key.size = unit(12, units = "pt"), 
          strip.text = element_text(size = 12))+
    labs(x = "Age", y = "Proportion", fill = str_c("Co-Expression\n(", str_remove_all(df_label$CoExpression[1], "[\\+\\-]"), ")"))
  
  if(length(unique(df_coexpressed$CoExpression)) == 2){
      p <- p + scale_fill_manual(values = c("red", "grey"))
    }
  
  return(p)
}

fn_CoExp_FeaturePlot <- function(df_coexpressed, l_GOI, df_metadata =  df_Lu2020_metadata){
  df_label <- fn_CoExp_TableRes(df_coexpressed, l_groupingvars = c("umap2_CellType", "age")) %>%
    ungroup()%>%
    filter(str_count(CoExpression, "\\+") == length(l_GOI))%>%
    mutate(label = str_c(n, "/", TotalCells, " (", 100*Proportion, "%)"))%>%
    mutate(age = factor(age, levels = c("24_Day", "30_Day", "42_Day", "59_Day", "Hgw9", "Hgw11",  "Hgw12",  "Hgw13",  "Hgw14",  "Hgw15",  "Hgw16",  "Hgw17", "Hgw18",  "Hgw19",  "Hgw20",  "Hgw22",  "Hgw24",  "Hgw27", "Hpnd8", "Adult")))
  
  p1 <- df_coexpressed %>%
    left_join(df_metadata, by = "barcode") %>%
    arrange(umap3_coord)%>%
    ggplot(aes(x = umap1_coord, y = umap2_coord))+
    geom_point(aes(color = CoExpression), size = 0.05, alpha = 0.5)+
    labs(color= str_c(l_GOI, collapse = "/"))+ 
    theme(axis.text = element_text(size = 6), axis.title = element_text(size = 8),
          legend.text = element_text(size = 8), legend.title = element_text(size = 8),
          legend.position = "bottom", legend.key.size = unit(12, units = "pt"), 
          strip.text = element_text(size = 8))+
    labs(color = str_c("Co-Expression\n(", str_remove_all(df_label$CoExpression[1], "[\\+\\-]"), ")"))+
    guides(colour = guide_legend(override.aes = list(size=2, alpha = 1), ncol = 2))
  
  
  p2 <- df_coexpressed %>%
    left_join(df_metadata, by = "barcode") %>%
    arrange(umap2_coord)%>%
    ggplot(aes(x = umap1_coord, y = umap3_coord))+
    geom_point(aes(color = CoExpression), size = 0.05, alpha = 0.5)+
    labs(color= str_c(l_GOI, collapse = "/"))+ 
    theme(axis.text = element_text(size = 6), axis.title = element_text(size = 8),
          legend.text = element_text(size = 8), legend.title = element_text(size = 8),
          legend.position = "bottom", legend.key.size = unit(8, units = "pt"), 
          strip.text = element_text(size = 8))+
    labs(color = str_c("Co-Expression\n(", str_remove_all(df_label$CoExpression[1], "[\\+\\-]"), ")"))+
    guides(colour = guide_legend(override.aes = list(size=2, alpha = 1), ncol = 2))
  
  
  p3 <- df_coexpressed %>%
    left_join(df_metadata, by = "barcode") %>%
    arrange(umap1_coord)%>%
    ggplot(aes(x = umap2_coord, y = umap3_coord))+
    geom_point(aes(color = CoExpression), size = 0.05, alpha = 0.5)+
    labs(color= str_c(l_GOI, collapse = "/"))+ 
    theme(axis.text = element_text(size = 6), axis.title = element_text(size = 8),
          legend.text = element_text(size = 8), legend.title = element_text(size = 8),
          legend.position = "bottom", legend.key.size = unit(8, units = "pt"), 
          strip.text = element_text(size = 8))+
    labs(color = str_c("Co-Expression\n(", str_remove_all(df_label$CoExpression[1], "[\\+\\-]"), ")"))+
    guides(colour = guide_legend(override.aes = list(size=2, alpha = 1), ncol = 2))
  
  l_plots <-   list(p1, p2, p3)
  if(length(unique(df_coexpressed$CoExpression)) == 2){
    l_plots <- lapply(l_plots, function(p){
      return(p + scale_color_manual(values = c("red", "grey")))
    })}
  
  return(ggarrange(plotlist = l_plots, common.legend = T, ncol = 1))
}


###########
#   Liu   #
###########
fn_CoExp_PlotBar_Liu <- function(df_coexpressed, l_GOI, df_metadata = df_RBSC11_metadata){
  df_label <- fn_CoExp_TableRes(df_coexpressed, 
                                l_groupingvars = c("cluster"), 
                                df_metadata = df_metadata) %>%
    ungroup()%>%
    filter(str_count(CoExpression, "\\+") == length(l_GOI))%>%
    mutate(label = str_c(n, "/", TotalCells, " (", 100*Proportion, "%)"))
  
  p <- df_coexpressed %>%
    left_join(df_metadata, by = "barcode") %>%
    ggplot()+
    geom_bar(aes(x = factor(cluster), fill = CoExpression), position = "fill")+
    geom_text(data = df_label, mapping = aes(label = label, x = factor(cluster)), y = 0.5, size = 8)+
    coord_flip()+
  theme(axis.text = element_text(size = 12), axis.title = element_text(size = 12),
        legend.text = element_text(size = 12), legend.title = element_text(size = 12),
        legend.position = "bottom", legend.key.size = unit(12, units = "pt"), 
    )+
    labs(x = "Cluster", y = "Proportion", fill = str_c("Co-Expression\n(", str_remove_all(df_label$CoExpression[1], "[\\+\\-]"), ")"))
  
  if(length(unique(df_coexpressed$CoExpression)) == 2){
    p <- p + scale_fill_manual(values = c("red", "grey"))
  }
  
  legend <- get_legend(p + 
                         theme(legend.position = "right")+
                         guides(colour = guide_legend(override.aes = list(size=2, alpha = 1))))
  
  p_final <- cowplot::plot_grid(plotlist = list(p+theme(legend.position = "None"),  legend),
                                rel_heights = c(1, 0.4))
  
  return(p_final)
}

fn_CoExp_FeaturePlot_Liu <- function(df_coexpressed, l_GOI, df_metadata = df_RBSC11_metadata){
  df_label <- fn_CoExp_TableRes(df_coexpressed, 
                                l_groupingvars = c("cluster"), 
                                df_metadata = df_metadata) %>%
    ungroup()%>%
    filter(str_count(CoExpression, "\\+") == length(l_GOI))%>%
    mutate(label = str_c(n, "/", TotalCells, " (", 100*Proportion, "%)"))
  
  p1 <- df_coexpressed %>%
    left_join(df_metadata, by = "barcode") %>%
    arrange(desc(CoExpression)) %>%
    ggplot(aes(x = tSNE_1, y = tSNE_2))+
    geom_point(aes(color = CoExpression), size = 1, alpha = 0.9)+
    labs(color= str_c(l_GOI, collapse = "/"))+ 
    theme(axis.text = element_text(size = 12), axis.title = element_text(size = 12),
          legend.text = element_text(size = 12), legend.title = element_text(size = 12),
          legend.key.size = unit(12, units = "pt"), plot.margin = unit(c(5, 5, 5, 5), "pt"))+
    labs(color = str_c("Co-Expression\n(", str_remove_all(df_label$CoExpression[1], "[\\+\\-]"), ")"))+
    coord_fixed()
  
  if(length(unique(df_coexpressed$CoExpression)) == 2){
    p1  <- p1 + scale_color_manual(values = c("red", "grey"))
  }
  
  legend <- get_legend(p1 + 
                         guides(colour = guide_legend(override.aes = list(size=2, alpha = 1))))
  
  p_final <- cowplot::plot_grid(plotlist = list(p1+theme(legend.position = "None"),  legend), nrow = 1,
                                rel_heights = c(1, 0.5))
  
  return(p_final)
}

