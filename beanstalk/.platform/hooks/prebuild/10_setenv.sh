#!/bin/bash

echo "### 10_readsecrets.sh ####"
TOKEN=$(curl --silent -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
SECRETS_REGION=$(curl --silent -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)

VAR_PROJECT=$(/opt/elasticbeanstalk/bin/get-config environment -k PROJECT 2>/dev/null)
VAR_SYSTEMENV=$(/opt/elasticbeanstalk/bin/get-config environment -k SYSTEMENV 2>/dev/null)
VAR_APPLICATION=$(/opt/elasticbeanstalk/bin/get-config environment -k APPLICATION 2>/dev/null)
#secrets can be comma separated
VAR_SECRETS=$(/opt/elasticbeanstalk/bin/get-config environment -k SECRETS 2>/dev/null)
[ -z "$VAR_SECRETS"] && VAR_SECRETS="secrets"

fetch_secret() {
	SECRET=$1
	REQUIRED=$2
	WRITE_TO=$3

	echo "---------------------------------------------"
	echo Searching for secret: $SECRET
	FOUND=$(aws --region $SECRETS_REGION secretsmanager get-secret-value --output text --query Name --secret-id $SECRET | tr -d '\n')
    
    echo Found secret: $FOUND
	if [[ "X$FOUND" == "X$SECRET" ]]; then
		echo Writing secret $SECRET to $WRITE_TO
		aws --region $SECRETS_REGION secretsmanager get-secret-value --output text --query SecretString  --secret-id $SECRET > $WRITE_TO
	elif [[ "$REQUIRED" == "true" ]]; then
		echo Secret was not found and is required. Exiting
		exit 1
	fi

}

for secret in ${VAR_SECRETS//,/ }
do
        fetch_secret ${VAR_PROJECT}/${VAR_SYSTEMENV}/${VAR_APPLICATION}/${secret} true .env.${secret}
done

