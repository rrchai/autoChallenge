
#### Dockerize a Fake model ####

message("\n>>>>>>>>>> Dockerizing Model for Testing ... >>>>>>>>>>")
# dockerize a testing model
docker_name <- glue('testing-model-{eval_res[[2]]$id}')
docker_tag <- "test"
docker_image_name <- glue('{docker_name}:{docker_tag}')
invisible(system(
  glue(
    '
    cd {docker_dir};
    mkdir -p output;
    docker build -t {docker_image_name} .;
    docker run \\\
      -v {input_dir}/:/data:ro \\\
      -v $(pwd)/output:/output:rw \\\
      {docker_image_name};
    '
  )
))

#### Submit a Fake model ####

message("\n>>>>>>>>>> Submitting a Testing Model to Synapse ... >>>>>>>>>>")
message("Be patient. It may take a while ... ")
# submit the dockerized model
docker_repo_name <- glue('docker.synapse.org/{project_ids$staging_projectid}/{docker_name}')
docker_submit_name <- glue('{docker_repo_name}:{docker_tag}')
rm_container <- sprintf("docker ps -a | awk '{ print $1,$2 }' | grep %s | \ 
                        awk '{ print $1 }' | xargs -I {} docker rm -f {} ", 
                        docker_name)
system(
  glue(
    "
    docker tag {docker_image_name} {docker_submit_name};
    docker login docker.synapse.org -u {env$SYNAPSE_USERNAME} -p {env$SYNAPSE_PASSWORD};
    docker push {docker_submit_name};
    {rm_container};
    docker image rm {docker_image_name} {docker_submit_name} 
    "
  )
)

# TODO: get docker repo entity id automatically
# eyeing this ticket: https://sagebionetworks.jira.com/browse/PLFM-4898
# for now, need to take users input to get entity id
docker_url <- glue('https://www.synapse.org/#!Synapse:{project_ids$staging_projectid}/docker/')
message(glue("Go to the docker repo at {docker_url}"))
message("Enter the entity Id of docker repo:")
docker_id <- readLines("stdin", n = 1)
# submit the model
submission <- synObj$submit(
  evaluation = eval_res[[2]]$id,
  entity = docker_id,
  name = "initial test",
  dockerTag = docker_tag
)
