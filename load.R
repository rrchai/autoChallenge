suppressPackageStartupMessages({
  library(reticulate)
  library(dplyr)
  library(glue)
  library(argparse)
})
use_condaenv("challenge_env", required = TRUE)
cu <- import("challengeutils")
syn <- import("synapseclient")
source_python("utils/updateWorkflow.py")
synObj <- syn$Synapse()

# read env variable
# readRenviron(".env")
env <- read.delim(".env", comment.char = "#", header = FALSE, sep = "=")
env <- setNames(as.list(env[[2]]), env[[1]])

# login to synapse
synObj$login(
  email = Sys.getenv("SYNAPSE_USERNAME"),
  password = Sys.getenv("SYNAPSE_PASSWORD"),
  silent = TRUE
)

source("utils/utils.R")

envFile <- file(".test")
tryCatch(
  writeLines(config, envFile),
  finally=close(envFile)
)