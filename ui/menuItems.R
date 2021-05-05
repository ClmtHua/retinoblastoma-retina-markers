################################################################################
## Sidebar menu items
################################################################################
CatToShow <- c("Retinal markers (Liu et al.)",  "Genes related to Figures", "DEGs between subtypes")

infoMenu <- menuItem("Information", tabName = "info", icon = icon("info-circle"), startExpanded = TRUE, 
                     menuSubItem("Presentation", tabName = "start", icon = icon("info")), 
                     hr(),
                     p(strong("How to:"), style = "font-size: 11pt;"), 
                     menuSubItem("Visualize gene expression", tabName = "HowTo_Part1",icon = icon("question")),
                     menuSubItem("Visualize gene co-expression", tabName = "HowTo_Part2",icon = icon("question")))

plotMenu <- menuItem("Visualize gene expression", icon = icon("columns"), tabName = "plot_tab", startExpanded = TRUE, 
                     p(strong("Step 1: Choose genes"), style = "font-size: 11pt;"),
                     menuItem("Input - from gene list(s)", icon = icon("search"),
                              pickerInput(
                                inputId = "l_Annotation_category", 
                                label = "1. Select gene category(ies)", 
                                choices = CatToShow,
                                multiple = TRUE, selected = c("Retinal markers (Liu et al.)"), 
                                options = list(`actions-box` = TRUE, `live-search`=FALSE)
                              ), 
                              
                              actionBttn(inputId = "InputGenes_UpdataCat", 
                                         label = "Validate gene category(ies)", size = "xs",
                                         color = "primary", style = "material-flat"), 
                              
                              pickerInput(
                                   inputId = "l_Annotation_subcategory", 
                                   label = "2. Select gene subcategory(ies)", 
                                   choices = sort(unique(filter(SelectedGenes_legend_NoMerge, category %in% CatToShow)$subcategory)) %>% as.character(),
                                   multiple = TRUE, 
                                   options = list(`actions-box` = TRUE, `live-search`=TRUE)
                                 ), 
                                 
                                 
                                actionBttn(inputId = "InputGenes_UpdataSubCat", 
                                           label = "Validate gene subcategory(ies)", size = "xs",
                                           color = "primary", style = "material-flat"), 
                              
                                 pickerInput(
                                   inputId = "l_GOI", 
                                   label = "3. Select gene(s)", 
                                   choices =  unique(SelectedGenes_legend_NoMerge$Enhanced_Gene), #distinct(select(SelectedGenes_legend_NoMerge, gene, annotations_merge))$gene
                                   multiple = TRUE, 
                                   options = list(`actions-box` = TRUE, `live-search`=TRUE)#, 
                                   #choicesOpt = list(subtext = distinct(select(SelectedGenes_legend_NoMerge, gene, annotations_merge))$annotation_merge)
                                 ),
                              
                                 actionBttn(inputId = "InputGenes_ListSelected", 
                                            label = "Run", size = "xs",
                                            color = "primary", style = "material-flat")#, 
                                 ), 
                     
                     
                     menuItem("Input - from text box", icon = icon("search"), 
                              textAreaInput(inputId = "Gene_area", 
                                            label = "Gene symbol (one per row)", 
                                            placeholder = "One gene per line"), 
                              
                              actionBttn(inputId = "InputGenes_Text", 
                                         label = "Run", size = "xs",
                                         color = "primary", style = "material-flat")
                              ), 
                  hr(),
                  p(strong("Step 2: Display plots"), style = "font-size: 11pt;"), 
                   menuSubItem(p(icon("chart-bar"), "Normal retina (Lu 2020)", 
                              style = "font-size: medium;"), 
                              tabName = "plot_subtab", icon = NULL), 
                  
                   menuSubItem(p(icon("chart-bar"), "Retinoblastoma", 
                              style = "font-size: medium;"), 
                              tabName = "plot_subtab_RBSC11", icon = NULL), 
                  
                  hr(),
                  p(icon(name = "cogs", lib = "font-awesome"), strong("Graphical options:")),
                  # materialSwitch(inputId = "ShowTumor",status = "primary",
                  #              label = "Show Tumor (in Age-Dot plot)", 
                  #              value = TRUE, right = TRUE), 
                  
                  materialSwitch(inputId = "RunFeatPlot", status = "primary",
                               label = "Run Feature plot (time-consuming)", 
                               value = FALSE, right = TRUE), 
                  hr(),
                  p(strong("Bookmark current gene list:")),
                  bookmarkButton(label = "Bookmark", id = "bookmark"), 
                  
                  hr(),
                  #p(icon("info-circle"), strong("Get help !")), 
                  menuSubItem(p(icon("question"), "Information"), 
                              tabName = "HowTo_Part1", icon = NULL)
)


coexpMenu <- menuItem("Visualize gene co-expression", icon = icon("columns"), tabName = "coexp_tab", startExpanded = TRUE, 
                    p(strong("Step 1: Inputs"), style = "font-size: 11pt;"),
                    textAreaInput(inputId = "Gene_area_coexp", 
                                  label = "Gene symbol (one per row)", 
                                  placeholder = "One gene per line"), 
                    
                    pickerInput(
                      inputId = "l_groupingvars", 
                      label = "Grouping variables (Table)", 
                      choices = setNames(c("umap2_CellType", "age", "sample", "sample_type"), c("Cell type", "Age", "Sample", "Sample type")),
                      multiple = TRUE, 
                      options = list(`actions-box` = TRUE), 
                      selected = c("umap2_CellType", "age")
                    ),
                    
                    materialSwitch(inputId = "AllCombi_coexp", status = "primary",
                                 label = "Show all gene combinations", #fill = TRUE,
                                 value = FALSE, right = TRUE), 
                    
                    actionBttn(inputId = "InputGenes_Text_coexp", 
                               label = "Run", size = "xs",
                               color = "primary", style = "material-flat"), 
                    hr(),
                    p(strong("Step 2: Display plots")), 
                    menuSubItem(p(icon("chart-bar"), "Normal retina (Lu 2020)", 
                                  style = "font-size: medium;"), 
                                tabName = "coexp_subtab", icon = NULL),
                    
                    menuSubItem(p(icon("chart-bar"), "Retinoblastoma", 
                                  style = "font-size: medium;"), 
                                tabName = "coexp_subtab_Liu", icon = NULL),
                    
                    hr(),
                    p(strong("Bookmark current gene list:")),
                    bookmarkButton(label = "Bookmark", id = "bookmark"),
                    
                    hr(),
                    #p(icon("info-circle"), strong("Get help !")), 
                    menuSubItem(p(icon("question"), "Information"), 
                                tabName = "HowTo_Part2", icon = NULL)
)