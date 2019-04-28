# Will use this for plotting
library(ggplot2)

# Set parameters from paper
mean_white = 44  
mean_black = 34 
standard_dev = 10.5
# This is the decision boundary for the classifier I am evaluating
midpoint = (mean_white + mean_black)/2

# Fill a frame with points to plot (densities)
# Assumes Normality
grid = seq(midpoint - 30, midpoint + 30, by = 0.01)
X = data.frame(
  grid, 
  white = dnorm(grid, mean_white, standard_dev), 
  black = dnorm(grid, mean_black, standard_dev) 
)

# Alternate assumption: Gamma distribution allows some skew
scale_white = standard_dev^2 / mean_white
scale_black = standard_dev^2 / mean_black
shape_white = mean_white / scale_white
shape_black = mean_black / scale_black
X_gamma = data.frame(
  grid, 
  white = dgamma(grid, shape = shape_white, scale = scale_white), 
  black = dgamma(grid, shape = shape_black, scale = scale_black) 
)

#' Plot distributions in red and blue
#'
#' pwa39: proportion of White participants with AHEI above 39
#' pbb39: proportion of Black participants with AHEI below 39
#'
do_plot =function(X, pwa39, pbb39){
  
  ggplot(X) + 
    geom_line(aes(x = grid, y = white), color = "red") + 
    geom_line(aes(x = grid, y = black), color = "blue") + 
    geom_vline(xintercept = 39) + 
    annotate(geom = "text",
             x = mean_white + 0*standard_dev,
             y = 0.01,
             color = "red",
             label = round(digits = 2, pwa39)) + 
    annotate(geom = "text",
             x = mean_black - 0*standard_dev,
             y = 0.01, 
             color ="blue",
             label = round(digits = 2, pbb39)) + 
    ylab("Probability density")+ 
    xlab("AHEI")
}

do_plot(X, 
        pwa39 = pnorm(39,
                      lower.tail = F,
                      mean = mean_white, 
                      sd = standard_dev), 
        pbb39 = pnorm(39,
                      lower.tail = T,
                      mean = mean_black, 
                      sd = standard_dev))

do_plot(X_gamma,        
        pwa39 = pgamma(39,
                      lower.tail = F,
                      shape = shape_white, 
                      scale = scale_white), 
        pbb39 = pgamma(39,
                       lower.tail = T,
                       shape = shape_black,
                       scale = scale_black))



