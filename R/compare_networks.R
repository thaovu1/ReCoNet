#' Compare network total connectivity
#'
#' Performs permutation-based testing of differences in total connectivity
#' between two adjacency matrices using either sign-flipping or relabeling.
#'
#' @param A numeric matrix. First adjacency matrix.
#' @param B numeric matrix. Second adjacency matrix (same dimension as A).
#' @param method character. Permutation method:
#'   \itemize{
#'     \item "sign_flipping": sign-flipping permutation
#'     \item "relabeling": node relabeling permutation
#'   }
#' @param statistic function or character. Test statistic function.
#'   Must accept at least (V1, V2) and optionally p.
#'   If NULL, defaults to PND for relabeling and sum(|A-B|^p) for sign_flipping.
#' @param p numeric. Power parameter (used when applicable).
#' @param n_perm integer. Number of permutations.
#'
#' @return A list with observed statistic, permutation distribution, and p-value.
#'
#' @export
compare_networks <- function(A, B,
                             method = c("sign_flipping", "relabeling"),
                             statistic = NULL,
                             p = 1,
                             n_perm = 1000) {
  
  method <- match.arg(method)
  
  A <- as.numeric(A[upper.tri(A)])
  B <- as.numeric(B[upper.tri(B)])
  
  # -------------------------------
  # helper: wrap external statistics
  # -------------------------------
  wrap_statistic <- function(f) {
    args <- names(formals(f))
    
    function(V1, V2, p = 1) {
      if ("p" %in% args) {
        f(V1, V2, p)
      } else {
        f(V1, V2)
      }
    }
  }
  
  # -------------------------------
  # sign-flipping branch (fixed statistic)
  # -------------------------------
  if (method == "sign_flipping") {
    
    D <- A - B
    
    stat <- sum(abs(D)^p)
    
    perm_stats <- numeric(n_perm)
    
    for (i in seq_len(n_perm)) {
      signs <- sample(c(-1, 1), length(D), replace = TRUE)
      perm_stats[i] <- sum(abs(D * signs)^p)
    }
    
    # -------------------------------
    # relabeling branch (flexible statistic)
    # -------------------------------
  } else if (method == "relabeling") {
    
    # default statistic: PND from discoMod
    if (is.null(statistic)) {
      statistic <- discoMod::PND
    }
    
    # wrap to unify interface
    stat_fun <- wrap_statistic(statistic)
    
    stat <- stat_fun(A, B, p)
    
    perm_stats <- numeric(n_perm)
    
    for (i in seq_len(n_perm)) {
      perm_id <- sample(seq_along(B))
      perm_stats[i] <- stat_fun(A, B[perm_id], p)
    }
  }
  
  # -------------------------------
  # p-value (common)
  # -------------------------------
  p_val <- mean(abs(perm_stats) >= abs(stat))
  
  list(
    method = method,
    observed_stat = stat,
    p_value = p_val,
    perm_stats = perm_stats
  )
}