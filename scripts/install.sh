#!/bin/bash
git clone --depth 1 \
    --filter=blob:none \
    --no-checkout \
    https://github.com/BrynardSecurity/dev-aws-kubernetes-vpc.git \
;

cd dev-aws-kubernetes-vpc
git checkout master -- terraform