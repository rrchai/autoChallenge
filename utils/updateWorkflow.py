import ruamel.yaml

dqString = ruamel.yaml.scalarstring.DoubleQuotedScalarString
yaml = ruamel.yaml.YAML()
yaml.preserve_quotes = True


def write_cwl(cwl, file):
    """read a .cwl file

    Args:
        cwl: .cwl file input
        file: output path to save cwl

    Returns:
        save a updated .cwl file to the defined path
    """
    with open(file, 'w') as cwl_file:
        yaml.indent(mapping = 2, sequence = 4, offset = 2)
        yaml.dump(cwl, cwl_file)


def updateWorkflow(cwl,
                   gs_id,
                   admin_id,
                   admin_team_id,
                   input_dir,
                   file="workflow.cwl"):
    """update workflow.cwl file

    Args:
        cwl: path to workflow.cwl
        gs_id: the Synapse ID of the Challenge's goldstandard
        admin_id: admin user ID
        admin_team_id: admin team ID
        input_dir: the absolute path to the data directory to be mounted during the container runs
        file: output path to save updated workflow (default: 'workflow.cwl')

    Returns:
        write out an updated workflow (.cwl)
    """
    with open(cwl, 'r') as cwl_file:
        f = yaml.load(cwl_file)
        f["steps"]["download_goldstandard"]["in"][0]["id"] = dqString(gs_id)
        f["steps"]["set_submitter_folder_permissions"]["in"][1]["id"] = dqString(admin_id)
        f["steps"]["set_admin_folder_permissions"]["in"][1]["id"] = dqString(admin_team_id)
        f["steps"]["run_docker"]["in"][9]["valueFrom"] = dqString(input_dir)

    write_cwl(f, file)


# def updateValidate(cwl,
#                    file="validate.cwl"):
#     """update validate.cwl file

#     Args:

#     Returns:
#         write out an updated validate (.cwl)
#     """
#     with open(cwl, 'r') as cwl_file:
#         f = yaml.load(cwl_file)

#     write_cwl(f, file)


# def updateScore(cwl,
#                 file="score.cwl"):
#     """update score.cwl file

#     Args:

#     Returns:
#         write out an updated score (.cwl)
#     """
#     with open(cwl, 'r') as cwl_file:
#         f = yaml.load(cwl_file)

#     write_cwl(f, file)
