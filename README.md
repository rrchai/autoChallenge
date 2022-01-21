# challengeStarteR

The goal of this project is to automate the steps of [DREAM Challenge Infrastructure](https://help.synapse.org/docs/Challenge-Infrastructure.2163409505.html). With current codebase, it can automate the first six steps and support only `Model-to-Data` Challenges for now.

To be continued ...

## Installation

1.  Clone this repo :

        git clone https://github.com/rrchai/challengeStarteR.git

2.  Create and activate a conda environment:

        conda env create -f environment.yml
        conda activate challenge_env

3.  Install R packages:

        R -f install-pkgs.R

4.  Install and Config `GitHub CLI` if you haven't ([gh manual](https://cli.github.com/manual/))

        conda install gh --channel conda-forge
        gh auth login

## Usage

- arg1: string, challenge name
- arg2: string, ~/local/path/to/save/template. The default is used "./".

        Rscript startChallenge.R "Happy Challenge" "./"
