################################################################################
## Dashboard version
################################################################################
library(shiny)
library(shinyWidgets)
library(DT)
library(shinydashboard)
library(shinybusy)
library(tidyverse)

pdf(NULL)
# Change default theme
theme_set(theme_gray())

source("Source/source.R", chdir = TRUE)
source("Source/source_LiuRB.R", chdir = TRUE)
source("Source/source_CoExpressed.R", chdir = TRUE)
source("Source/source_Merge.R", chdir = TRUE)

source("ui/menuItems.R", chdir = TRUE)
source("ui/informationTexts.R", chdir = TRUE)
source("ui/ui.R", chdir = TRUE)

source("server/server.R", chdir = TRUE)

gc()
 
theme_set(theme_gray())
enableBookmarking(store = "url")
shinyApp(ui, server)


