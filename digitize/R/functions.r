ReadAndCal = function(fname)
{
	img <- read.jpeg(fname)
	plot(img)
	calpoints <- locator(n=4,type='p',pch=4,col='blue',lwd=2)
	return(calpoints)
}

ReadImg = function(fname)
{
	img <- read.jpeg(fname)
	plot(img)
}

DigitData = function(col='red',type='p',...)
{
	type <- ifelse(type=='b','o',type)
	type <- ifelse(type%in%c('l','o','p'),type,'p')
	locator(type=type,col=col,...)
}

Calibrate = function(data,calpoints,x1,x2,y1,y2)
{
	x 		<- calpoints$x[c(1,2)]
	y 		<- calpoints$y[c(3,4)]

	cx <- lm(formula = c(x1,x2) ~ c(x))$coeff
	cy <- lm(formula = c(y1,y2) ~ c(y))$coeff

	data$x <- data$x*cx[2]+cx[1]
	data$y <- data$y*cy[2]+cy[1]

	return(as.data.frame(data))
}