library(digitize)

context("Reverse compatibility")
cal <- structure(list(x = c(0.792661997863335, 0.280035277451617, 0.152293343886237,
                            0.155611316186637), y = c(0.24677019824852, 0.258509328506999,
                            0.375900631091784, 0.726397520237787)), .Names = c("x", "y"))

data.points <- structure(list(x = c(0.371279515712602, 0.465841726273987, 0.535519144582376,
                                    0.646671216645758, 0.732938496456145, 0.782708080962137), y = c(0.394347835783679,
                                    0.449689449859364, 0.503354045326694, 0.603975161827939, 0.696211185287414,
                                    0.749875780754744)), .Names = c("x", "y"))
df_reference <- structure(list(x = c(0.346601941747573, 0.29126213592233, 0.250485436893204,
                                     0.185436893203883, 0.134951456310679, 0.105825242718446), y = c(0.031578947368421,
                                     0.126315789473684, 0.218181818181818, 0.390430622009569, 0.548325358851675,
                                     0.640191387559809)), .Names = c("x", "y"), row.names = c(NA,
                               -6L), class = "data.frame")
pts_reference <- c(x1=0.1, x2=0.4, y1=0.0, y2=0.6)

silence_output <- function(code){
  out <- evaluate_promise(code)
  out$result
}

test_that("Old calibrate works", {
            p <- pts_reference
            df <- Calibrate(data.points, cal, p["x1"], p["x2"], p["y1"], p["y2"])

            expect_equal(df, df_reference)
})
test_that("`digitize` gives same", {
            p <- pts_reference
            out <- with_mock(getVals=function(...) stop(points_error),
                             instructCal=function(...){},
                             ReadAndCal=function(...) return(cal),
                             DigitData=function(...) return(data.points),
                             silence_output(digitize('test', x1=p["x1"], x2=p["x2"],
                                                     y1=p["y1"], y2=p["y2"])), 
                             .env="digitize")
            expect_equivalent(out, df_reference)
})
