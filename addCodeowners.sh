brew install gh
brew install git-lfs
brew install ruby

PAT=""
TEAM="flight-search"
USERNAME="diana-dipalma"
ORG="Alaska-ECommerce"
AB="11111"


mkdir "addCodeowners"
cd "./addCodeowners"

echo "Authenticating w/ PAT"

echo $PAT > ./pat.txt
gh auth login --with-token < pat.txt

echo "Cloning Team Repos"

#ruby sucks (python map method)
$(curl -u $TEAM:$PAT -s https://api.github.com/orgs/$ORG/teams/$TEAM/repos | ruby -e 'require "json"; JSON.load(STDIN.read).each { |repo| %x[git lfs clone #{repo["clone_url"]} ]}')

echo "Repos cloned. Starting to add CODEOWNERS"

pr_list=()

for dir in ./* ; do
  if [ -d "$dir" ]; then
    dir=${dir%*/}

    echo $dir
    if [ $dir != "./AlaskaAirCom" ] && [ $dir != "./AsComDeployScripts" ]; then
      mkdir -p ${dir##*/}/.github
      echo "# Default owners of everything (i.e. *) in the repository \n* @$ORG/$TEAM" > ./${dir##*/}/.github/CODEOWNERS

      echo "Updating $dir repo"
      cd ${dir##*/}
      git checkout -b $USERNAME/CODEOWNERS
      git add .
      git commit -m "Added CODEOWNERS file"
      git push origin $USERNAME/CODEOWNERS
      pr=$(gh pr create --title "Adding CODEOWNERS" --body "AB#$AB" --reviewer @$ORG/$TEAM 2>&1)
      echo $pr
      pr_list+=( "$pr" )
      cd ..
      echo "codeowners pushed to branch, $USERNAME/CODEOWNERS"
    fi
  fi
done

echo "${pr_list[*]}"

# pass in parameters
# check if codeowners already exist (root, .github, docs) > check if URL is valid


