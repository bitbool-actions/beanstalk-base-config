#!/bin/bash

EFS_MOUNT_=$(/opt/elasticbeanstalk/bin/get-config environment -k EFS_MOUNT 2>/dev/null)
EFS_DNS=$(/opt/elasticbeanstalk/bin/get-config environment -k EFS_DNS 2>/dev/null)

if [[ -n "${EFS_MOUNT}" ]]; then
      mkdir -p ${EFS_MOUNT}
      if grep -qs '${EFS_DNS} ' /proc/mounts; then
          echo "${EFS_DNS} is already mounted."
      else
          echo "Mounting ${EFS_DNS}"
          mount -t nfs4 -o nfsvers=4.1 ${EFS_DNS}:/ ${EFS_MOUNT}
      fi
fi