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
#' @param p numeric. Power parameter (used when applicable), use odd number if selecting sign-flipping.
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
  
  A <- as.matrix(A)
  B <- as.matrix(B)
  
  A <- as.numeric(A[upper.tri(A)])
  B <- as.numeric(B[upper.tri(B)])
  
  # -------------------------------
  # SIGN-FLIPPING
  # -------------------------------
  if (method == "sign_flipping") {
    
    D <- A - B
    stat <- sum(D^p)
    
    perm_stats <- numeric(n_perm)
    
    for (i in seq_len(n_perm)) {
      signs <- sample(c(-1, 1), length(D), replace = TRUE)
      perm_stats[i] <- sum((D * signs)^p)
    }
    
    p_val <- mean(abs(perm_stats) >= abs(stat))
    
    return(list(
      observed_stat = stat,
      p_value = p_val,
      perm_stats = perm_stats
    ))
  }
  
  # -------------------------------
  # RELABELING
  # -------------------------------
  if (method == "relabeling") {
    
    if (is.null(statistic)) {
      statistic <- "PND"
    }
    
    if (!statistic %in% names(stat_map)) {
      stop(sprintf(
        "Unsupported statistic '%s'. Choose from: %s", 
        statistic, paste(names(stat_map), collapse = ", ")
      ))
    }
    
    # Dynamically fetch the function safely from discoMod namespace
    fun_name <- stat_map[[statistic]]
    stat_fun <- getExportedValue("discoMod", fun_name)
    
    if (is.null(stat_fun) || !is.function(stat_fun)) {
      stop(sprintf("Could not find function '%s' inside package 'discoMod'.", fun_name))
    }
    
    # Compute observed statistic
    if ("p" %in% names(formals(stat_fun))) {
      stat <- stat_fun(A, B, p)
    } else {
      stat <- stat_fun(A, B)
    }
    
    perm_stats <- numeric(n_perm)
    
    for (i in seq_len(n_perm)) {
      perm_id <- sample(seq_along(A))
      perm_B <- B[perm_id]
      
      if ("p" %in% names(formals(stat_fun))) {
        perm_stats[i] <- stat_fun(A, perm_B, p)
      } else {
        perm_stats[i] <- stat_fun(A, perm_B)
      }
    }
    
    p_val <- mean(abs(perm_stats) >= abs(stat))
    
    return(list(
      observed_stat = stat,
      p_value = p_val,
      perm_stats = perm_stats
    ))
  }
}