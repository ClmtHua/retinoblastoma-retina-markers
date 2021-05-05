# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    # Control sidebar
    output$sidebarControls <-  renderMenu({ sidebarMenu(infoMenu) })
    
    observeEvent(input$GoTo_Info, {
        updateTabItems(session, "tabs", "start")
        output$sidebarControls <- renderMenu({ sidebarMenu(infoMenu) })
    })
    
    observeEvent(input$GoTo_Exp, {
        updateTabItems(session, "tabs", "HowTo_Part1")
        output$sidebarControls <- renderMenu({ sidebarMenu(plotMenu) })
    })
    
    observeEvent(input$GoTo_CoExp, {
        updateTabItems(session, "tabs", "HowTo_Part2")
        output$sidebarControls <- renderMenu({ sidebarMenu(coexpMenu) })
    })
    
    gc()
    # Input
    rv_listgenes <- reactiveValues()
    observeEvent(input$InputGenes_Text, {
        gc()
        l_genes_temp <- input$Gene_area %>% 
            str_remove_all("[:blank:]")%>%
            str_split(pattern = "[\r\n]") %>% 
            unlist()
        
        rv_listgenes$list_genes <- sapply(l_genes_temp, function(x){ifelse(str_detect(x, "orf"), yes = x, no = str_to_upper(x))})
        
        # Warning_MissGenes <- fn_warningmessage(list_genes = rv_listgenes$list_genes)
        # 
        # if(Warning_MissGenes$test){
        #     sendSweetAlert(
        #         session = session,
        #         title = "Warning",
        #         text = Warning_MissGenes$warning_text_final,
        #         type = "warning"
        #     )
        # }
        
        updateTabItems(session, "tabs", "plot_subtab")
    })
    
    observeEvent(input$InputGenes_ListSelected, {
        gc()
        rv_listgenes$list_genes <- column_to_rownames(filter(SelectedGenes_legend, !is.na(Enhanced_Gene)), "Enhanced_Gene")[input$l_GOI,"gene"]
            #filter(SelectedGenes_legend, Enhanced_Gene %in% input$l_GOI)$gene
        
        # Warning_MissGenes <- fn_warningmessage(list_genes = rv_listgenes$list_genes)
        # 
        # if(Warning_MissGenes$test){
        #     sendSweetAlert(
        #         session = session,
        #         title = "Warning",
        #         text = HTML(Warning_MissGenes$warning_text_final),
        #         type = "warning"
        #     )
        # }
        
        updateTabItems(session, "tabs", "plot_subtab")
    })    
    
    list_genes <- eventReactive(rv_listgenes$list_genes, {
        return(rv_listgenes$list_genes)
    })
    
    # Filtrage des gènes matchant avec une annotaiton
    observeEvent(input$InputGenes_UpdataCat, {
        l_subcategory_filter <- unique(filter(SelectedGenes_legend_NoMerge, category %in% input$l_Annotation_category)$subcategory)
        updatePickerInput(session, inputId = "l_Annotation_subcategory", choices = l_subcategory_filter)
        
        l_genes <- filter(SelectedGenes_legend_NoMerge, 
                          category %in% input$l_Annotation_category)$gene
        l_genes_filter <- unique(filter(SelectedGenes_legend_NoMerge, gene %in% l_genes & category %in% input$l_Annotation_category)$Enhanced_Gene) 
        updatePickerInput(session, inputId = "l_GOI", choices = l_genes_filter)
    })
    
    observeEvent(input$InputGenes_UpdataSubCat, {
        l_genes <- filter(SelectedGenes_legend_NoMerge, 
                          subcategory %in% input$l_Annotation_subcategory)$gene
        
        l_genes_filter <- unique(filter(SelectedGenes_legend_NoMerge, gene %in% l_genes & subcategory %in% input$l_Annotation_subcategory)$Enhanced_Gene) %>% unique()
        updatePickerInput(session, inputId = "l_GOI", choices = l_genes_filter)
    })
    
    # Some options that are now fixed
    ShowCellType = TRUE
    ShowCellType_coexp = TRUE
    DynamicSize = TRUE
    ShowTumor <- TRUE
    ############
    #  Intro   #
    ############
    output$start_text <- renderText(start_text)
    output$HowTo_Part1  <- renderText(HowTo_Part1)
    output$HowTo_Part2 <- renderText(HowTo_Part2)
    
    ############
    #    LU    #
    ############
    # Manage size of plots 
    values <-reactiveValues()
    Height_AgeDotPlot <- function(){
        h <- 144*length(list_genes()) + 30 + 10
        values$Height_AgeDotPlot <- ifelse(DynamicSize == TRUE, yes = h, no = 720)
        return(values$Height_AgeDotPlot)
    }
    
    Width_UMAP <- function(){
        w <- 250*length(list_genes())
        if(input$RunFeatPlot == FALSE){w <- 0}
        if(ShowCellType == TRUE){w <- w + 250}
        values$Width_UMAP <- ifelse(DynamicSize == TRUE, yes = w, no = "100%")
        return(values$Width_UMAP)
    }
    
    # Feature plot
    output$UMAP_preUI <- renderPlot({
        l_genes <- list_genes()
        all_genes_Lu <- names(df_Lu2020_Norm_MarkersLiu)[-1]
        
        if(input$RunFeatPlot == TRUE){
            l_plots <- lapply(intersect(l_genes, all_genes_Lu), function(GOI){fn_FeaturePlot_Lu2020(GOI)})

            if(ShowCellType == TRUE){
                p <- plot_grid(plotlist = c(p_clusters_small, l_plots), nrow = 1)
            }
            else{p <- plot_grid(plotlist = l_plots, nrow = 1)}
        }
        else{
            p <- plot_grid(plotlist = p_clusters_small, nrow = 1)
        }
        return(p)
    })
    
    output$UMAP <- renderUI({
        plotOutput("UMAP_preUI", height = 720, width = Width_UMAP())
    })

    
    # General Dotplot
    Width_GeneralDotPlot <- function(){
        all_genes_Lu <- names(df_Lu2020_Norm_MarkersLiu)[-1]
        l_genes <- list_genes() %>% intersect(all_genes_Lu)
        n_genes <- length(l_genes)
        if(n_genes <= 5){n_genes = 5}
        values$Width_GeneralDotPlot <- 25 * n_genes + 220
        return(values$Width_GeneralDotPlot)
    }
    
    output$GeneralDotPlot_preUI <- renderPlot({
        all_genes_Lu <- names(df_Lu2020_Norm_MarkersLiu)[-1]
        l_genes <- list_genes() %>% intersect(all_genes_Lu)
        fn_plot_GeneralDotPlot(list_genes = l_genes)
    })
    
    output$GeneralDotPlot <- renderUI({
        plotOutput("GeneralDotPlot_preUI", height = 500, width = Width_GeneralDotPlot())
    })
    
    # Age dependent dot plot
    Height_AgeDotPlot_LuRBSC11 <- function(){
        all_genes_Lu <- names(df_Lu2020_Norm_MarkersLiu)[-1]
        l_genes <- list_genes() %>% intersect(all_genes_Lu) #%>% intersect(all_genes_Liu)
        h <- 144*length(l_genes) + 50*1.2
        if(length(l_genes) == 1){h <- h + 20}
        values$Height_AgeDotPlot_LuRBSC11 <- ifelse(DynamicSize == TRUE, yes = h, no = 720)
        return(values$Height_AgeDotPlot_LuRBSC11)
    }
    
    # output$AgeDotPlot_preUI <- renderPlot({
    #     all_genes_Lu <- names(df_Lu2020_Norm_MarkersLiu)[-1]
    #     l_genes <- list_genes() %>% intersect(all_genes_Lu)
    #     
    #     p <- fn_agedotplot(l_genes = l_genes)+ theme(legend.position = "top")
    #     return(p)
    # })
    
    output$DotPlot_preUI_LuRBSC11 <- renderPlot({
        all_genes_Lu <- names(df_Lu2020_Norm_MarkersLiu)[-1]
        l_genes <- list_genes() %>% intersect(all_genes_Lu) #%>% intersect(all_genes_Liu)
        p <- fn_DotPlot_Merge(l_genes)
        return(p)
    })
    
    output$AgeDotPlot <- renderUI({
        plotOutput("DotPlot_preUI_LuRBSC11",  width = 1800, height = Height_AgeDotPlot_LuRBSC11())
        # if(ShowTumor){
        #     plotOutput("DotPlot_preUI_LuRBSC11",  width = 1800, height = Height_AgeDotPlot_LuRBSC11())
        # }else{plotOutput("AgeDotPlot_preUI", width = 1800, height = Height_AgeDotPlot())}
        # 
    })
    
    # Table
    output$Table  <- DT::renderDataTable({
        l_genes <- list_genes()
        CatToShow <- c("Retinal markers (Liu et al.)",  "Genes related to Figures", "DEGs between subtypes")      
        df <- filter(SelectedGenes_legend, gene %in% l_genes) %>% 
            select(- Enhanced_Gene, -annotations) %>% 
            group_by(gene, category)%>%
            summarise(subcategory = str_c(subcategory, collapse = "-"))%>%
            filter(category %in% CatToShow)%>%
            arrange(gene) %>%
            ungroup()%>%
            mutate_if(is.character, as.factor)
        
        DT::datatable(df, filter = list(position = "top", clear = FALSE), options = list(orderClasses = TRUE,autoWidth = TRUE))
    })
    # Table from Age dependent dot plot
    output$Table_AgeDotPlot <-  DT::renderDataTable({
            all_genes_Lu <- names(df_Lu2020_Norm_MarkersLiu)[-1]
            l_genes <- list_genes() %>% intersect(all_genes_Lu)
            df_annotation <- filter(SelectedGenes_legend, gene %in% l_genes) %>% select(- Enhanced_Gene)
            df <- fn_data_Counting(list_genes = l_genes, 
                                   l_groupingvars = c("umap2_CellType", "age")) %>%
                left_join(df_annotation, by = c("Gene" = "gene"))%>%
                filter(percent_expressing != 0) %>%
                select(Gene, umap2_CellType, age, percent_expressing, Mean, count_expressing, TotalCells) %>%
                arrange(Gene, umap2_CellType, age)%>%
                rename(`Cell Type` = umap2_CellType, `Mean Expression` = Mean, `Expressing Cells` = count_expressing, `Total Cells` = TotalCells)%>% 
                ungroup()%>%
                mutate_if(is.character, as.factor)%>%
                distinct()%>%
                as.data.frame()        
                
            DT::datatable(df, filter = list(position = "top", clear = FALSE), 
                          options = list(orderClasses = TRUE, autoWidth = TRUE))
    })
    
    #output$Table_AgeDotPlot  <-  DT::renderDataTable({Table_AgeDotPlot()})
    
    ############
    #   LIU    #
    ############
    
    Height_UMAP_RBSC11 <- function(){
        l_genes <- list_genes()
        n_genes <- length(l_genes)
        #if(input$RunFeatPlot == FALSE){n_genes = 0}
        if(ShowCellType == TRUE){n_genes <- n_genes + 1}
        w <- 300*ceiling(n_genes/3)
        values$Height_UMAP_RBSC11 <- ifelse(DynamicSize == TRUE, yes = w, no = "100%")
        return(values$Height_UMAP_RBSC11)
    }
    
    output$UMAP_preUI_RBSC11 <- renderPlot({
        l_genes <- list_genes()
        all_genes_Liu <- names(df_RBSC11_Norm_MarkersLiu)[-1]
        l_plots <- lapply(intersect(l_genes, all_genes_Liu), fn_FeaturePlot_RBSC11)
        if(ShowCellType == TRUE){
            plot_grid(plotlist = c(list(p_clusters_RBSC11_small), l_plots), ncol = 3, align = "h", hjust = 0, vjust = 0, greedy = FALSE)
        }
        else{plot_grid(plotlist = l_plots , ncol = 3, align = "h", hjust = 0, vjust = 0, greedy = FALSE)}
    })
    
    output$UMAP_RBSC11 <- renderUI({
        plotOutput("UMAP_preUI_RBSC11", height = Height_UMAP_RBSC11(), width = "100%")
    })
    
    
    output$DotPlot_preUI_RBSC11 <- renderPlot({
        l_genes <- list_genes()
        p <- fn_DotPlot_RBSC11(l_genes)
       return(p)
    })
    
    output$DotPlot_RBSC11 <- renderUI({
        plotOutput("DotPlot_preUI_RBSC11", height = Height_AgeDotPlot())
    })
        
    ################
    # COEXPRESSION #
    ################
    # Input
    observeEvent(input$InputGenes_Text_coexp, {
        gc()
        rv_listgenes$list_genes_coexp <- input$Gene_area_coexp %>% 
                str_remove_all("[:blank:]")%>%
                str_to_upper(locale = "en")%>%
                str_split(pattern = "[\r\n]") %>% 
                unlist()%>% 
                sort()
        
        # Warning_MissGenes <- fn_warningmessage(list_genes_coexp())
        # 
        # if(Warning_MissGenes$test){
        #     sendSweetAlert(
        #         session = session,
        #         title = "Warning",
        #         text = Warning_MissGenes$warning_text_final,
        #         type = "warning"
        #     )
        # }
        
        updateTabItems(session, "tabs", "coexp_subtab")
    })
    
    
    list_genes_coexp <- eventReactive(rv_listgenes$list_genes_coexp, {
        return(rv_listgenes$list_genes_coexp %>% sort())
    })
    
    
    
    df_coexpressed <- eventReactive(rv_listgenes$list_genes_coexp, {
        all_genes_Lu <- names(df_Lu2020_Norm_MarkersLiu)[-1]
        l_genes <- list_genes_coexp() %>% intersect(all_genes_Lu)
        fn_CoExp_GetData(l_genes, all_combi = input$AllCombi_coexp)
    })
    # Feature plot
    Width_UMAP_coexp <- function(){
        w <- 400
        if(ShowCellType_coexp == TRUE){w <- w + 400}
        values$Width_UMAP <- w
        return(values$Width_UMAP)
    }
    
    output$UMAP_preUI_coexp <- renderPlot({
        all_genes_Lu <- names(df_Lu2020_Norm_MarkersLiu)[-1]
        l_genes <- list_genes_coexp() %>% intersect(all_genes_Lu)
        
        l_plots <- fn_CoExp_FeaturePlot(df_coexpressed = df_coexpressed(), l_GOI = l_genes)
        # p_clusters
        if(ShowCellType_coexp == TRUE){
            plot_grid(p_clusters[[1]], l_plots, nrow = 1)
        }
        else{l_plots}
    })
    
    output$UMAP_coexp <- renderUI({#renderPlot({
        plotOutput("UMAP_preUI_coexp", height = 720, width = Width_UMAP_coexp())
    })
    
    # Bar plot
    output$BarPlot_coexp <- renderPlot({
        all_genes_Lu <- names(df_Lu2020_Norm_MarkersLiu)[-1]
        #all_genes_Liu <- names(df_RBSC11_Norm_MarkersLiu)[-1]
        l_genes <- list_genes_coexp() %>% intersect(all_genes_Lu)
        p <- fn_CoExp_PlotBar(df_coexpressed = df_coexpressed(), l_GOI = l_genes)
        p
    })
    
    # Table 
    output$Table_coexp  <-  DT::renderDataTable({
        df <- fn_CoExp_TableRes(df_coexpressed = df_coexpressed(), l_groupingvars = input$l_groupingvars)
        df <- df %>%
            mutate(Proportion = 100 * Proportion)%>%
            rename(`Proportion (%)` = Proportion) %>%
            ungroup()%>%
            mutate_if(is.character, as.factor)
        
        DT::datatable(df, filter = list(position = "top", clear = FALSE), options = list(orderClasses = TRUE, autoWidth = TRUE))})
    
    ############
    #   LIU    #
    ############
    df_coexpressed_Liu <- eventReactive(input$InputGenes_Text_coexp, {
        all_genes_Liu <- names(df_RBSC11_Norm_MarkersLiu)[-1]
        l_genes <- list_genes_coexp() %>% intersect(all_genes_Liu)
        fn_CoExp_GetData(l_genes, 
                         all_combi = input$AllCombi_coexp, 
                         df_data = df_RBSC11_Norm_MarkersLiu)
    })
    
    output$UMAP_preUI_coexp_Liu <- renderPlot({
        all_genes_Liu <- names(df_RBSC11_Norm_MarkersLiu)[-1]
        l_genes <- list_genes_coexp()  %>% intersect(all_genes_Liu)
        
        l_plots <- fn_CoExp_FeaturePlot_Liu(df_coexpressed = df_coexpressed_Liu(), l_GOI = l_genes, df_metadata = df_RBSC11_metadata)
        # p_clusters
        if(ShowCellType_coexp == TRUE){
            plot_grid(plotlist = list(p_clusters_RBSC11, l_plots), nrow = 1, rel_widths = c(1, 2))
        }
        else{l_plots}
    })
    
    Width_UMAP_coexp_Liu <- function(){
        w <- 1000
        if(ShowCellType_coexp == TRUE){w <- w + 500}
        values$Width_UMAP <- w
        return(values$Width_UMAP)
    }
    
    output$UMAP_coexp_Liu <- renderUI({
        plotOutput("UMAP_preUI_coexp_Liu", height = 500, width = Width_UMAP_coexp_Liu())
    })
    
    # Bar plot
    output$BarPlot_coexp_Liu <- renderPlot({
        all_genes_Liu <- names(df_RBSC11_Norm_MarkersLiu)[-1]
        l_genes <- list_genes_coexp() %>% intersect(all_genes_Liu)
        p <- fn_CoExp_PlotBar_Liu(df_coexpressed = df_coexpressed_Liu(), 
                                  l_GOI = l_genes, 
                                  df_metadata = df_RBSC11_metadata)
        p
    })
    
    # Table 
    output$Table_coexp_Liu  <-  DT::renderDataTable({
        df_temp <- fn_CoExp_TableRes(df_coexpressed = df_coexpressed_Liu(), l_groupingvars = c("cluster"), df_metadata = df_RBSC11_metadata)
        df <- df_temp %>%
            mutate(Proportion = 100 * Proportion)%>%
            rename(`Proportion (%)` = Proportion)%>%
            ungroup()%>%
            mutate_if(is.character, as.factor)
        
        DT::datatable(df, filter = list(position = "top", clear = FALSE), options = list(orderClasses = TRUE, autoWidth = TRUE))})
    
    
    # BOOKMARK
    onBookmark(function(state) {
        Input <- NULL
        if(str_detect(input$tabs, "^plot_subtab")){Input <- str_c(rv_listgenes$list_genes, collapse = "\n")}
        
        if(str_detect(input$tabs, "^coexp_subtab")){Input <- str_c(rv_listgenes$list_genes_coexp, collapse = "\n")}
        state$values$Input <- Input
        #state$values$ShowTumor <- ShowTumor
        state$values$tab<- input$tabs
    })
    
    setBookmarkExclude(c("bookmark","sidebarItemExpanded", "tabs", "sidebarCollapsed", "sidebarItemExpanded", 
                         "GoTo_Info", "GoTo_Exp", "GoTo_CoExp",  "ShowTumor",
                         "InputGenes_UpdataCat", "InputGenes_UpdataSubCat", "InputGenes_ListSelected", "InputGenes_Text",
                         "l_Annotation_subcategory", "l_Annotation_category", "l_groupingvars","l_GOI", 
                         "Gene_area_coexp", "Gene_area", 
                         "RunFeatPlot", "AllCombi_coexp", "InputGenes_Text_coexp"))
    
    # Read values from state$values when we restore
    onRestored(function(state) {
        updateTabItems(session, "tabs", state$values$tab)
        
        if(str_detect(state$values$tab, "^plot_subtab")){
            rv_listgenes$list_genes <- str_split(state$values$Input, "\n") %>% unlist()
            output$sidebarControls <- renderMenu({ sidebarMenu(plotMenu) })
            updateTextAreaInput(session, inputId = "Gene_area", value = state$values$Input)
        }
        if(str_detect(state$values$tab, "^coexp_subtab")){
            rv_listgenes$list_genes_coexp <- str_split(state$values$Input, "\n") %>% unlist()
            output$sidebarControls <- renderMenu({ sidebarMenu(coexpMenu) })
            updateTextAreaInput(session, inputId = "Gene_area_coexp", value = state$values$Input)
        }
        
        #updateMaterialSwitch(session, inputId = "ShowTumor", value = state$values$ShowTumor)
    })
    
    observeEvent(input$bookmark, {
        session$doBookmark()
    })
}
