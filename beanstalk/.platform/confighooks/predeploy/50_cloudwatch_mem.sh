#!/bin/bash

VAR_PROJECT=$(/opt/elasticbeanstalk/bin/get-config environment -k PROJECT)
VAR_SYSTEMENV=$(/opt/elasticbeanstalk/bin/get-config environment -k SYSTEMENV)
VAR_APPLICATION=$(/opt/elasticbeanstalk/bin/get-config environment -k APPLICATION)

cat <<EOF > /tmp/mem.json
{
   "metrics":{
      "append_dimensions" : {
      },
      "metrics_collected":{
         "mem":{
            "measurement":[
               "used_percent"
            ],
            "metrics_collection_interval":30,
      	    "append_dimensions": {
               "app": "${VAR_PROJECT}-${VAR_SYSTEMENV}-${VAR_APPLICATION}"
            }
         }
      }
   }
}

EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a append-config -m ec2 -s -c file:/tmp/mem.json
