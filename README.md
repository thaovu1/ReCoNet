
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Overview

ReCoNet provides methods for:

- network connectivity comparison
- permutation-based statistical inference
- projection-based network replication

The package operates directly on precontructed adjacency matrices.

## Installation

``` r
devtools::install_github("thaovu1/ReCoNet")
```

## Load package

``` r
library(ReCoNet)
```

## Simulated Example Data

``` r
set.seed(123)

A <- matrix(runif(100, 0, 1), 10, 10)
B <- matrix(runif(100, 0, 1), 10, 10)
```

## Network Comparison

The compare_networks() function evaluates total connectivity differences
between two networks.

### Sign-flipping permutation

``` r
res_sf <- compare_networks(
  A = A,
  B = B,
  method = "sign_flipping",
  p = 5,
  n_perm = 1000
)

res_sf$p_value
#> [1] 0.251
```

The sign-flipping framework evaluates whether the signed connectivity
differences deviate from the null expectation of random sign assignment.

### Node relabeling permutation

``` r
res_rl <- compare_networks(
  A = A,
  B = B,
  method = "relabeling",
  statistic = "PND",
  p = 6,
  n_perm = 1000
)

res_rl$p_value
#> [1] 0.594
```

## Network Replication

The bootstrap_projection() function evaluates projection-based
replication in an independent dataset.

``` r
n <- 50
p <- 10

X1 <- matrix(rnorm(n * p), n, p)
X2 <- matrix(rnorm(n * p), n, p)

Y1 <- matrix(rnorm(n), n,1)
Y2 <- matrix(rnorm(n), n,1)
```

### Inference of Replication with bootstrap

``` r
proj_res <- bootstrap_projection(
  B = 500,
  M = A,
  X1 = X1,
  Y1 = Y1,
  X2 = X2,
  Y2 = Y2,
  npc = 3,
  alpha = 0.05
)

proj_res
#> $original_correlation
#>            [,1]
#> PC1 -0.01058786
#> PC2  0.15370996
#> PC3 -0.13633978
#> 
#> $projected_correlation
#>            [,1]
#> PC1  0.06155065
#> PC2  0.26646808
#> PC3 -0.07821526
#> 
#> $bootstrap_ci
#>              PC1        PC2        PC3
#> lower -0.3937265 -0.4270295 -0.4459614
#> upper  0.3804192  0.4126539  0.3872681
```

### Optional return of NetSHy scores

``` r
netshy <- netshy_score(
  A = A,
  X = X1,
  npc = 3
  )

netshy
#>                PC1         PC2         PC3
#>  [1,]   3.77293582   5.0926279  -4.5821804
#>  [2,]  10.49954057   4.3511114   4.2900263
#>  [3,]  -0.87651890   6.1089537  -6.1676610
#>  [4,]  15.74650272  14.4826107 -10.5232827
#>  [5,]   2.55649170   8.8117349  10.3973155
#>  [6,]   3.63957520  -4.3760108  -0.3640642
#>  [7,] -25.11184819   2.8486151  -7.2163170
#>  [8,]   9.74022586  -5.7818039   1.4103541
#>  [9,]   4.64530613   9.3382183  -6.6771985
#> [10,]  12.20844466  -3.7736886   0.9466245
#> [11,]  10.47743795   0.2582468  10.3401533
#> [12,] -17.41904879   0.5302320  11.1681260
#> [13,]  -7.10446877   5.3313623  10.2925332
#> [14,]   3.61284051  -0.2764365   0.1827383
#> [15,]   1.30989426   8.3068488   3.9495330
#> [16,] -11.93348995 -13.9211667  11.2295478
#> [17,]   3.06289765   0.3188249   0.2646517
#> [18,]  -4.25360809  -0.5492505 -14.7709366
#> [19,]  18.94276335  -2.5575963  -2.8553161
#> [20,]  -2.76292404   3.9443655   2.8062910
#> [21,]   5.26774574   5.3539163  -5.4653319
#> [22,]  -2.23073414  -7.4686510   8.1712325
#> [23,]   0.04731061 -10.0014353   1.6004909
#> [24,]   7.22739928   0.6691332   9.5987294
#> [25,]   3.74114453   4.1291769 -14.5315215
#> [26,] -11.72904027   7.0076056   8.9453806
#> [27,]   2.50556104  -8.6665615   1.9785372
#> [28,]   2.03856673  -4.7882445  -8.5384962
#> [29,]   1.97326986   6.3412184  -4.7632137
#> [30,]  -8.59964413   6.9935356   4.9904476
#> [31,] -13.69905386  -5.6218683  -7.7342149
#> [32,]  -1.71432476 -11.9415088  -3.9490038
#> [33,]  12.82556319  -4.9897163  -1.1629785
#> [34,]  -1.37657185   1.4028530  -9.0761362
#> [35,]  -5.70571154 -15.8536794   0.6878452
#> [36,]   1.25492724   9.9490066  -3.9989061
#> [37,]   8.14535447  -5.7109708   1.5122915
#> [38,]  -7.40584977  -2.9217260   5.0511366
#> [39,]  12.41351008  -3.0895234   6.5191242
#> [40,]  -2.01815397 -12.9103077  -1.8660766
#> [41,]  -2.60386865  -6.3237533  -4.4957999
#> [42,]   4.58084109  19.3149032  15.1517831
#> [43,]   8.47756559  -9.8578383  -3.5842632
#> [44,]  -2.35810604  -5.4953625  -1.7296667
#> [45,]  -4.53770455   2.2728626  -2.5471236
#> [46,]  -9.47013954   0.8505297  -5.6588632
#> [47,]  14.47098510  -2.4691675   4.0966422
#> [48,] -13.24740310   1.0557984   6.1531618
#> [49,] -18.34542843   6.9967057  -7.7259340
#> [50,] -10.68095959   7.2852703  -1.7502109
```

## Interpretation

The network comparison framework assesses global connectivity
differences between two networks using permutation-based significance
testing.

The replication framework evaluates reproducibility of network-derived
latent structure in independent datasets.

## Session Information

``` r
sessionInfo()
#> R version 4.5.1 (2025-06-13)
#> Platform: aarch64-apple-darwin20
#> Running under: macOS Tahoe 26.5
#> 
#> Matrix products: default
#> BLAS:   /System/Library/Frameworks/Accelerate.framework/Versions/A/Frameworks/vecLib.framework/Versions/A/libBLAS.dylib 
#> LAPACK: /Library/Frameworks/R.framework/Versions/4.5-arm64/Resources/lib/libRlapack.dylib;  LAPACK version 3.12.1
#> 
#> locale:
#> [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
#> 
#> time zone: America/Denver
#> tzcode source: internal
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] ReCoNet_0.1.0
#> 
#> loaded via a namespace (and not attached):
#>  [1] xml2_1.4.0          lattice_0.22-7      stringi_1.8.7       digest_0.6.37       magrittr_2.0.5      grid_4.5.1         
#>  [7] evaluate_1.0.5      iterators_1.0.14    pkgload_1.4.0       fastmap_1.2.0       Matrix_1.7-4        rprojroot_2.1.1    
#> [13] foreach_1.5.2       discoMod_0.0.0.9000 pkgbuild_1.4.8      sessioninfo_1.2.3   brio_1.1.5          mclust_6.1.1       
#> [19] doSNOW_1.0.20       urlchecker_1.0.1    promises_1.3.3      purrr_1.1.0         codetools_0.2-20    cli_3.6.6          
#> [25] shiny_1.11.1        rlang_1.2.0         commonmark_2.0.0    ellipsis_0.3.2      remotes_2.5.0       withr_3.0.2        
#> [31] cachem_1.1.0        yaml_2.3.10         devtools_2.4.5      tools_4.5.1         parallel_4.5.1      memoise_2.0.1      
#> [37] httpuv_1.6.16       vctrs_0.7.3         R6_2.6.1            mime_0.13           lifecycle_1.0.5     stringr_1.5.2      
#> [43] fs_1.6.6            htmlwidgets_1.6.4   usethis_3.2.1       miniUI_0.1.2        pkgconfig_2.0.3     desc_1.4.3         
#> [49] pillar_1.11.0       later_1.4.4         glue_1.8.1          profvis_0.4.0       Rcpp_1.1.0          xfun_0.53          
#> [55] tibble_3.3.0        rstudioapi_0.17.1   knitr_1.50          xtable_1.8-4        igraph_2.3.1        htmltools_0.5.8.1  
#> [61] snow_0.4-4          rmarkdown_2.29      testthat_3.2.3      compiler_4.5.1      roxygen2_7.3.3
```
