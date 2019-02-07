library(datasets)
library(rerf)
library(ggplot2)
set.seed(54321)
X <- as.matrix(iris[, 1:4])

u1 <- Urerf(X, trees = 100, Progress = FALSE)
m <- as.matrix(u1$sim)

heatmap(m, keep.dendro=FALSE)

