
## Create Projects and Teams

message("\n>>>>>>>>>> Create Challenge Sites and Teams... >>>>>>>>>>")
project_ids <- cu$createchallenge$main(synObj, "checkChallenge")


## Add Evaluation Queue
# by default, challengeultis creates one eval queue
# rename it to TEST
# adding new eval one with existing project will get below error:
#   Error in py_call_impl(callable, dots$args, dots$keywords) : 
#     SynapseHTTPError: 404 Client Error: 
#     No Evaluation found with name TEST

message("\n>>>>>>>>>> Adding a Testing Evaluation Queue ... >>>>>>>>>>")
test_eval <- syn$evaluation$Evaluation(
  name = "TEST Submission",
  description = "This is a testing evaluation queue",
  contentSource = project_ids$live_projectid
)
invisible(test_eval <- synObj$store(test_eval))
# get all eval queues (there should be two by now)
eval_res <- synObj$restGET(glue("/entity/{project_ids$live_projectid}/evaluation"))$results


## Add Submission View to Table ####

message("\n>>>>>>>>>> Creating Submission View Tables ... >>>>>>>>>>")
# submissionView <- lapply(eval_res, function(eval) {})
schema <- syn$SubmissionViewSchema(
  name = eval_res[[2]]$name,
  parent= project_ids$staging_projectid,
  scopes = list(eval_res[[2]]$id)
)
schema <- synObj$store(schema)


## Add the Goldstandard File

message("\n>>>>>>>>>> Uploading Goldstandard File ... >>>>>>>>>>")
# TO-DO: add validation to check if file exists and ask to overwrite?
# create folder to store data
data_folder <- syn$Folder('Data', parent = project_ids$staging_projectid)
invisible(data_folder <- synObj$store(data_folder))
# upload the goldstandard file
gs_name <- basename(gs_path)
gs_file <- syn$File(
  gs_path,
  name = gs_name,
  parent = data_folder$id
)
invisible(gs_file <- synObj$store(gs_file))