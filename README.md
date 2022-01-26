# autoChallenge

The goal of this project is to automate the steps of [DREAM Challenge Infrastructure](https://help.synapse.org/docs/Challenge-Infrastructure.2163409505.html). With current codebase, it can support only `Model-to-Data` Challenges for now.

Here are some steps the `autoChallenge` will automatically do for you:

- Create challenge sites & teams
- Set up minimal requirements for infrastructure workflow:

  - Create a workflow template repo in both Github and local
  - Auto-config the [SynapseWorkflowOrchestrator] and [workflow template] repos (the changes of workflow will be pushed to its `develop` branch)
  - Start the [SynapseWorkflowOrchestrator] container in the background
  - Submit a simple dockerized model to test whether the infra setup works
- Send the user an email with most essential links
- Create a PR to update `main` branch of workflow repo

Each step will ask users for prompts (yes/no). `autoChallenge` is still in the testing phase and has not yet been tested by others except myself.


## Installation

1.  Clone this repo :

        git clone https://github.com/rrchai/challengeStarteR.git

2.  Create and activate a conda environment:

        conda env create -f environment.yml
        conda activate challenge_env

3.  Install R packages:

        R -f install-pkgs.R

4. Create and modify the configuration file:

        cp .envTemplate .env

5.  Config [GitHub CLI] if you haven't:

        gh auth login

## Usage

- Check the usage:

        Rscript autoChallenge.R -h

- Create a basic challenge:

        Rscript autoChallenge.R "<your-challenge-name>"

## TO-DO

- Get entity Id of submitted docker repo in the synapse in support of auto-submitting the model (wait to see the updates from this [jira ticket](https://sagebionetworks.jira.com/browse/PLFM-4898))
- Enable auto create a challenge in a linux environment assuming a SC instance (test `setup-instance.sh`)
- Enable to use customizable validation/scoring scripts if needed
- Support `Data-to-Model` if needed

<!-- Links -->

[synapseworkfloworchestrator]: https://github.com/Sage-Bionetworks/SynapseWorkflowOrchestrator
[workflow template]: https://github.com/Sage-Bionetworks-Challenges/model-to-data-challenge-workflow
[github cli]: https://cli.github.com/manual/
