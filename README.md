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

## Running The Script
Execute the following line (replace the variables with your personal/team specific information and make sure your arguments are wrapped in quotes), ``source ./addCodowners.sh -p '$PAT' -u '$USERNAME' -t '$TEAM' -o '$ORG' -a '$AB'``

All of the following arguments are required:
 - -p takes your PAT (you will need to make sure you have authorized access to the Alaska-ECommerce org in GitHub)
 - -u takes the username you use for github
 - -t takes your team name (do not include the '@')
 - -o takes the org name (this is 'Alaska-ECommerce' in most cases)
 - -a takes the azure work item (only the numbers)