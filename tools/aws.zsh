function aws-login {
    local aws_profile=$1

    set -x
    aws sso login --profile $PROFILE
    python3 -m yawsso -p $PROFILE

    export AWS_PROFILE="$1"
    set +x
}

function aws-switch-profile {
    local aws_profile=$1

    set -x
    export AWS_PROFILE=${aws_profile}
    set +x
}

function aws-assume-role {
    if [[ $(/usr/bin/which jq) == "" ]]; then
        read -p "The jq utility is required, would you like to install it? " -n 1 -r

        if [[ $REPLY =~ ^[Yy]$ ]]
        then
            brew install jq
        else
            exit 1
        fi
    fi

    ROLE="$@"
    ROLE_SESSION_NAME="assume-role-cli"
    RESPONSE=$(aws sts assume-role --role-arn ${ROLE} --role-session-name ${ROLE_SESSION_NAME})

    echo $RESPONSE
}

function aws-logout() {
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

alias aws-profile=aws-switch-profile
