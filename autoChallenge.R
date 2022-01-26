# usage:

#### Set Arguments ####

parser <- argparse::ArgumentParser(prog = "Rscript autoChallenge.R", usage = '%(prog)s name [-h] [Args]')
reqArgs <- parser$add_argument_group("Required")
optArgs <- parser$add_argument_group("Options")
reqArgs$add_argument("name", metavar = "name",
                     type = "character",
                     help = "a challenge name")
optArgs$add_argument("-o", metavar = "",
                     type = "character", default = "./",
                     help = "local directory to save workflow repo (default: './')")
optArgs$add_argument("-g", metavar = "",
                     type = "character", default = "test/data/goldstandard.csv",
                     help = "path to goldstandard file (Default will be to use the testing file in 'test/')")
optArgs$add_argument("-i", metavar = "",
                     type = "character", default = "test/data/input_data.csv",
                     help = "path to input data's directory (Default will be to use the testing file in 'test/')")
optArgs$add_argument("-d", metavar = "",
                     type = "character", default = "test/",
                     help = "path to model's directory (default: 'test/')")
args <- parser$parse_args()

# read input
challenge_name <- args$name
workflow_dir <- args$o
gs_path <- args$g
input_path <- tools::file_path_as_absolute(args$i)
input_dir <- dirname(input_path)
docker_dir <- args$d
# validations

if (!file.exists(gs_path)) stop(sprintf("'%s': No such file", gs_path))
if (length(list.files(input_dir)) == 0) stop(sprintf("'%s' is an empty folder", input_dir))
if (!file.exists(file.path(docker_dir, "Dockerfile"))) stop(sprintf("No Dockerfile in '%s'", docker_dir))


#### Load Packages and Login to Synapse  ####

source("load.R")

confirm(
  sprintf(
    "Do you argee to use '%s' as the synapse account to create the Challenge ?",
    Sys.getenv("SYNAPSE_USERNAME")
  )
)


#### Set Variables and Paths ####

#create a dir for workflow repo if not exist
system(sprintf("mkdir -p %s", workflow_dir))

# create the template repo name,
# e.g. 'happy challenge' will be used 'happy-challenge-infra' as repo name
folder_name <- trimws(challenge_name, "both") %>%
  gsub("[^[:alnum:] -]", "", .) %>%
  gsub(" ", "-", .) %>%
  paste0("-Infra") %>%
  gsub("-+", "-", .)

# full local path to workflow repo
local_workflow_path <- file.path(workflow_dir, folder_name)

#### Create sites ####

source("steps/create_sites.R")


#### Create Workflow ####

source("steps/create_workflow.R")


#### Start Workflow ####

confirm("Do you argee to auto config and start the workflow for you ?")
source("steps/start_workflow.R")


#### Submit a Testing Model ####

confirm("Do you argee to submit a model to test infra for you ?")
source("steps/submit_models.R")


#### Send Email with Links ####

confirm("Do you argee to email the links of this challenge to you ?")
msg <- glue(
  '
  Hello {synObj$username},<br>
  <ul>
    <li>
      <a href="{project_ids$staging_projectid}" target="_blank">Staging Site</a>
    </li>
    <li>
      <a href="{project_ids$live_projectid}" target="_blank">Live Site</a>
    </li>
    <li>
      <a href="https://www.synapse.org/#!TeamSearch:{challenge_name}" 
        target="_blank">Teams
      </a>
    </li>
    <li>
      <a href="https://www.synapse.org/#!Synapse:{schema$id}/tables/" 
        target="_blank">Submission View
      </a>
    </li>
    <li>
      <a href="{remote_repo_url}" target="_blank">Workflow Github Repo</a>
    </li>
  </ul>
  '
)
user_id <- synObj$getUserProfile(synObj$username)["ownerId"]
invisible(
  synObj$sendMessage(
    userIds = list(user_id), 
    messageSubject = glue("Links - {challenge_name}"),
    messageBody = msg, 
    contentType = "text/html"
  )
)


#### Create a PR to Update Main ####

confirm("Do you argee to create a PR to update 'main' branch of the workflow repo?")
system(
  '
  gh pr create -a @me -B main -H develop -t "Update Main Branch" -b "Update *.cwl"
  '
)
message(sprintf(
  '
  (๑ᵔ⌔ᵔ๑)\n
  Congratulations !!! %s has been set up !\n
  Please check your email for more details.\n
  Thank you!\n
  (*^_^*)
  ', challenge_name
))
