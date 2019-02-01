context("RandMat* tests")
library(rerf)


test_that("testing fastRerF accuracy on iris", {

	run <- function(n = 100) { 
		pred <- list()
		for (i in 1:n) {
			rf <- fastRerF('../../data/iris.csv', 4, trees = 10)
			pred[[i]] <- fastPredict(iris[, -5], rf)
		}
		pred[[1]]
		return(list(pred = pred))
	}

	out <- run(100)

	results <- mean(sapply(out$pred, function(x) mean(x != (as.numeric(iris[[5]]) - 1))))

	expect_true(results < (3 / 150))
})
