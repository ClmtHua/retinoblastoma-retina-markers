if(as.integer(R.Version()$major) < 4){
  get_legend <- function(plot)
  {
    grobs <- ggplot_gtable(ggplot_build(plot))$grobs
    legendIndex <- which(sapply(grobs, function(x) x$name) == "guide-box")
    if (length(legendIndex) == 1){
      legend <- grobs[[legendIndex]]
    } else {
      stop('Plot must contain a legend')
    }
  }
}

ggarrange <- function(plotlist, common.legend = T, ncol = 1){
  rel_heights = c(0.1, 1)
  l_plots <- lapply(plotlist, function(p){
    p <- p + theme(legend.position="none")
    return(p)})
  
  umap_nolegend <- plot_grid(plotlist = l_plots, ncol = ncol)
  
  legend <- get_legend(plotlist[[1]]+ theme(legend.position = "top", legend.key.height = unit(8, "pt")))
  
  
  return(plot_grid(legend, umap_nolegend, rel_heights = rel_heights, ncol = 1))
}
