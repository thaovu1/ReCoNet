
#' Bootstrap projection for network replication analysis
#'
#' @param B number of bootstrap samples
#' @param M adjacency matrix
#' @param X1 abundance data (group 1)
#' @param Y1 phenotype data (group 1)
#' @param X2 abundance data (group 2)
#' @param Y2 phenotype data (group 2)
#' @param npc number of principal components
#' @param alpha significance level
#'
#' @return list containing correlations and bootstrap confidence intervals
#' @export

bootstrap_projection <- function(B = 1000,
                                 M,
                                 X1, Y1,
                                 X2, Y2,
                                 npc = 3,
                                 alpha = 0.05) {
  
  # ----------------------------
  # NetSHy score function
  # ----------------------------
  netshy_score <- function(A, X, npc = 1 ) {
    
    if (any(A < 0, na.rm = TRUE)) {
      stop("Adjacency matrix must be non-negative.")
    }
    
    X <- scale(X, center = TRUE, scale = TRUE)
    
    L <- igraph::graph_from_adjacency_matrix(
      A,
      mode = "undirected",
      weighted = TRUE,
      diag = FALSE
    ) |>
      igraph::graph.laplacian(normalized = FALSE) |>
      as.matrix()
    
    pca_mdl <- stats::prcomp(X %*% L)
    pca_mdl$x[, seq_len(npc), drop = FALSE]
  }
  
  # ----------------------------
  # original + projected scores
  # ----------------------------
  org_score <- netshy_score(M, X1, npc)
  org_corr  <- stats::cor(org_score, Y1)
  
  proj_score <- netshy_score(M, X2, npc)
  proj_corr  <- stats::cor(proj_score, Y2)
  
  # ----------------------------
  # bootstrap
  # ----------------------------
  n <- nrow(X2)
  
  boot_corr <- matrix(NA, nrow = B, ncol = npc)
  
  set.seed(202408)
  
  for (i in seq_len(B)) {
    
    idx <- sample(seq_len(n), n, replace = TRUE)
    
    X_i <- X2[idx, , drop = FALSE]
    Y_i <- Y2[idx, , drop = FALSE]
    
    score_i <- netshy_score(M, X_i, npc)
    
    boot_corr[i, ] <- sapply(seq_len(npc), function(j)
      stats::cor(score_i[, j], Y_i)
    )
  }
  
  # ----------------------------
  # CI
  # ----------------------------
  ci <- apply(boot_corr, 2, function(x) {
    stats::quantile(x, probs = c(alpha/2, 1 - alpha/2), na.rm = TRUE)
  })
  
  colnames(ci) <- paste0("PC", seq_len(npc))
  rownames(ci) <- c("lower", "upper")
  
  # ----------------------------
  # output
  # ----------------------------
  list(
    original_correlation = org_corr,
    projected_correlation = proj_corr,
    bootstrap_ci = ci#,
    #bootstrap_distribution = boot_corr
  )
}