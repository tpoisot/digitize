library(digitize)

silence_output <- function(code){
  out <- evaluate_promise(code)
  out$result
}
context("Unit tests in digitize")
test_that("Digitize skips point input", {
            out <- with_mock(getVals=function(...) stop(points_error),
                             instructCal=function(...){},
                             ReadAndCal=function(...) return(5),
                             DigitData=function(...) return(5),
                             Calibrate=function(...) return(FALSE),
                             silence_output(digitize('test', x1=2, x2=2, y1=2, y2=2)),
                             .env="digitize")
            expect_false(out)

            points_error <- "Evaluated pts!"
            expect_error(with_mock(getVals=function(...) stop(points_error),
                                   instructCal=function(...){},
                                   ReadAndCal=function(...) return(5),
                                   DigitData=function(...) return(5),
                                   Calibrate=function(...) return(FALSE),
                                   silence_output(digitize('test')),
                                   .env="digitize"),
                         points_error)
})
