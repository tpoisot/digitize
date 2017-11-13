#' (deprecated) Read image and calibrate
#' @param fname Filename of the graphic to read
#' @details deprecated, use \code{\link{digitize}} instead. Called for side effect of user locating points. See
#' `graphics::locator` for more. Usage explained at
#' http://lukemiller.org/index.php/2011/06/digitizing-data-from-old-plots-using-digitize/
#' @return `calpoints` List of the x and y coordinates of the calibration points
#' @examples
#' \dontrun{ReadAndCal(fname)}
#' @importFrom graphics locator
#' @export
ReadAndCal <- function(fname, twopoints = F)
{
  ReadImg(fname)
  if (twopoints) {
    # only collect two points (left-bottom and top-right)
    calpoints <- locator(
      n = 2,
      type = 'p',
      pch = 4,
      col = 'blue',
      lwd = 2
    )
  } else {
    calpoints <- locator(
      n = 4,
      type = 'p',
      pch = 4,
      col = 'blue',
      lwd = 2
    )
  }
  return(calpoints)
}

#' @importFrom graphics plot.new par rasterImage
#' @importFrom readbitmap read.bitmap
ReadImg <- function(fname)
{
  img <- readbitmap::read.bitmap(fname)
  op <- par(mar = c(0, 0, 0, 0))
  on.exit(par(op))
  plot.new()
  rasterImage(img, 0, 0, 1, 1)
}

#' (deprecated) Mark the data on an image
#' @param col color of marker as in `par`
#' @param type shape of marker as in `par`
#' @param ... other args for `locator`
#' @details deprecated, use \code{\link{digitize}} instead. This function waits for the user to click the points of
#' the coordinates. See `graphics::locator` for more. Usage explained at
#' http://lukemiller.org/index.php/2011/06/digitizing-data-from-old-plots-using-digitize/
#' @return `data` A list with the coordinates of the points
#' @importFrom graphics locator
#' @export
DigitData <- function(col = 'red', type = 'p', ...)
{
  type <- ifelse(type == 'b', 'o', type)
  type <- ifelse(type %in% c('l', 'o', 'p'), type, 'p')
  locator(type = type, col = col, ...)
}

#' (deprecated) Digitize the data
#' @param data output of `DigitData`
#' @param calpoints output of `ReadAndCal`
#' @param x1 X-coordinate of the leftmost x point (corrected)
#' @param x2 X-coordinate of the rightmost x point (corrected)
#' @param y1 Y-coordinate of the lower y point (corrected)
#' @param y2 Y-coordinate of the upper y point (corrected)
#' @details deprecated, use \code{\link{digitize}} instead. This function corrects the data according to the
#' calibration information. Usage further explained at
#' http://lukemiller.org/index.php/2011/06/digitizing-data-from-old-plots-using-digitize/
#' @return `data` A data frame with the corrected coordinates of the points
#' @examples
#' \dontrun{Calibrate(data,calpoints,x1,x2,y1,y2)}
#' @importFrom stats lm
#' @export
Calibrate <- function(data, calpoints, x1, x2, y1, y2, twopoints = F)
{
  if (twopoints) {
    # only two points passed, use x and y from both
    x 		<- calpoints$x[c(1, 2)]
    y 		<- calpoints$y[c(1, 2)]
  } else {
    x 		<- calpoints$x[c(1, 2)]
    y 		<- calpoints$y[c(3, 4)]
  }
  
  cx <- lm(formula = c(x1, x2) ~ c(x))$coeff
  cy <- lm(formula = c(y1, y2) ~ c(y))$coeff
  
  data$x <- data$x * cx[2] + cx[1]
  data$y <- data$y * cy[2] + cy[1]
  
  return(as.data.frame(data))
}

getVals <- function(names) {
  vals <- list()
  for (p in names) {
    bad <- TRUE
    while (bad) {
      input <- readline(paste("What is the return of", p, "?\n"))
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

instructCal = function(pt_names, twopoints=F) {
  # prints
  inst0 <-  "Use your mouse, and the image, but..."
  inst1 <-  "...careful how you calibrate."
  inst2  <- paste("Click IN ORDER:", paste(pt_names, collapse = ', '))
  add <- list()
  if (twopoints) {
    add[[1]] <- "
    |
    |
    |
    y1
    |______x1____________________
    "
    add[[2]] <- "
    |
    y2
    |
    |
    |_____________________x2_____
    \n"
  } else {
    
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
  }
  cat(paste(inst1, inst2, sep = '\n'))
  cat('\n\n')
  for (i in seq(1,length(pt_names))) {
    cat("    Step", i, '----> Click on', pt_names[i])
    cat(add[[i]], '\n')
  }
}





#' digitize an image
#'
#' @param image_filename the image file you wish to digitze
#' @param x1 (optional) left-most x-axis point
#' @param x2 (optional) right-most axis point
#' @param y1 (optional) the lower y-axis point
#' @param y2 (optional) the upper y-axis point
#' @param twopoints (optional) if true calibrate with two points instead of four. Defaults to FALSE.
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
#'          only two points for which you know the x or y return.
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
#' @importFrom utils flush.console
#' @export
digitize <- function(image_filename,
                    ...,
                    x1,
                    x2,
                    y1,
                    y2,
                    twopoints = F) {
  if (twopoints) {
    pt_names <- c("x1y1", "x2y2")
    instructCal(pt_names, twopoints = twopoints)
    flush.console()
    
  } else {
    pt_names <- c("x1", "x2", "y1", "y2")
    instructCal(pt_names, twopoints = twopoints)
    flush.console()
  }
  
  cal <- ReadAndCal(image_filename, twopoints = twopoints)
  
  if (twopoints) {
    # can pass only partial limits to digitize function, and get the rest from user input
    if (missing(x1)) {
      x1 <- getVals('x1')[['x1']]  }
    if (missing(x2)) {
      x2 <- getVals('x2')[['x2']]  }
    if (missing(y1)) {
      y1 <- getVals('y1')[['y1']]  }
    if (missing(y2)) {
      y2 <- getVals('y2')[['y2']]  }
  } else {
    missing_pt <- missing(x1) | missing(x2) | missing(y1) | missing(y2)
    if (missing_pt) {
      ## I would abstract this into a seperate function but the assign
      ## below magics the vars x1, ..y2 into their appropriate vals
      ## and need to deal with environments to do that...
      point_vals <- getVals(pt_names)
      for (p in names(point_vals))
        assign(p, point_vals[[p]])
    }
  }
  
  cat("\n\n")
  cat(
    "..............NOW .............",
    "Click all the data. (Do not hit ESC, close the window or press any mouse key.)",
    "Once you are done - exit:",
    " - Windows: right click on the plot area and choose 'Stop'!",
    " - X11: hit any mouse button other than the left one.",
    " - quartz/OS X: hit ESC",
    sep = "\n\n"
  )
  cat("\n\n")
  flush.console()
  
  data <- DigitData(...)
  
  out <- Calibrate(data, cal, x1, x2, y1, y2, twopoints = twopoints)
  row.names(out) <- NULL
  return(out)
}
