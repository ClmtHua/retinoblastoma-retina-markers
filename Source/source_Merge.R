all_genes_Lu <- names(df_Lu2020_Norm_MarkersLiu)[-1]
all_genes_Liu <- names(df_RBSC11_Norm_MarkersLiu)[-1]


umap2_CellType_Order <-  c("RPCs", "Neurogenic Cells", "Retinal Ganglion Cells", 
                           "AC/HC_Precurs", "Amacrine Cells", "Horizontal Cells",
                           "BC/Photo_Precurs", "Cones", "Rods", "Bipolar Cells", 
                           "Muller Glia")
simple_annot_age <- setNames(LETTERS[1:20], c("24_Day", "30_Day", "42_Day", "59_Day", "Hgw9", "Hgw11",  "Hgw12",  "Hgw13",  "Hgw14",  "Hgw15",  "Hgw16",  "Hgw17", "Hgw18",  "Hgw19",  "Hgw20",  "Hgw22",  "Hgw24",  "Hgw27", "Hpnd8", "Adult"))
age_order <- c("24_Day", "30_Day", "42_Day", "59_Day", "Hgw9", "Hgw11",  "Hgw12",  "Hgw13",  "Hgw14",  "Hgw15",  "Hgw16",  "Hgw17", "Hgw18",  "Hgw19",  "Hgw20",  "Hgw22",  "Hgw24",  "Hgw27", "Hpnd8", "Adult")

fn_DotPlot_RBSC11_ForComparison <- function(list_genes){
  df_RBSC11_MarkersLiu_joined_ForDotPlot <- df_RBSC11_MarkersLiu_melt %>%
    filter(Gene %in% list_genes) %>%
    group_by(cluster, Gene, TotalCellType) %>%
    summarise(Mean = mean(NormExp), count_expressing = sum(NormExp != 0)) %>%
    mutate(percent_expressing = 100*count_expressing/TotalCellType)
  
  absent_genes <- setdiff(list_genes, all_genes_Liu)
  df_absent <- lapply(absent_genes, function(i){
    df <- tibble(cluster = c(0:6), Gene = i, 
                 TotalCellType = 0, Mean = 0, count_expressing = 0, percent_expressing = 0)
    return(df)
  }) %>% bind_rows()
  
  df_res <- bind_rows(df_RBSC11_MarkersLiu_joined_ForDotPlot, df_absent)
  return(df_res)
}

fn_DotPlot_Merge <- function(l_genes){
  # Prepare data
  df_Lu <- fn_data_Counting(list_genes = l_genes, l_groupingvars = c("umap2_CellType", "age"))
  
  df_Liu <- fn_DotPlot_RBSC11_ForComparison(l_genes) %>%
    mutate(cluster = factor(cluster, levels = c(0, 2, 1, 4, 3, 5, 6)))%>%
    mutate(age = cluster, umap2_CellType = "Retinoblastoma")%>%
    mutate(Gene = factor(Gene, levels = levels(df_Lu$Gene)))%>%
    rename(TotalCells = TotalCellType) %>%
    ungroup()%>%
    select(- cluster)
  
  # Blank for same limits
  df_blank <- df_Lu %>%
    mutate(umap2_CellType = factor(umap2_CellType, 
                                   levels = umap2_CellType_Order))%>%
    bind_rows(df_Liu) %>%
    ungroup()%>%
    group_by(Gene) %>%
    filter(Mean == max(Mean)) %>%
    mutate(Mean = ceiling(Mean*2)/2)%>%
    select(- age, -umap2_CellType)
  
  df_blank_toplot <- df_Lu %>%
    mutate(age = factor(x = age, levels = age_order))%>%
    bind_rows(df_Liu)  %>%
    select(age, umap2_CellType, Gene) %>%
    distinct()%>%
    ungroup() %>%
    left_join(df_blank, by = "Gene")%>%
    mutate(umap2_CellType = factor(umap2_CellType, levels = c(umap2_CellType_Order, "Retinoblastoma")))
  
  # Get plot
  p_Liu <- ggplot(data = df_Liu, mapping = aes(x = age, y = Mean))+
    geom_line(data = df_Liu, mapping = aes(group = umap2_CellType))+
    geom_point(data = df_Liu, mapping = aes(size = percent_expressing, 
                                            color = age))+
    geom_blank(data = filter(df_blank_toplot, umap2_CellType == "Retinoblastoma"), 
               mapping = aes(x = age, y = Mean))+
    facet_grid(Gene ~ umap2_CellType, scales = "free_y")+
    guides(colour = guide_legend(override.aes = list(size=2)))+
    labs(y = "Mean of Normalised Expression", x = "Cluster")+
    scale_size_continuous(breaks =  c(0, 25, 50, 75, 100), limits = c(0, 100))
  
  df_Lu_toplot <- df_Lu %>% 
    mutate(umap2_CellType = factor(umap2_CellType, levels = umap2_CellType_Order))%>%
    mutate(age = factor(x = age, levels = age_order))%>%
    arrange(umap2_CellType)
  
  p_Lu <- ggplot(mapping = aes(x = age, y = Mean))+
    geom_line(data = df_Lu_toplot, mapping = aes(group = umap2_CellType, color = umap2_CellType))+
    geom_point(data = df_Lu_toplot, mapping =aes(size = percent_expressing, 
                                                 color = umap2_CellType))+
    geom_blank(data =filter(df_blank_toplot, umap2_CellType != "Retinoblastoma"), 
               mapping = aes(x = age, y = Mean))+
    geom_text(data =filter(df_blank_toplot, umap2_CellType != "Retinoblastoma") %>% select(- age) %>% distinct() %>% mutate(age = "24_Day"), 
              mapping = aes(x = age, y = 0.95*Mean, label = umap2_CellType), 
              size = 3.5, hjust = "left")+
    facet_grid(Gene ~ umap2_CellType, scales = "free_y")+
    guides(colour = guide_legend(override.aes = list(size=2)))+
    labs(y = "Mean of Normalised Expression", x = "Age")+
    scale_size_continuous(breaks =  c(0, 25, 50, 75, 100), limits = c(0, 100))+
    theme(axis.text.x = element_text(color =c(rep("#1d4e89", 4), rep("#065143", 14), "#f79256", "#5d2e46")))+
    scale_color_manual(values = c("#437540", "#eee820","#353283","#e2b9c9","#d59819","#767676","#913582","#95ba26","#741da8","#af1518","#2b2724"))

  # 
  plot_merge <- cowplot::plot_grid(plotlist = list(p_Lu + 
                                       theme(legend.position = "None",  
                                             strip.text = element_text(size = 12),
                                              axis.text.x = element_text(size = 8, angle = 90, 
                                                                         hjust = 1, vjust = 0.5))+ 
                                       expand_limits(y = 0)+ 
                                       scale_y_continuous( breaks = scales::breaks_width(width = 0.5)), 
                                     
                                    p_Liu + 
                                      theme(legend.position = "None", 
                                            strip.text = element_text(size = 12),
                                            axis.title.y = element_blank(), 
                                            axis.text.x = element_text(size = 8, angle = 90, 
                                                                       hjust = 1, vjust = 0.5))+ #size = 9, angle = 0))+ 
                                      expand_limits(y = 0)+ 
                                      scale_y_continuous(breaks = scales::breaks_width(width = 0.5))+
                                      scale_x_discrete(breaks = c(0, 2, 1, 4, 3, 5, 6), 
                                                       labels = str_c("Clust.", c(0, 2, 1, 4, 3, 5, 6), sep = ""))
                                    ), 
                     ncol = 2, rel_widths = c(11, 1))
  
  legend <- get_legend(p_Liu + 
                         theme(legend.position = "top", legend.text = element_text(size = 11), legend.title = element_text(size = 11), plot.margin = unit(c(0, 0, 0, 0), "cm"))+
                         scale_color_manual(name = "Retinoblastoma clusters", 
                                            labels = c("0. CRX+/EBF3+/GAP43+", 
                                                       "2. Prolif. CRX+/EBF3+/GAP43+",
                                                       "1. CRX+/ARR3+",
                                                       "4. Prolif. CRX+/ARR3+",
                                                       "3. Hypoxia",
                                                       "5 Monocyte Microglia", 
                                                       "6. T-cells"
                                            ), 
                                            breaks = c(0, 2, 1, 4, 3, 5, 6), 
                                            values = c("#F8766D", "#C49A00", "#53B400", "#00C094", "#00B6EB",  "#A58AFF", "#FB61D7")
                                            )+
                         guides(colour = guide_legend(title = "Retinoblastoma\nclusters", order = 2, nrow = 2, keyheight = 0.9, keywidth = 0.9, override.aes = list(size = 3)), 
                                size = guide_legend(order = 1))+
                         labs(size = "Pct expressing"))
  
  # legend_text <- cowplot::plot_grid(plotlist =  list( 
  #   ggdraw()+ 
  #     draw_text("Age\n", color = "black",size = 11)+
  #     draw_text("(x-axis)", size = 9,  color = "black")+ theme(plot.margin = unit(c(0, 0, 0, 0), "cm")),
  #   
  #   ggdraw()+ 
  #     draw_text("Organoid\n", color = "#1d4e89", size = 11)+
  #     draw_text(str_c(levels(df_Lu2020_metadata$age)[1:4], collapse = ", "), size = 9,  color = "#1d4e89")+ theme(plot.margin = unit(c(0, 0, 0, 0), "cm")),   
  #   
  #   ggdraw()+ 
  #     draw_text("Human fetal retina\n", color = "#065143",size = 11)+
  #     draw_text(str_c("Hgw: ", str_c(str_remove_all(levels(df_Lu2020_metadata$age)[5:6], "Hgw"), collapse = ", "), " ... ", 
  #                     str_c(str_remove_all(levels(df_Lu2020_metadata$age)[17:18], "Hgw"), collapse = ", ")), size = 9,  color = "#065143")+ theme(plot.margin = unit(c(0, 0, 0, 0), "cm")),  
  #   
  #   ggdraw()+ 
  #     draw_text("Post-natal retina\n", color = "#f79256", size = 11)+
  #     draw_text(str_c(levels(df_Lu2020_metadata$age)[19], collapse = ", "), size = 9,  color = "#f79256")+ theme(plot.margin = unit(c(0, 0, 0, 0), "cm")), 
  #   
  #   ggdraw()+ 
  #     draw_text("Adult\n", color = "#5d2e46", size = 11)+
  #     draw_text(str_c(levels(df_Lu2020_metadata$age)[20], collapse = ", "), size = 9,  color = "#5d2e46")+ theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))
  # ), 
  # nrow = 1, rel_widths = c(9, 44, 30, 25, 10))
  
  legend_text <- cowplot::plot_grid(plotlist =  list( 
    ggdraw()+ 
      draw_text("Age\n", color = "black",size = 12)+
      draw_text("\n(x-axis)", size = 10,  color = "black")+ theme(plot.margin = unit(c(0, 0, 0, 0), "cm")),
    
    ggdraw()+ 
      draw_text("Organoid (days)\n", color = "#1d4e89", size = 12)+
      draw_text(str_c("\n", str_c(levels(df_Lu2020_metadata$age)[1:4] %>% str_remove("_Day"), collapse = ", ")), size = 10,  color = "#1d4e89")+ theme(plot.margin = unit(c(0, 0, 0, 0), "cm")),   
    
    ggdraw()+ 
      draw_text("Fetal retina (weeks [Hgw])\n", color = "#065143",size = 12)+
      draw_text(str_c("\n", str_c(str_remove_all(levels(df_Lu2020_metadata$age)[5:11], "Hgw"), collapse = ", ")), size = 9,  color = "#065143")+ 
      draw_text(str_c("\n\n\n", str_c(str_remove_all(levels(df_Lu2020_metadata$age)[12:18], "Hgw"), collapse = ", ")), size = 9,  color = "#065143")+ theme(plot.margin = unit(c(0, 0, 0, 0), "cm")),  
    
    ggdraw()+ 
      draw_text("Post-natal retina (days)\n", color = "#f79256", size = 12)+
      draw_text(str_c("\n", str_c(levels(df_Lu2020_metadata$age)[19], collapse = ", ")), size = 10,  color = "#f79256")+ theme(plot.margin = unit(c(0, 0, 0, 0), "cm")), 
    
    ggdraw()+ 
      draw_text("Adult (years)\n", color = "#5d2e46", size = 12)+
      draw_text("\n86 yo", size = 10,  color = "#5d2e46")+ 
      theme(plot.margin = unit(c(0, 0, 0, 0), "cm"))
  ), 
  nrow = 1, rel_widths = c(9, 25, 28, 30, 15))
  
  ext_legend <- cowplot::plot_grid(plotlist = list( legend_text+theme(plot.margin = unit(c(0, 2, 0, 3), "cm")), legend ), nrow = 1, rel_widths = c(19, 30), greedy = F)
  
  num_genes <- length(l_genes)
  
  plot_merge_legend <- cowplot::plot_grid(plotlist = list( ext_legend, plot_merge), ncol = 1,
                                          rel_heights = c(50/(num_genes*144  + 50), 
                                                          num_genes*144/(num_genes*144 + 50)))  

  return(plot_merge_legend)
}
