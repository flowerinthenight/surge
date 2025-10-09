#!/bin/sh

# NOTE on test VM:
# gcloud compute instances create bpf-kvm \
#        --enable-nested-virtualization \
#        --zone asia-northeast1-b \
#        --min-cpu-platform "AUTOMATIC" \
#        --machine-type n2-standard-4 \
#        --image-project ubuntu-os-cloud \
#        --image-family ubuntu-2404-lts-amd64 \
#        --boot-disk-size 50 \
#        --project alphaus-dashboard

# Local build only; environment specific.
go generate
DOCKER_BUILDKIT=0 docker build --rm -t vortex-agent .
DOCKER_BUILDKIT=0 docker tag vortex-agent asia-docker.pkg.dev/mobingi-main/asia-pub/vortex-agent:$1
DOCKER_BUILDKIT=0 docker push asia-docker.pkg.dev/mobingi-main/asia-pub/vortex-agent:$1
DOCKER_BUILDKIT=0 docker rmi $(docker images --filter "dangling=true" -q --no-trunc) -f
sed -i -e 's/image\:\ asia-docker.pkg.dev\/mobingi\-main\/asia\-pub\/vortex\-agent[\:@].*$/image\:\ asia-docker.pkg.dev\/mobingi\-main\/asia\-pub\/vortex\-agent\:'$1'/g' daemonset.yaml
