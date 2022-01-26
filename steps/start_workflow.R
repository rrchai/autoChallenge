
#### Config Workflow ####

message("\n>>>>>>>>>> Config Workflow ... >>>>>>>>>>")
# config workflow repo
workflow_cwl_path <- file.path(local_workflow_path, "workflow.cwl")
workflow_cwl <- updateWorkflow(
  cwl = workflow_cwl_path,
  gs_id = gs_file$id,
  admin_id = project_ids$admin_teamid,
  admin_team_id = project_ids$admin_teamid,
  input_dir = input_dir,
  file = workflow_cwl_path
)
# validate_cwl <- updateValidate()
# score_cwl <- updateScore()

# push changes in .cwl in develop branch
system(
  glue(
    '
    cd {local_workflow_path};
    git checkout develop --quiet;
    git add *.cwl;
    git commit -m "update .cwl" --quiet;
    git push origin develop;
    '
  )
)

# clone the SynapseWorkflowOrchestrator repo
system(
  glue(
    '
    cd {workflow_dir};
    git clone https://github.com/Sage-Bionetworks/SynapseWorkflowOrchestrator.git --quiet;
    '
  )
)
# config SynapseWorkflowOrchestrator repo
# {defaultQ: main, testQ: dev}
eval_template <- sprintf(
  '{"%s": "%s", "%s": "%s"}',
  eval_res[[1]]$id, workflow_files[[1]]$id,
  eval_res[[2]]$id, workflow_files[[2]]$id
)
# update .env
env$WORKFLOW_OUTPUT_ROOT_ENTITY_ID <- logs_folder$id
env$EVALUATION_TEMPLATES <- eval_template
# write out new .env
env_v <- sapply(seq_along(env), function(i) glue('{names(env[i])}={env[i]}'))
envFile <- file(glue('{workflow_dir}/SynapseWorkflowOrchestrator/.env'))
tryCatch(
  writeLines(env_v, envFile),
  finally = close(envFile)
)


#### Start Instance ####

message("\n>>>>>>>>>> Start Instance ... >>>>>>>>>>")
message("Be patient. It may take a while ... ")
system(
  glue(
    '
    cd {workflow_dir}/SynapseWorkflowOrchestrator/;
    docker-compose up -d;
    '
  )
)
