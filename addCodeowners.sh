helpFunction()
{
   echo ""
   echo "Usage: $0 -p ghPersonalAccessToken -t team-name -u user-name -o org -a azureWorkItemNumber"
   echo -e "\t-p provide a personal access token from your github account"
   echo -e "\t-t The github team name, such as 'flight-search' (do not include the '@')"
   echo -e "\t-u Your github username (do not include the '@')"
   echo -e "\t-o The github org where your team's repos can be found (such as, 'Alaska-ECommerce')"
   echo -e "\t-a The work item number to be added to your PR for AB Validation (such as '12345')"
   exit 1 # Exit script after printing help
}

while getopts p:t:u:o:a: opt
do
   case "$opt" in
      p ) PAT="$OPTARG" ;;
      t ) TEAM="$OPTARG" ;;
      u ) USERNAME="$OPTARG" ;;
      o ) ORG="$OPTARG" ;;
      a ) AB="$OPTARG" ;; 
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

echo $PAT $TEAM $USERNAME $ORG $AB

if [ -z "$PAT" ]; then
    echo "FAILURE: Missing PAT (personal access token)"
    exit 2;
fi
if [ -z "$TEAM" ]; then
    echo "FAILURE: Missing Team"
    exit 2;
fi
if [ -z "$USERNAME" ]; then
    echo "FAILURE: Missing Username"
    exit 2;
fi
if [ -z "$ORG" ]; then
    echo "FAILURE: Missing ORG"
    exit 2;
fi
if [ -z "$AB" ]; then
    echo "FAILURE: Missing AB (Azure Story Board number)"
    exit 2;
fi

mkdir "addCodeowners"
cd "./addCodeowners"

echo "Authenticating w/ PAT"

echo $PAT | gh auth login --with-token

echo "Cloning Team Repos"

repos=$(curl -u $TEAM:$PAT -s https://api.github.com/orgs/$ORG/teams/$TEAM/repos | sed 's/ //g')

for repo in $(echo "${repos}" | jq -c -r '.[]'); do
   name=$(echo $repo | jq -r '.name')
   url=$(echo $repo | jq -r '.clone_url')
   respCode1=$(curl --write-out "%{http_code}\n" --silent --output /dev/null -u $TEAM:$PAT -s https://api.github.com/repos/$ORG/$name/contents/CODEOWNERS)
   respCode2=$(curl --write-out "%{http_code}\n" --silent --output /dev/null -u $TEAM:$PAT -s https://api.github.com/repos/$ORG/$name/contents/docs/CODEOWNERS)
   respCode3=$(curl --write-out "%{http_code}\n" --silent --output /dev/null -u $TEAM:$PAT -s https://api.github.com/repos/$ORG/$name/contents/.github/CODEOWNERS)
  if [ $respCode1 = "200" ] || [ $respCode2 = "200" ] || [ $respCode3 = "200" ]; then
    echo "$name already contains a CODEOWNERS file"
  else
    git clone $url
  fi
   
done

echo "Repos cloned. Starting to add CODEOWNERS"

pr_list=()

for dir in ./* ; do
  if [ -d "$dir" ]; then
    dir=${dir%*/}
    mkdir -p ${dir##*/}/.github
    echo "# Default owners of everything (i.e. *) in the repository \n* @$ORG/$TEAM" > ./${dir##*/}/.github/CODEOWNERS
    echo "Updating $dir repo"
    cd ${dir##*/}
    git checkout -b $USERNAME/CODEOWNERS
    git add .
    git commit -m "Added CODEOWNERS file"
    git push origin $USERNAME/CODEOWNERS
    pr=$(gh pr create --title "Adding CODEOWNERS" --body "AB#$AB" --reviewer "@$ORG/$TEAM" 2>&1)
    echo $pr
    pr_list+=( "$pr" )
    cd ..
    echo "codeowners pushed to branch, $USERNAME/CODEOWNERS"
  fi
done

cd ..

printf '%b\n' "${pr_list[@]}"