#!/bin/bash

SOURCE_ROOT=/beanstalk
DESTINATION_ROOT=${GITHUB_WORKSPACE:-/github/workspace}

mkdir -p ${DESTINATION_ROOT}/${INPUT_BEANSTALK_ROOT}/
cp -af ${SOURCE_ROOT}/.platform ${DESTINATION_ROOT}/${INPUT_BEANSTALK_ROOT}/

