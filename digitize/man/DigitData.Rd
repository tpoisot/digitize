\name{DigitData}
\Rdversion{1.1} 
\alias{DigitData}
\title{Point data on an image}
\description{This function waits for the user to click the points of which he wants the coordinates}
\usage{ 
DigitData(col='red',type='p',...)
}

\arguments{
\item{col}{Color of the points}
\item{type}{Type of the points}
\item{...}{Other arguments for locator}
}

\value{
	\item{data}{A list with the coordinates of the points}
}