# add-codeowners-github

It will create a new subdirectory & will clone fresh repos owned by the team/org combo provided (this is only executed if a CODEOWNERS file does not exist), create a new branch, add the codeowners file, & post a PR.

The end of the script will print a list of open PRs.

## Prerequisites

To run this script, you will need to install the github cli & jq.

Installation instructions for the github cli can be found here:
https://github.com/cli/cli

We use the github cli to create the PR and we are assuming that the git cli is already installed on your machine (please install it if it is not)! :)

Installation instructions for jq can be found here:
https://stedolan.github.io/jq/

JQ is a lightweight and flexible command-line JSON processor that we use to parse the response from the github APIs.

### Windows Users

To run this script on windows, you will need to use WSL.
https://docs.microsoft.com/en-us/windows/wsl/install

Once you have installed WSL, run the following steps in your linux terminal
  1. Install brew: `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
  2. Install git, gh, & jq
      - `brew install git`
      - `brew install gh`
      - `brew install jq`
  3. Configure [Git config file](https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-git#git-config-file-setup)
      - `git config --global user.email "you@example.com"`
      - `git config --global user.name "Your Name"`
  4. Configure [Git Credential Manager](https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-git#git-credential-manager-setup)
      - `git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe"`
  5. Clone the script repo **using https**
      - `git clone https://github.com/diana-dipalma/add-codeowners-github.git`
      - Make sure the script has permission to execute
      - Make sure you clone the repo using WSL
  
## Running The Script
Execute the following line (replace the variables with your personal/team specific information and make sure your arguments are wrapped in quotes), ``source ./addCodowners.sh -p '$PAT' -u '$USERNAME' -t '$TEAM' -o '$ORG' -a '$AB'``

All of the following arguments are required:
 - -p takes your PAT (you will need to make sure you have authorized access to the Alaska-ECommerce org in GitHub)
 - -u takes the username you use for github
 - -t takes your team name (do not include the '@')
 - -o takes the org name (this is 'Alaska-ECommerce' in most cases)
 - -a takes the azure work item (only the numbers)
