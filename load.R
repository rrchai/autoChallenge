library(reticulate)
library(dplyr)
library(glue)
use_condaenv("synapse")
cu <- import("challengeutils")
syn <- import("synapseclient")
synObj <- syn$Synapse()
synObj$login(silent = TRUE)

# install gh CLI
# system("conda install -y gh --channel conda-forge")
# # config gh
# system("gh auth login -w")
