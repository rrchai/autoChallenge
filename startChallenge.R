source("load.R")

#### Set Arguments ####
parser <- ArgumentParser(prog = "startChallenge", 
                         usage = '%(prog)s name [Options]',
                         add_help = FALSE)
reqArgs <- parser$add_argument_group("Required")
optArgs <- parser$add_argument_group("Options")
reqArgs$add_argument("name", metavar = "name",
                     type = "character",
                     help = "a challenge name")
optArgs$add_argument("-h", "--help", action = "help",
                     help="show this help message and exit")
optArgs$add_argument("-d", metavar = "",
                     type = "character", default = ".",
                     help = "local directory to save workflow repo (default: '.')")
args <- parser$parse_args()

# read input
challenge_name <- args[[1]]
local_dest <- args[[2]]

#### Set Path ####
system(sprintf("mkdir -p %s", local_dest))
# create the template repo name,
# e.g. 'happy challenge' will be use 'happy-challenge-infra' as repo name
folder_name <- trimws(challenge_name, "both") %>%
  gsub(" ", "-", .) %>%
  gsub("-+", "-", .) %>%
  paste0("-Infra")

local_folder_path <- file.path(local_dest, folder_name)

#### Create Sits and Teams ####
message(">>>>>>>>>> Create Challenge Sites and Teams... >>>>>>>>>>")
project_ids <- cu$createchallenge$main(synObj, challenge_name)

#### Add Evaluation Queue ####
message(">>>>>>>>>> Adding a Testing Evaluation Queue ... >>>>>>>>>>")
# by default, challengeultis creates one eval queue
# add another one for testing
test_eval <- syn$Evaluation(
  name = "TEST Q1",
  description = "This is an evaluation queue testing purpose",
  contentSource = project_ids$live_projectid
)
invisible(test_eval <- synObj$store(test_eval))

# get all queues (there should be two by now)
eval_res <- synObj$restGET(glue("/entity/{project_ids$live_projectid}/evaluation"))$results

#### Add Submission View to Table ####
message(">>>>>>>>>> Creating Submission View Tables ... >>>>>>>>>>")
submissionView <- lapply(eval_res, function(eval) {

  schema <- syn$SubmissionViewSchema(name = eval$name,
                                     parent= project_ids$staging_projectid ,
                                     scopes = list(eval$id))
  schema <- synObj$store(schema)
})


#### Create Workflow Template ####
message(">>>>>>>>>> Create Workflow Template Github Repos ... >>>>>>>>>>")
# only work for model-to-data now
template_name <- ifelse(
  # TO-DO: support data-to-model
  as.logical(TRUE),
  "model-to-data-challenge-workflow",
  "data-to-model-challenge-workflow"
  )
template_url <- paste0("https://github.com/Sage-Bionetworks-Challenges/", template_name)

remote_repo_url <- system(intern = TRUE,
  glue('gh repo create {folder_name} -p {template_url} --public;')
)

# clone the repo
message(glue("Cloning '{remote_repo_url}' into '{local_dest}' ..."))
system(
  glue(
    '
    cd {local_dest};
    git clone {remote_repo_url} --quiet;
    '
  )
)

# create dev branch
message(glue("Creating 'develop' branch ..."))
invisible(system(
  glue(
    '
    cd {local_folder_path};
    git checkout -B develop --quiet;
    git push origin develop --quiet;
    '
  )
))

#### Link Project to Workflow ####
message(">>>>>>>>>> Linking Project to Workflow ... >>>>>>>>>>")
# create log files
logs_folder <- syn$Folder('Logs', parent = project_ids$live_projectid)
invisible(logs_folder <- synObj$store(logs_folder))

# link infra to staging site
workflow_folder <- syn$Folder('infrastructure', parent = project_ids$staging_projectid)
invisible(workflow_folder <- synObj$store(workflow_folder))

workflow_files <- lapply(c("main", "develop"), function(branch) {
  remote_repo_zip <- file.path(remote_repo_url, glue("archive/refs/heads/{branch}.zip"))
  workflow_file <- syn$File(remote_repo_zip,
                            name = ifelse(branch == "main", "workflow", "TEST workflow"),
                            parent = workflow_folder$id,
                            synapseStore = FALSE)
  workflow_file$annotations["ROOT_TEMPLATE"] <- glue("{folder_name}-{branch}/workflow.cwl")
  invisible(workflow_file <- synObj$store(workflow_file))
})

#### Add Temporary Testing Files ####
# message("Create Testing Files ... ")
# # goldstandard file
# data_folder <- syn$Folder('Data', parent = project_ids$staging_projectid)
# invisible(data_folder <- synObj$store(data_folder))
#
# gs <- data.frame(test = 1:10, prediction = sample(c(0, 1), 10, replace = TRUE))
# write.csv(gs, "goldstandard.csv", row.names = FALSE)
# gs_file <- syn$File("goldstandard.csv",
#                     name = "goldstandard.csv",
#                     parent = data_folder$id)
# gs_file <- synObj$store(gs_file)
#
# input_data <- data.frame(test = 1:10, feature = sample(1:100, 10, replace = TRUE))
# write.csv(input_data, "input_data.csv", row.names = FALSE)

#### Config Workflow ####
# {defaultQ: main, testQ: dev}
eval_template <- sprintf(
  '{"%s": "%s", "%s": "%s"}',
  eval_res[[1]]$id, workflow_files[[1]]$id,
  eval_res[[2]]$id, workflow_files[[2]]$id
)

message("\n\n")
message("==================================================")
message("========= output for workflow config =============")
message(glue(
  '
  WORKFLOW_OUTPUT_ROOT_ENTITY_ID={logs_folder$id}
  EVALUATION_TEMPLATES={eval_template}
  '
))
message("==================================================")
message("==================================================")