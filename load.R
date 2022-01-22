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
source_python("updateWorkflow.py")
synObj <- syn$Synapse()

# read env variable
readRenviron(".env")
# login to synapse
message(">>>>>>>>>> Synapse Account Used to Create the Challenge: '", 
        Sys.getenv("SYNAPSE_USERNAME"), "' ... >>>>>>>>>>")
synObj$login(
  email = Sys.getenv("SYNAPSE_USERNAME"),
  apiKey = Sys.getenv("SYNAPSE_PASSWORD"),
  silent = TRUE
)
