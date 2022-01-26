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
# synObj$login(
#   email = Sys.getenv("SYNAPSE_USERNAME"),
#   password = Sys.getenv("SYNAPSE_PASSWORD"),
#   silent = TRUE
# )

env <- read.delim(".env", comment.char = "#", header = FALSE, sep = "=")
env <- setNames(as.list(env[[2]]), env[[1]])

for (var in c("SYNAPSE_USERNAME", "SYNAPSE_USERNAME")) {
  if (is.null(env[var]) || nchar(env[var]) == 0) {
    stop(sprintf("'%s' you provided is empty", var))
  }
}

# login to synapse
synObj$login(
  email = env$SYNAPSE_USERNAME,
  password = env$SYNAPSE_PASSWORD,
  silent = TRUE
)

source("utils/utils.R")
