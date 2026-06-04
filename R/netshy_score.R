#' Compute NetSHY Summary Scores
#'
#' @param A Symmetrical, non-negative network adjacency matrix.
#' @param X Numeric matrix of feature abundances (samples x features).
#' @param npc Integer. Number of principal components to extract.
#' @return A matrix of samples by `npc` containing the network summary scores.
#' @export
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
  return(pca_mdl$x[, seq_len(npc), drop = FALSE])
}
