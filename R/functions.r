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

ReadImg <- function(fname)
{
  img <- readbitmap::read.bitmap(fname)
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


#' @export
digitize <- function(fname, x1, x2, y1, y2, ...)
{
  cat("You must start by clicking on the left-most x-axis point, then the right-most axis point, followed by the lower y-axis point and finally the upper y-axis point. You don’t need to choose the end points of the axis, only two points on the axis that you know the x or y value for. As you click on each of the 4 points, the coordinates are saved in the object cal.")
  calpoints <- ReadAndCal(fname)
  cat("Now you can click on each of the data points you’re interested in retrieving values for. The function will place a dot (colored red in this case) over each point you click on, and the raw x,y coordinates of that point will be saved to the data.points list. When you’re finished clicking points, you need to hit stop or right-click to stop the data point collection.")
  data <- DigitData()
  Calibrate(data, calpoints, x1, x2, y1, y2)
}



