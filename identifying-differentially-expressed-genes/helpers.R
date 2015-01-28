library(GEOquery)

#' Download gds3773 and extract useful bits
#' There is probably a better but it will have to suffice for now
#'
#' @return list with following fields: columns, data, sampleclass, meta
#'
get_gds3773 <- function() {
    gds3773 <- getGEO('GDS3773', GSEMatrix=TRUE)

    # Get table and drop ID_REF
    gds3773_data <- Table(gds3773)[, -1]

    # Get groups
    sampleclass <- factor(grepl('control', Columns(gds3773)$description), levels=c(TRUE, FALSE), labels=c('1', '2'))      
         
    # Convert readings to numerics
    gds3773_data [, -1] <- {
        apply(Table(gds3773)[, -c(1, 2)], 2, function(x) as.numeric(as.character(x)))
    }
    
    # Drop NAs
    gds3773_data <- gds3773_data[complete.cases(gds3773_data), ]
    
    
    fields <- c(
        'platform_organism', 'description', 'feature_count', 'sample_count', 'sample_type', 'platform_technology_type'
    )
    
    meta <- setNames(as.data.frame(do.call(rbind, lapply(Meta(gds3773), '[', 1)[fields])), c(""))

    list(
        # Sample data
        columns = Columns(gds3773),
        data = gds3773_data,
        sampleclass = sampleclass,
        # Metadata
        meta = meta
    )
}