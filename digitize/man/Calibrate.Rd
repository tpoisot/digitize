\name{Calibrate}
\Rdversion{1.1} 
\alias{Calibrate}
\title{Calibrate the data acquired from an image}
\description{This function corrects the data according to the calibration information.}
\usage{ 
Calibrate(data,calpoints,x1,x2,y1,y2)
}

\arguments{
\item{data}{A list of digitized values}
\item{calpoints}{A list of coordinates of the calibration points}
\item{x1}{X-coordinate of the leftmost x point (corrected)}
\item{x2}{X-coordinate of the rightmost x point (corrected)}
\item{y1}{Y-coordinate of the lower y point (corrected)}
\item{y2}{Y-coordinate of the upper y point (corrected)}
}

\value{
	\item{data}{A data frame with the corrected coordinates of the points}
}