library(magrittr)
X = read.csv("~/Dropbox/blog posts/drafts/mbta_viz/saturday_worcester_inbound.csv", stringsAsFactors = F)
colnames(X) = c("", colnames(X)[-ncol(X)])
bikes = X[1, -(1:2)] %>% unlist
X = X[-1, ]
X = X[, -2]
View(X)
X[["is_accessible"]] = c(X[-1, 1], "")
odd_numbers = function(a, b){
  return((a:b)[(a:b %% 2) == 1])
}
X = X[odd_numbers(1, nrow(X)), ]
X[["stop"]] = X[[1]]
X[[1]] = NULL

X_long = reshape2::melt(X, id.vars = c("is_accessible", "stop"))
X_long = dplyr::rename(X_long, train = variable, time = value)
X_long$bikes = bikes[X_long$train]
  
parse_time = function(x){
  to_strip = "\x..|M.*"
  x  = gsub(to_strip, "", x)
}

X_long$time %<>% parse_time
head(X_long)
