## put a plot in a temporary png
tmp <- tempfile()
png(tmp)
plot(rnorm(10) + 1:10, xlab='x', ylab='y')
dev.off()

library(digitize)
mydata <- digitize(tmp)
