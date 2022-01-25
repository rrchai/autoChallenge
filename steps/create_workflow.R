
#### Create Workflow Github Repo ####

message("\n>>>>>>>>>> Create Workflow Template Github Repos ... >>>>>>>>>>")
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
# TODO: figure out how gh repo create --clone work with -p
# wait 5s for now to let template downloading completes
Sys.sleep(5)
message(glue("Cloning '{remote_repo_url}' into '{workflow_dir}' ..."))
system(
  glue(
    '
    cd {workflow_dir};
    git clone {remote_repo_url} --quiet;
    '
  )
)

# create dev branch
system(
  glue(
    '
    cd {local_workflow_path};
    git checkout -B develop --quiet;
    git push origin develop;
    '
  )
)


#### Link Project to Workflow ####

message("\n>>>>>>>>>> Linking Project to Workflow ... >>>>>>>>>>")
# create Logs folder
logs_folder <- syn$Folder('Logs', parent = project_ids$live_projectid)
invisible(logs_folder <- synObj$store(logs_folder))
# create Infrastructure folder
infra_folder <- syn$Folder('Infrastructure', parent = project_ids$staging_projectid)
invisible(infra_folder <- synObj$store(infra_folder))
# link infra to staging site
workflow_files <- lapply(c("main", "develop"), function(branch) {
  remote_repo_zip <- file.path(remote_repo_url, glue("archive/refs/heads/{branch}.zip"))
  workflow_file <- syn$File(remote_repo_zip,
                            name = ifelse(branch == "main", "workflow", "TEST workflow"),
                            parent = infra_folder$id,
                            synapseStore = FALSE)
  workflow_file$annotations["ROOT_TEMPLATE"] <- glue("{folder_name}-{branch}/workflow.cwl")
  invisible(workflow_file <- synObj$store(workflow_file))
})
