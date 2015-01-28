library(GEOquery)
library(ggplot2)

#' Download gds4198 and extract useful bits
#' 
#' @return list with data, genes, subtypes
#' 
get_gds4198 <- function() {
    gds4198 <- getGEO('GDS4198')
    data <- do.call(cbind, lapply(Table(gds4198)[, -c(1, 2)], function(x) as.numeric(as.character(x))))
    subtypes <- factor(stringi::stri_extract_last_regex(Columns(gds4198)$disease.state, '[a-z]+$'))
    genes <- Table(gds4198)$IDENTIFIER
    list(data=data, genes=genes, subtypes=subtypes)
}


#' Add options to pc plot
#' 
#' @param p ggplot
#' @return ggplot
#'
add_options <- function(p) {
    p + geom_point() + theme_bw() + scale_colour_brewer(type='qual', palette='Set2')
}

#' Extract label from ggplot
#' http://stackoverflow.com/a/13650878/1560062
#'
#' @param p plot
#' @return legend
#' 
extract_legend <- function(p){
  tmp <- ggplot_gtable(ggplot_build(p))
  leg <- which(sapply(tmp$grobs, function(x) x$name) == "guide-box")
  tmp$grobs[[leg]]
}

#' Create pc grid
#' 
#' @param x data.frame
#' @return grid
#'
plot_pc <- function(x) {
    pc_3_1 <- add_options(ggplot(x, aes(x = PC3, y = PC1, col=subtype, shape = subtype)))
    pc_2_1 <- add_options(ggplot(x, aes(x = PC2, y = PC1, col=subtype, shape = subtype)))
    pc_2_3 <- add_options(ggplot(x, aes(x = PC2, y = PC3, col=subtype, shape = subtype)))
    
    grid.arrange(
        pc_3_1 + theme(legend.position = "none"),
        pc_2_1 + theme(legend.position = "none"),
        extract_legend(pc_3_1),
        pc_2_3 + theme(legend.position = "none"),
        ncol = 2
    )
}