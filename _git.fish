# Name of the current branch
# http://stackoverflow.com/a/12142066/1558022
alias gcb="git rev-parse --abbrev-ref HEAD"


# Clone a GitHub repo given its URL.
#
#     $1 = URL of the GitHub page
#
# Because switching to the repo homepage, clicking, copying the clone URL,
# typing 'git clone', pasting, are all more effort than I care to do manually.
function github-clone
    set url "$argv[1]"

    # Get the identifiers for the repository
    set components (string split "/" "$url")

    if [ "$components[3]" != "github.com" ]
        echo "$url is not a GitHub repo"
        return 1
    end

    set owner $components[4]
    set repo $components[5]

    if [ (count $components) -gt 5 ]
        # Detect if this is a pull request, and divert
        if [ $components[6] = "pull" ]
            github-add-pr-branch "$url"
            return $status
        end
    end

    set repo_url "git@github.com:$owner/$repo.git"

    mkdir -p ~/repos; cd ~/repos

    if [ -d $repo ]
        # If the repo already exists, check we have the selected fork
        # as a remote.
        cd $repo
        git remote -v | grep "$owner" >/dev/null 2>&1
        if [ $status != 0 ]
            echo "git remote add $owner $repo_url"
            git remote add $owner $repo_url
        end
        set remote (git remote -v | grep "$owner" | awk '{print $1}')
        git fetch
    else
        # Otherwise, clone a fresh copy of the repo
        echo "git clone $repo_url"
        git clone $repo_url
        cd $repo
    end
end


# Given a GitHub pull request, create the repo and make sure the remote
# of the PR owner is added as a remote.
#
#     $1 = URL of the pull request
#
# Sometimes when I'm looking at a pull request, it's useful to get the
# branch locally and test/review/squash it as appropriate.  This makes
# it easier to do so!
#
# Typically not called directly, but detected by 'github-open' and
# switched to if looking at a pull request URL.
function github-add-pr-branch
    # First ensure we have a local clone of the repo
    set url "$argv[1]"
    github-clone (string split "pull/" "$url" | head -n 1)
    if [ $status != 0 ]
        return 1
    end

    # Get the identifiers for the repository.  A pull request URL is
    # of the form
    #
    #     https://github.com/:owner/:repo/pull/:number#discussion_:comment
    #
    set components (string split "/" "$url")

    if [ "$components[6]" != "pull" ]
        echo "$url is not a GitHub pull request"
        return 1
    end

    set owner $components[4]
    set repo $components[5]
    set number (echo $components[7] | tr '#' ' ' | awk '{print $1}')

    set api_url "https://api.github.com/repos/$owner/$repo/pulls/$number"
    set api_resp (curl -s -H "Accept: application/vnd.github.v3+json" "$api_url")
    set pr_branch (echo $api_resp | jq '.head.repo.full_name' | tr '"' ' ' | awk '{print $1}')

    git checkout (echo $api_resp | jq '.head.ref' | tr '"' ' ' | awk '{print $1}')
end


# Within a GitHub repository, create a remote named 'alex' for a GitHub fork
# of the same name.  Useful if I cloned before forking.
function gh-add-remote
    set origin_url (git remote get-url origin)
    set repo_name (string split "/" "$origin_url" | tail -n 1)
    git remote add alex "git@github.com:alexwlchan/$repo_name"
end
