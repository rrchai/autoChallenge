
#### Dockerize a Fake model ####

message("\n>>>>>>>>>> Dockerizing Model for Testing ... >>>>>>>>>>")
# dockerize a testing model
docker_name <- glue('testing-model-{eval_res[[2]]$id}:test')
invisible(system(
  glue(
    '
    cd {docker_dir};
    mkdir -p output;
    docker build -t {docker_name} .;
    docker run \\\
      -v {input_dir}/:/data:ro \\\
      -v $(pwd)/output:/output:rw \\\
      {docker_name};
    '
  )
))

#### Submit a Fake model ####

message("\n>>>>>>>>>> Submitting a Testing Model to Synapse ... >>>>>>>>>>")
message("Be patient. It may take a while ... ")
# submit the dockerized model
docker_submit_name <- glue(
  'docker.synapse.org/{project_ids$staging_projectid}/{docker_name}'
)
system(
  glue(
    '
    docker tag {docker_name} {docker_submit_name};
    docker login docker.synapse.org;
    docker push {docker_submit_name};
    docker ps -a | awk "{ print $1,$2 }" | grep {docker_name} | \ 
      awk "{print $1 }" | xargs -I {} docker rm {};
    docker image rm {docker_name} {docker_submit_name} 
    '
  )
)

# TODO: get docker repo entity id
# docker_id <- 
# submission <- synObj$submit(
#   evaluation = eval_res[[2]]$id,
#   entity = docker_id,
#   name = "test",
#   dockerTag = "latest"
# )
