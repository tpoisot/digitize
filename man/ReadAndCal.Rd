\name{ReadAndCal}
\Rdversion{1.1} 
\alias{ReadAndCal}
\title{Read and calibrate a JPG graphic}
\description{This function loads the graphical file passed in argument, and allows the user to calibrate it using four points (x1,x2,y1,y2) by clicking the graph.}
\usage{ 
ReadAndCal(fname)
}

\arguments{
\item{fname}{Filename of the graphic to read}
}
 
\value{
	\item{calpoints}{List of the x and y coordinates of the calibration points}
}