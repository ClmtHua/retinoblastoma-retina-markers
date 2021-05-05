# Packages installer
options(repos = c("https://pbil.univ-lyon1.fr/CRAN/"))

cran_packages <- c('tidyverse', 'shiny', 'shinyWidgets', 'DT', 'ggpubr', 'reshape2', 'cowplot', 'shinydashboard', 'shinybusy')

new_cran_packages <- cran_packages[!(cran_packages %in% installed.packages()[,"Package"])]
if(length(new_cran_packages)) install.packages(new_cran_packages)

