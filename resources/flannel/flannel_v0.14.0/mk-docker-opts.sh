#!/bin/sh

usage() {
	echo "$0 [-f FLANNEL-ENV-FILE] [-d DOCKER-ENV-FILE] [-i] [-c] [-m] [-k COMBINED-KEY]

Generate Docker daemon options based on flannel env file
OPTIONS:
	-f	Path to flannel env file. Defaults to /run/flannel/subnet.env
	-d	Path to Docker env file to write to. Defaults to /run/docker_opts.env
	-i	Output each Docker option as individual var. e.g. DOCKER_OPT_MTU=1500
	-c	Output combined Docker options into DOCKER_OPTS var
	-k	Set the combined options key to this value (default DOCKER_OPTS=)
	-m	Do not output --ip-masq (useful for older Docker version)
" >&2

	exit 1
}

flannel_env="/run/flannel/subnet.env"
docker_env="/run/docker_opts.env"
combined_opts_key="DOCKER_OPTS"
indiv_opts=false
combined_opts=false
ipmasq=true

while getopts "f:d:icmk:?h" opt; do
	case $opt in
		f)
			flannel_env=$OPTARG
			;;
		d)
			docker_env=$OPTARG
			;;
		i)
			indiv_opts=true
			;;
		c)
			combined_opts=true
			;;
		m)
			ipmasq=false
			;;
		k)
			combined_opts_key=$OPTARG
			;;
		[\?h])
			usage
			;;
	esac
done

if [ $indiv_opts = false ] && [ $combined_opts = false ]; then
	indiv_opts=true
	combined_opts=true
fi

if [ -f "$flannel_env" ]; then
	. $flannel_env
fi

if [ -n "$FLANNEL_SUBNET" ]; then
	DOCKER_OPT_BIP="--bip=$FLANNEL_SUBNET"
fi

if [ -n "$FLANNEL_MTU" ]; then
	DOCKER_OPT_MTU="--mtu=$FLANNEL_MTU"
fi

if [ -n "$FLANNEL_IPMASQ" ] && [ $ipmasq = true ] ; then
	if [ "$FLANNEL_IPMASQ" = true ] ; then
		DOCKER_OPT_IPMASQ="--ip-masq=false"
	elif [ "$FLANNEL_IPMASQ" = false ] ; then
		DOCKER_OPT_IPMASQ="--ip-masq=true"
	else
		echo "Invalid value of FLANNEL_IPMASQ: $FLANNEL_IPMASQ" >&2
		exit 1
	fi
fi

eval docker_opts="\$${combined_opts_key}"

if [ "$docker_opts" ]; then
	docker_opts="$docker_opts ";
fi

echo -n "" >$docker_env

for opt in $(set | grep "DOCKER_OPT_"); do

	OPT_NAME=$(echo $opt | awk -F "=" '{print $1;}');
	OPT_VALUE=$(eval echo "\$$OPT_NAME");

	if [ "$indiv_opts" = true ]; then
		echo "$OPT_NAME=\"$OPT_VALUE\"" >>$docker_env;
	fi

	docker_opts="$docker_opts $OPT_VALUE";

done

if [ "$combined_opts" = true ]; then
	echo "${combined_opts_key}=\"${docker_opts}\"" >>$docker_env
fi
