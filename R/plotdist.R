library(ggplot2)

#' Plot Different Probability Distributions
#' 
#' Plot a histogram of n elements sampled from various distributions.
#' Possible Distributions:
#' \itemize{
#'   \item 'unif' -> Uniform(min, max)
#'   \item 'norm' -> Normal(mean, sd)
#'   \item 'chisq' -> Chi-Squared(df)
#'   \item 'exp' -> Exponential(rate)
#'   \item 'bin' -> Binomial(prob)
#' }
#' 
#' @param n number of sampled elements, n > 0
#' @param dist abbreviation for different distributions
#' @param ... optional parameters for different distributions
#' @param name The name of the distribution
#' @param kde draw a kernal density on top of the histogram
#' @author Matt Mackenzie
#' @export
#' @examples
#' plotdist(50, 'unif', min = 10, max = 15)
#' plotdist(100, 'norm', mean = 5, sd = 2)
#' plotdist(500, 'chisq', df = 5)
#' plotdist(10, 'exp', rate = 3)
plotdist <- function(n, dist, ..., name = "", kde = FALSE) {
  # check n is valid
  if ((!is.numeric(n)) || (round(n) != n) | (n <= 0)) {
    stop("n must be a positive non-zero integer.")
  }
  
  #check dist is valid
  dist <- tolower(dist)
  possible_distributions = c('unif', 'norm', 'chisq', 'exp', 't', 'f')
  if (!(dist %in% possible_distributions)) {
    stop(sprintf("'%s' is not an allowed distribution.", dist))
  }
  
  # extract r_params from ... args
  r_params <- c(list(...), list(n = n))
  func <- NA
  
  # create sample for correct dist and correct r_params as needed
  if (dist == 'unif') {
    if (is.null(r_params$min)) r_params$min <- 0
    if (is.null(r_params$max)) r_params$max <- as.numeric(r_params$min) + 1
    funcs <- list(r = runif, d = dunif)
  } else if (dist == 'norm') {
    if (is.null(r_params$mean)) r_params$mean <- 0
    if (is.null(r_params$sd)) r_params$sd <- 1
    funcs <- list(r = rnorm, d = dnorm)
  } else if (dist == 'chisq') {
    if (is.null(r_params$df)) r_params$df <- 1
    funcs <- list(r = rchisq, d = dchisq)
  } else if (dist == 'exp') {
    if (is.null(r_params$rate)) r_params$rate <- 1
    funcs <- list(r = rexp, d = dexp)
  } else if (dist == 't') {
    if (is.null(r_params$df)) r_params$df <- 1
    if (is.null(r_params$ncp)) r_params$ncp <- 0
    funcs <- list(r = rt, d = dt)
  } else if (dist == 'f') {
    if (is.null(r_params$df1)) r_params$df1 <- 1
    if (is.null(r_params$df2)) r_params$df2 <- 1
    funcs <- list(r = rf, d = df)
  }
  
  x <- do.call(funcs$r, r_params)
  h <- hist(x, xlab = "", ylab = "Count", main = paste("Histogram of", name, "Data"))
  
  if (kde) {
    s <- seq(min(x), max(x), length=50)
    d_params <- r_params
    d_params$n <- NULL
    d_params$x <- s
    X <- do.call(funcs$d, d_params)
    X <- X * diff(h$mids[1:2]) * n
    lines(s, X, col = "blue", lwd = 2)
  }
}
