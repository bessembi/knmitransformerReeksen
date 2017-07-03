# ------------------------------------------------------------------------------
# Transform tg temperature
# ------------------------------------------------------------------------------


# Always use up to date package
install.packages("KNMI/knmitransformer")

library(purrr)
library(knmitransformer)

# Obtain the reference series used in the knmitransformer package
refDataTg <- KnmiRefFile("KNMI14____ref_tg___19810101-20101231_v3.2.txt")  
refDataRsds <- KnmiRefFile("KNMI14____ref_rsds___19810101-20101231_v3.2.txt")  

# Copy the file here for the sake of completeness
file.copy(refDataTg, "evmk/KNMI14____ref_tg.txt", overwrite = TRUE)


regions <- MatchRegionsOnStationId(ReadInput("tg", refDataTg)$header[1, -1])

fn <- function(scenario, horizon) {
  filename <- "evmk/KNMI14"
  if (horizon == 2030) {
    filename <- paste0(filename, "____2030")
  } else {
    filename <- paste0(filename, "_", scenario, "_", horizon)
  }
  filename <- paste0(filename, "_evmk.txt")
  TransformEvap(refDataTg, refDataRsds,
                scenario = scenario, horizon = horizon,
                regions = regions, ofile = filename)
}

combinations <- expand.grid(scenario = c("GL", "GH", "WL", "WH"),
                            horizon = c(2050, 2085),
                            stringsAsFactors = FALSE)
combinations <- rbind(combinations, c("GL", 2030))


pwalk(combinations, fn)

