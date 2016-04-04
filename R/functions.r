#' @export
ReadAndCal <- function(fname)
{
  ReadImg(fname)
  calpoints <- locator(
    n = 4,
    type = 'p',
    pch = 4,
    col = 'blue',
    lwd = 2
  )
  return(calpoints)
}

#' @importFrom graphics plot
#' @importFrom readbitmap read.bitmap
ReadImg <- function(fname)
{
  img <- read.bitmap(fname)
  op <- par(mar = c(0, 0, 0, 0))
  on.exit(par(op))
  plot.new()
  rasterImage(img, 0, 0, 1, 1)
}

#' @export
DigitData <- function(col = 'red', type = 'p', ...)
{
  type <- ifelse(type == 'b', 'o', type)
  type <- ifelse(type %in% c('l', 'o', 'p'), type, 'p')
  locator(type = type, col = col, ...)
}

#' @export
Calibrate <- function(data, calpoints, x1, x2, y1, y2)
{
  x 		<- calpoints$x[c(1, 2)]
  y 		<- calpoints$y[c(3, 4)]
  
  cx <- lm(formula = c(x1, x2) ~ c(x))$coeff
  cy <- lm(formula = c(y1, y2) ~ c(y))$coeff
  
  data$x <- data$x * cx[2] + cx[1]
  data$y <- data$y * cy[2] + cy[1]
  
  return(as.data.frame(data))
}

#' digitize an image
#'
#' @param image_filename the image file you wish to digitze
#' @param x1 (optional) left-most x-axis point
#' @param x2 (optional) right-most axis point
#' @param y1 (optional) the lower y-axis point
#' @param y2 (optional) the upper y-axis point
#' @param  ... pass parameters col or type to change data calibration points
#' @details Proceeds in two steps, both of which require user input
#'          from the mouse:
#'
#'            1) Read the image in and calibrate it
#'
#'            2) Digitize the data
#'
#'          Calibration points are optionally passed via arguments x1, x2, y1,
#'          y2. These **must be named in full** if passed.
#'
#'          If not specified, you are prompted to enter these in the
#'          console. Note, you don’t need to choose the end points of each axis,
#'          only two points for which you know the x or y value.
#' @return a data.frame containing the digitized data
#' @examples
#' \dontrun{
#' tmp <- tempfile()
#' png(tmp)
#' plot(rnorm(10) + 1:10, xlab="x", ylab="y")
#' dev.off()
#'
#' mydata <- digitize(tmp)
#' }
#' @export
digitize = function(image_filename,
                    ...,
                    x1 = NA,
                    x2 = NA,
                    y1 = NA,
                    y2 = NA) {
  pt_names <- c("x1", "x2", "y1", "y2")
  instructCal(pt_names)
  
  cal <- ReadAndCal(image_filename)
  
  if (any(is.na(get(pt_names)))) {
    ## I would abstract this into a seperate function but the assign
    ## below magics the vars x1, ..y2 into their appropriate vals
    ## and need to deal with environments to do that...
    point_vals <- getVals(pt_names)
    for (p in names(point_vals))
      assign(p, point_vals[[p]])
  }
  
  cat("\n\n")
  cat(
    "..............NOW .............",
    "Click all the data.",
    "Right click when done!",
    sep = "\n\n"
  )
  cat("\n\n")
  data <- DigitData(...)
  
  out <- Calibrate(data, cal, x1, x2, y1, y2)
  row.names(out) <- NULL
  return(out)
}

getVals <- function(names) {
  vals <- list()
  for (p in names) {
    bad <- TRUE
    while (bad) {
      input <- readline(paste("What is the value of", p, "?\n"))
      bad <- length(input) > 1
      if (bad) {
        cat("Error in input! Try again\n")
      } else {
        bad <- FALSE
      }
    }
    vals[[p]] <- as.numeric(input)
  }
  return(vals)
}

instructCal = function(pt_names) {
  # prints
  inst0 <-  "Use your mouse, and the image, but..."
  inst1 <-  "...careful how you calibrate."
  inst2  <- paste("Click IN ORDER:", paste(pt_names, collapse = ', '))
  add <- list()
  add[[1]] <- "
  |
  |
  |
  |
  |________x1__________________
  "
  add[[2]] <- "
  |
  |
  |
  |
  |_____________________x2_____
  \n"
  add[[3]] <- "
  |
  |
  |
  y1
  |____________________________
  \n"
  add[[4]] <- "
  |
  y2
  |
  |
  |____________________________
  \n"
  cat(paste(inst1, inst2, sep = '\n'))
  cat('\n\n')
  for (i in 1:4) {
    cat("    Step", i, '----> Click on', pt_names[i])
    cat(add[[i]], '\n')
  }
}
