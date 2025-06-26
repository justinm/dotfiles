
function aws-login {
    [[ -e ".env" ]] && source .env
    local ARGS="$@"
    local profiles="${ARGS:=$AWS_PROFILES}"
    local profile_array

    # Split profiles into an array
    if [[ -n "$profiles" ]]; then
        IFS=' ' read -r -A profile_array <<< "$profiles"
    fi

    [[ -z "$profile_array" ]] && echo "You must specify at least one profile" && return 1

    for entry in $profile_array; do
        set -x
        aws sso login --profile $entry || return 1
        set +x
    done
}

function aws-switch-profile {
    local aws_profile="$1"

    [[ -z "$aws_profile" ]] && echo "You must specify a profile" && return 1

    set -x
    export AWS_PROFILE=$aws_profile
    echo $aws_profile > ~/.aws/current_profile
    set +x
}

function aws-assume-role {
    if [[ $(/usr/bin/which jq) == "" ]]; then
        read -p "The jq utility is required, would you like to install it? " -n 1 -r

        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            brew install jq
        else
            return _fail "jq was not installed"
        fi
    fi

    ROLE="$@"
    ROLE_SESSION_NAME="assume-role-cli"
    RESPONSE=$(aws sts assume-role --role-arn ${ROLE} --role-session-name ${ROLE_SESSION_NAME})

    echo $RESPONSE
}

function aws-logout {
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_SECURITY_TOKEN
    unset AWS_PROFILE
    unset ASSUMED_ROLE
}

function aws-profiles() {
    cat ~/.aws/config | grep '\[' | grep -v '#' | tr -d '[' | tr -d ']' | awk '{print$2}'
}

function aws-ssh {
    local instance_id="$1"

    mssh ubuntu@${instance_id}
}

function aws-whoami {
    aws sts get-caller-identity
}

function aws-credentials() {
    if [[ -z "$1" ]]; then
        AWS_PROFILE=$1
        return 1
    fi

    echo AWS_PROFILE=$AWS_PROFILE
    echo export AWS_ACCESS_KEY_ID=$(aws --profile $AWS_PROFILE configure get aws_access_key_id)
    echo export AWS_SECRET_ACCESS_KEY=$(aws --profile $AWS_PROFILE configure get aws_secret_access_key)
    echo export AWS_SESSION_TOKEN=$(aws --profile $AWS_PROFILE configure get aws_session_token)
}

alias aws-profile=aws-switch-profile

[[ -e "$HOME/.aws/current_profile" ]] && AWS_PROFILE=$(cat $HOME/.aws/current_profile)
