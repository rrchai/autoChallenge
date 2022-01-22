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

4.  Config `GitHub CLI` if you haven't ([gh manual](https://cli.github.com/manual/))

        gh auth login

## Usage

- `Rscript startChallenge.R -h`

        usage: startChallenge name [Options]
        
        Required:
          name        a challenge name
        
        Options:
          -h, --help  show this help message and exit
          -d          local directory to save workflow repo (default: '.')
