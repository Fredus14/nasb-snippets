# Hierarchical Clustering


```r
library(gplots)

source('helpers.R', local=TRUE)
```

## Load dataset

```r
gds4198 <- get_gds4198()
```

## Perform hierarchical clustering

```r
gds4198_samples_dm <- dist(t(gds4198$data))
gds4198_samples_hc <- hclust(gds4198_samples_dm)
```

## Plot results

```r
plot(dendrapply(as.dendrogram(gds4198_samples_hc), color_by_subtype, colnames(gds4198$data), gds4198$subtypes))
title('Dendrogram GDS4198, complete linkage')
```

![](hierarchical-clustering__files/figure-html/unnamed-chunk-4-1.png) 


