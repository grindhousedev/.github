#!/bin/bash

# Define the repository and issue
REPO="The-Grindhouse/grindlines"
ISSUE="6"

# Fetch the comments from the issue and save to comments.json
curl -L \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  "https://api.github.com/repos/$REPO/issues/$ISSUE/comments" >comments.json

# Initialize members.json with an empty array
echo "[" >members.json

# Fetch user details based on the comments
cat comments.json | jq -r '.[].user.login' | while read USERNAME; do
  # Call GitHub API for each user and append the response to members.json
  curl -L \
    -H "Accept: application/vnd.github+json" \
    -H "Authorization: Bearer $GITHUB_TOKEN" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    "https://api.github.com/users/$USERNAME" >>members.json
  # Add a comma after each user JSON object (except the last one)
  echo "," >>members.json
done

# Remove the last comma to make the JSON valid
sed -i '$ s/,$//' members.json

# Wrap the JSON in an array
echo "]" >>members.json

# Output the result
echo "User data saved in members.json"
rm comments.json
