#' Plot Different Probability Distributions
#' 
#' Plot a histogram of n elements sampled from various distributions.
#' Possible Distributions:
#' \itemize{
#'   \item 'unif' -> Uniform(min, max)
#'   \item 'norm' -> Normal(mean, sd)
#'   \item 'chisq' -> Chi-Squared(df)
#'   \item 'exp' -> Exponential(rate)
#' }
#' 
#' @param n number of sampled elements, n > 0
#' @param dist abbreviation for different distributions
#' @param ... optional parameters for different distributions
#' @param kde draw a kernal density on top of the histogram
#' @author Matt Mackenzie
#' @export
#' @examples
#' plotdist(50, 'unif', min = 10, max = 15)
#' plotdist(100, 'norm', mean = 5, sd = 2)
#' plotdist(500, 'chisq', df = 5)
#' plotdist(10, 'exp', rate = 3)
plotdist <- function(n, dist, ..., kde = FALSE) {
  # check n is valid
  if ((!is.numeric(n)) || (round(n) != n) | (n <= 0)) {
    stop("n must be a positive non-zero integer.")
  }
  
  #check dist is valid
  dist <- tolower(dist)
  possible_distributions = c('unif', 'norm', 'chisq', 'exp')
  if (!(dist %in% possible_distributions)) {
    stop(sprintf("'%s' is not an allowed distribution.", dist))
  }
  
  # extract params from ... args
  params <- list(...)
  
  # create sample for correct dist and correct params as needed
  if (dist == 'unif') {
    if (is.null(params$min)) params$min <- 0
    if (is.null(params$max)) params$max <- as.numeric(params$min) + 1
    x <- runif(n, min = params$min, max = params$max)
  } else if (dist == 'norm') {
    if (is.null(params$mean)) params$mean <- 0
    if (is.null(params$sd)) params$sd <- 1
    x <- rnorm(n, mean = params$mean, sd = params$sd)
  } else if (dist == 'chisq') {
    if (is.null(params$df)) params$df <- 1
    x <- rchisq(n, params$df)
  } else if (dist == 'exp') {
    if (is.null(params$rate)) params$rate <- 1
    x <- rexp(n, rate = params$rate)
  }
  hist(x)
}










