library(tidyverse)
library(data.table)
library(socsci)
library(fixest)
library(ggeffects)
library(BrennanTools)
library(ivreg)
library(scales)
library(kableExtra)

options("modelsummary_format_numeric_latex" = "plain")

save <- c("db", "cleanup", "theme_bc", "save", "weighted.ttest.ci")

cleanup <- function(...){
  save2 <- c(save, ...)
  rm(list=ls(envir = .GlobalEnv)[! ls(envir = .GlobalEnv) %in% save2], envir = .GlobalEnv)
  gc()
}