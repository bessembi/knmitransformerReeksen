# ------------------------------------------------------------------------------
# Transform tg temperature
# ------------------------------------------------------------------------------


# Always use up to date package
install.packages("KNMI/knmitransformer")

library(purrr)
library(knmitransformer)

# Obtain the reference series used in the knmitransformer package
refData <- KnmiRefFile("KNMI14____ref_rrcentr___19810101-20101231_v3.2.txt")  

# Copy the file here for the sake of completeness
file.copy(refData, "rrlower/KNMI14____ref_rrlower.txt", overwrite = TRUE)


fn <- function(scenario, horizon) {
  filename <- "rrlower/KNMI14"
  if (horizon == 2030) {
    filename <- paste0(filename, "____2030")
  } else {
    filename <- paste0(filename, "_", scenario, "_", horizon)
  }
  filename <- paste0(filename, "_rrlower.txt")
  TransformPrecip(input = refData,
                scenario = scenario, horizon = horizon,
                subscenario = "lower",
                ofile = filename)
}

combinations <- expand.grid(scenario = c("GL", "GH", "WL", "WH"),
                            horizon = c(2050, 2085),
                            stringsAsFactors = FALSE)
combinations <- rbind(combinations, c("GL", 2030))


pwalk(combinations, fn)

