
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
B <- matrix(rnorm(100, 0, 1), 10, 10)
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
#> [1] 0.002
```

The sign-flipping framework evaluates whether the signed connectivity
differences deviate from the null expectation of random sign assignment.

### Sign-flipping permutation

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
#> [1] 0.487
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
#>             [,1]
#> PC1  0.009083376
#> PC2 -0.154458168
#> PC3  0.003465433
#> 
#> $projected_correlation
#>             [,1]
#> PC1 -0.002437884
#> PC2  0.043116519
#> PC3  0.164149559
#> 
#> $bootstrap_ci
#>              PC1        PC2        PC3
#> lower -0.2915705 -0.3339135 -0.3776303
#> upper  0.2862667  0.3664629  0.4064440
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
#>  [1] fastmap_1.2.0       gh_1.5.0            xopen_1.0.1         promises_1.3.3     
#>  [5] digest_0.6.37       mime_0.13           lifecycle_1.0.5     ellipsis_0.3.2     
#>  [9] processx_3.8.6      magrittr_2.0.5      compiler_4.5.1      rlang_1.2.0        
#> [13] doSNOW_1.0.20       tools_4.5.1         igraph_2.3.1        yaml_2.3.10        
#> [17] knitr_1.50          askpass_1.2.1       prettyunits_1.2.0   htmlwidgets_1.6.4  
#> [21] pkgbuild_1.4.8      mclust_6.1.1        curl_7.0.0          xml2_1.4.0         
#> [25] pkgload_1.4.0       miniUI_0.1.2        withr_3.0.2         purrr_1.1.0        
#> [29] sys_3.4.3           desc_1.4.3          grid_4.5.1          roxygen2_7.3.3     
#> [33] urlchecker_1.0.1    profvis_0.4.0       xtable_1.8-4        gitcreds_0.1.2     
#> [37] iterators_1.0.14    cli_3.6.6           rmarkdown_2.29      remotes_2.5.0      
#> [41] rstudioapi_0.17.1   commonmark_2.0.0    sessioninfo_1.2.3   cachem_1.1.0       
#> [45] stringr_1.5.2       parallel_4.5.1      vctrs_0.7.3         devtools_2.4.5     
#> [49] Matrix_1.7-4        jsonlite_2.0.0      callr_3.7.6         rcmdcheck_1.4.0    
#> [53] credentials_2.0.3   testthat_3.2.3      foreach_1.5.2       snow_0.4-4         
#> [57] glue_1.8.1          codetools_0.2-20    ps_1.9.1            stringi_1.8.7      
#> [61] later_1.4.4         tibble_3.3.0        pillar_1.11.0       rappdirs_0.3.3     
#> [65] htmltools_0.5.8.1   brio_1.1.5          discoMod_0.0.0.9000 openssl_2.3.3      
#> [69] httr2_1.2.1         R6_2.6.1            gert_2.1.5          rprojroot_2.1.1    
#> [73] lattice_0.22-7      evaluate_1.0.5      shiny_1.11.1        memoise_2.0.1      
#> [77] httpuv_1.6.16       Rcpp_1.1.0          whisker_0.4.1       xfun_0.53          
#> [81] fs_1.6.6            usethis_3.2.1       pkgconfig_2.0.3
```
