#' Compute class predictions for each observation in X
#'
#' Predicts the classification of samples using a trained forest.
#'
#' @param X an n by d numeric matrix (preferable) or data frame. The rows correspond to observations and columns correspond to features of a test set, which should be different from the training set.
#' @param forest a forest trained using the RerF function.
#' @param OOB if TRUE then run predictions using out-of-bag samples.
#' @param num.cores the number of cores to use while training. If NumCores=0 then 1 less than the number of cores reported by the OS are used. (NumCores=0)
#' @param Xtrain  an n by d numeric matrix (preferable) or data frame. This should be the same data matrix/frame used to train the forest, and is only required if RerF was called with rank.transform = TRUE. (Xtrain=NULL)
#' @param aggregate.output if TRUE then the tree predictions are aggregated weighted by their probability estimates. Otherwise, the individual tree probabilities are returned. (aggregate.output=TRUE)
#'
#' TODO: Remove option for aggregate output? Only options for returning aggregate predictions or probabilities
#' @param output.scores if TRUE then predicted class scores (probabilities) for each observation are returned rather than class labels. (output.scores = FALSE)
#'
#' @return predictions an n length vector of predictions
#'
#' @examples
#' library(rerf)
#' trainIdx <- c(1:40, 51:90, 101:140)
#' X <- as.matrix(iris[, 1:4])
#' Y <- as.numeric(iris[, 5])
#' forest <- RerF(X[trainIdx, ], Y[trainIdx], num.cores = 1L, rank.transform = TRUE)
#' # Using a set of samples with unknown classification
#' predictions <- Predict(X[-trainIdx, ], forest, num.cores = 1L, Xtrain = X[trainIdx, ])
#' error.rate <- mean(predictions != Y[-trainIdx])
#' @export
#' @importFrom parallel detectCores makeCluster clusterExport parLapply stopCluster
#' @importFrom utils object.size
#'

Predict <- function(X, forest, OOB = FALSE, num.cores = 0L, Xtrain = NULL, aggregate.output = TRUE,
                    output.scores = FALSE) {
  if (OOB) {
    if (!forest$params$store.oob) {
      stop("out-of-bag indices for each tree are not stored. RerF must be called with store.oob = TRUE.")
    }
    # Always aggregate output for OOB predictions
    aggregate.output <- TRUE
  }

  if (is.data.frame(X)) {
    X <- as.matrix(X)
  }
  if (!is.matrix(X)) {
    stop("Observations (X) must be a matrix or data frame.")
  }

  if (forest$params$rank.transform) {
    if (is.null(Xtrain)) {
      ############ error ############
      stop("The model was trained on rank-transformed data. Xtrain must be provided in order to embed Xtest into the rank space")
    } else {
      X <- RankInterpolate(Xtrain, X)
    }
  }

  if (OOB) {
    CompPredictCaller <- function(tree, ...) RunOOB(X = X, tree = tree)
  } else {
    CompPredictCaller <- function(tree, ...) RunPredict(X = X, tree = tree)
  }

  f_size <- length(forest$trees)
  if (num.cores != 1L) {
    if (num.cores == 0L) {
      # Use all but 1 core if num.cores=0.
      num.cores <- parallel::detectCores() - 1L
    }
    num.cores <- min(num.cores, f_size)
    gc()
    if ((utils::object.size(forest) > 2e+09) | (utils::object.size(X) > 2e+09) |
      .Platform$OS.type == "windows") {
      cl <- parallel::makeCluster(spec = num.cores, type = "PSOCK")
      parallel::clusterExport(cl = cl, varlist = c("X", "RunPredict"), envir = environment())
      Yhats <- parallel::parLapply(cl = cl, forest$trees, fun = CompPredictCaller)
    } else {
      cl <- parallel::makeCluster(spec = num.cores, type = "FORK")
      Yhats <- parallel::parLapply(cl = cl, forest$trees, fun = CompPredictCaller)
    }
    parallel::stopCluster(cl)
  } else {
    # Use just one core.
    Yhats <- lapply(forest$trees, FUN = CompPredictCaller)
  }

  # Label each matrix columns with class names
  labels <- forest$labels
  if (!is.integer(forest$labels)) {
    Yhats <- lapply(Yhats, function(x) {
      colnames(x) <- labels
      x
    })
  }

  if (!aggregate.output) {
    if (output.scores) {
      return(Yhats)
    } else {
      predictions <- lapply(Yhats, max.col) # Randomly break ties
      predictions <- matrix(labels[unlist(predictions)], ncol = f_size)
      # predictions <- factor(do.call(cbind, predictions), levels = labels)
      return(predictions)
    }
  } else {
    # Count how many time each observations are out-of-bag
    if (OOB) {
      oob.counts <- integer(nrow(X))
      for (i in 1:f_size) {
        idx <- rowSums(Yhats[[i]]) != 0
        oob.counts[idx] <- oob.counts[idx] + 1
      }
      # Element wise mean of list of matrices
      proba <- Reduce("+", Yhats) / oob.counts
    } else {
      proba <- Reduce("+", Yhats) / length(Yhats)
    }

    if (output.scores) {
      return(proba)
    } else {
      predictions <- max.col(proba, ties.method = "random") # Randomly break ties
      predictions <- factor(predictions, labels = labels)
      return(predictions)
    }
  }
}
