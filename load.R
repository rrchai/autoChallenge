suppressPackageStartupMessages({
  library(reticulate)
  library(dplyr)
  library(glue)
  library(argparse)
  library(yaml)
})
use_condaenv("challenge_env", required = TRUE)
cu <- import("challengeutils")
syn <- import("synapseclient")
source_python("utils/updateWorkflow.py")
synObj <- syn$Synapse()

# read env variable
readRenviron(".env")
# login to synapse
synObj$login(
  email = Sys.getenv("SYNAPSE_USERNAME"),
  apiKey = Sys.getenv("SYNAPSE_PASSWORD"),
  silent = TRUE
)

source("utils/utils.R")
