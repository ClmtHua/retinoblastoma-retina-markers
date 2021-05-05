ui <- function(request) {
  dashboardPage(skin = "yellow", title = "Marker visualisation in retina and retinoblastoma",
                header = dashboardHeader(
                                         title = span("retinoblastoma-retina-markers.curie.fr", 
                                                    style = "white-space: normal; color: white; font-size: 13px; padding:5px 0 0 0; margin: 1 1 1 1; width: 250"),
                                         titleWidth = 250,#"30%", 
                                         tags$li(
                                           tags$style(HTML(".navbar-custom-menu {
                                                           float: left!important; 
                                                           padding: 5px 0px; 
                                                           box-sizing:content-box
                                                           }")), # !important
                                           tags$style(HTML(".bttn-stretch.bttn-md {
                                                            font-size: 20px;
                                                            font-family: inherit;
                                                            padding: 5px 20px;
                                                          }")),
                                           tags$style(HTML(".bttn-stretch.bttn-default {
                                                          color: #fff;
                                                          font-weight: 500;
                                                        }")),
                                            class = "dropdown",
                                            HTML("<div style='
                                                float:left;
                                                font-weight:500;
                                                padding-right:5px;
                                                padding-top: 5px;
                                                color:white;
                                                font-size: 20px;
                                                font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;'> 
                                                Marker visualisation in retina and retinoblastoma &nbsp
                                                </div>"),
                                              actionBttn("GoTo_Info", "1. Information", style = "stretch", size = "m"), 
                                              actionBttn("GoTo_Exp", "2. Gene Expression", style = "stretch", size = "m"), 
                                              actionBttn("GoTo_CoExp", "3. Gene Co-expression", style = "stretch", size = "m")
                                         )
                                         ),
                
                sidebar = dashboardSidebar(
                  width = 250, 
                  sidebarMenu(id = "tabs",
                              sidebarMenuOutput("sidebarControls")
                              )
                ),
                body = dashboardBody( 
                  tags$head(
                    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
                    tags$style("body {overflow-y: auto;}"),
                    tags$style(HTML(".sidebar-menu li a { font-size: 11.5pt; }"))
                  ),
                  tags$style(HTML("hr {border: none; border-top: 2px solid #000000; margin: 5px; text-align: center}")),
                  tags$style(type="text/css",
                             ".shiny-output-error { visibility: hidden; }",
                             ".shiny-output-error:before { visibility: hidden; }",
                             ".wrapper {overflow-y: hidden;}"
                  ),    
                  add_busy_bar(color = "red", height = "8px"), 
                  div(class="wrap",
                      tabItems(
                        tabItem(tabName = "start",
                                #fluidRow(
                                box(width = 12,
                                    htmlOutput("start_text")) 
                                #)
                        ),
                        
                        tabItem(tabName = "HowTo_Part1",
                                #fluidRow(
                                box(width = 12,
                                    htmlOutput("HowTo_Part1")) 
                                #)
                        ),
                        
                        tabItem(tabName = "HowTo_Part2",
                                #fluidRow(
                                box(width = 12,
                                    htmlOutput("HowTo_Part2")) 
                                #)
                        ),
                        
                        tabItem(tabName = "plot_subtab", 
                                tabBox(title = "", selected = "Age-dependent dot plot", width = 12, 
                                       tabPanel("Age-dependent dot plot", 
                                                div(style = 'overflow-x: scroll; overflow-y: auto;', uiOutput("AgeDotPlot"))), 
                                       tabPanel("General dot plot", div(style = 'overflow-x: auto',uiOutput("GeneralDotPlot"))),
                                       tabPanel("Feature plot", div(style = 'overflow-x: scroll', uiOutput("UMAP"))),
                                       tabPanel("Table of annotations", DTOutput("Table")), 
                                       tabPanel("Table Age-dependent dot plot", DTOutput("Table_AgeDotPlot"))
                                )
                        ), 
                        
                        tabItem(tabName = "plot_subtab_RBSC11", #expandedName ="plot_subtab_RBSC11_exp",
                                tabBox(title = "", selected = "Feature plot", width = 12, 
                                       tabPanel("Feature plot", 
                                                div(style = 'overflow-x: scroll', uiOutput("UMAP_RBSC11")
                                                )),
                                       tabPanel("Dot-violin Plot", uiOutput("DotPlot_RBSC11")) 
                                )
                        ),
                        
                        tabItem(tabName = "coexp_subtab",  
                                tabBox(title = "", selected = "Feature plot", width = 12, 
                                       tabPanel("Feature plot", uiOutput("UMAP_coexp")),
                                       tabPanel("Bar plot", div(style = 'box-sizing: border-box ;', plotOutput("BarPlot_coexp", height = 800, width = 1200))), 
                                       tabPanel("Table", DTOutput("Table_coexp"))
                                )
                        ),
                        
                        tabItem(tabName = "coexp_subtab_Liu",  
                                tabBox(title = "", selected = "Feature plot", width = 12, 
                                       tabPanel("Feature plot", uiOutput("UMAP_coexp_Liu")),
                                       tabPanel("Bar plot", div(style = 'box-sizing: border-box ;', plotOutput("BarPlot_coexp_Liu", height = 800/1.5, width = (1200 + 600)/1.5))), 
                                       tabPanel("Table", DTOutput("Table_coexp_Liu"))
                                )
                        )
                        #,
                        #div(class = "footer", img(src="logo_curie.png", height="80px"), align="right")
                      )),
                  HTML("<p style = 'position: absolute; bottom: 5px; right: 5px;  overflow-wrap: break-word; text-align: right;'> Source of data: retina (Lu <em> et al.</em>, 2020), retinoblastoma (Liu <em> et al., in revision)</em></p>")
                  )
  )
}


