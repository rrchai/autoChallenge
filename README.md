# autoChallenge

The goal of this project is to automate the steps of [DREAM Challenge Infrastructure](https://help.synapse.org/docs/Challenge-Infrastructure.2163409505.html) before our Challenge Platform is released. It will automatically create a Challenge and set up a basic testing infrastructure. With current codebase, it can support only `Model-to-Data` Challenges for now.

Here are some steps the `autoChallenge` will automatically do for you:

- Create challenge sites & teams
- Set up minimal requirements for infrastructure workflow:

  - Create a workflow template repo in both Github and local
  - Auto-config the [SynapseWorkflowOrchestrator] and [workflow template] repos (the changes of workflow will be pushed to its `develop` branch)
  - Start the [SynapseWorkflowOrchestrator] container in the background
  - Submit a simple dockerized model to test whether the infra setup works

- Send the user an email with most essential links
- Create a PR to update `main` branch of workflow repo

Each step will ask users for prompts (yes/no). One value you have to manually input for `autoChallenge` is the synapse entity Id of submitted docker repo (read [more](https://github.com/rrchai/autoChallenge#to-do)).

## Installation

1.  Set up a new Amazon linux environment (_**skip this step if you run locally**_):

        wget https://raw.githubusercontent.com/rrchai/autoChallenge/master/setup-instance.sh
        bash setup-instance.sh
        source ~/.bashrc

2.  Clone this repo :

        git clone https://github.com/rrchai/autoChallenge.git
        cd autoChallenge/

3.  Create and activate a conda environment:

        conda env create -f environment.yml
        conda activate challenge_env

4.  Install R packages (use `sudo` if cannot install R packages and it may take a while):

        (sudo) R -f install-pkgs.R

5.  Create and modify the configuration file (Synapse credentials are required, **password will not work with `apiKey` for now**):

        cp .envTemplate .env

6.  Follow the steps to config [GitHub CLI] if you haven't (press `enter` all the way and you will ask to authenticate Github CLI by pasting `one-time code` provided to Github website):

        gh auth login

## Usage

- Check the usage:

        Rscript autoChallenge.R -h

- Create a basic challenge:

        Rscript autoChallenge.R "<your-challenge-name>"

## TO-DO

- Get entity Id of submitted docker repo in the synapse in support of auto-submitting the model (wait to see the updates from this [jira ticket](https://sagebionetworks.jira.com/browse/PLFM-4898))
- Enable to use customizable validation/scoring scripts if needed
- Support `Data-to-Model` if needed

<!-- Links -->

[synapseworkfloworchestrator]: https://github.com/Sage-Bionetworks/SynapseWorkflowOrchestrator
[workflow template]: https://github.com/Sage-Bionetworks-Challenges/model-to-data-challenge-workflow
[github cli]: https://cli.github.com/manual/
