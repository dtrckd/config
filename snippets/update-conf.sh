#!/bin/bash

### Old and Obsolete

usage="$0 [-s]"
USER=$USER
echo "User path set as: $(whoami)"

SIMUL="$1"
# Update the following folder from source (FHS) / Only if the target already exists !
# - ./etc/[id]       -> /etc/[id]
# - ./var/cache/[id] -> /var/cache/[id] 
# - ./home/user/[id]     -> /home/user/[id]
# - ./home/bindir    -> /home/bin/*
BINDIR="bindir"

Verbose="-v"
ARGS_CP="-auf" 
SIMUL="0"


if [ `id -u` != 0 ]; then
    echo "must be root, you are $(whoami)"
    echo "...Life whithout risk is nothing..."
    echo "usage: $usage"
    exit 1
fi

######
## Argument Parser
nbArg=$#
for i in `seq 1 $nbArg`; do
    arg="$1"
    if [ "$arg" == "-s" ]; then
        SIMUL="1"
    else
        echo "$0 error [exiting]"
        exit 1
    fi
    shift
done

[ `pwd -P` != "/" ] || (echo "bad current directory" && exit 1)


for FF in `find ./etc  ./home/$USER -mindepth 1 -prune`; do
#for FF in `find ./etc ./var/cache ./home/$USER -mindepth 1 -prune`; do
    FFSource=`echo $FF | sed -e "s/^\.\(.*\)$/\1/" -e "/^$/d"`
    if [ -e "${FFSource}" ]; then
        if [ -d "${FFSource}" ]; then
            FFSource="${FFSource}/"
            FF=$(dirname $FF)
        fi

        if [ "$SIMUL" == 1 ]; then
            echo "/bin/cp $ARGS_CP $Verbose  ${FFSource} $FF"
            echo ""
        else
            /bin/cp "$ARGS_CP" "$Verbose"  "${FFSource}" "$FF"
        fi
    fi
done

if [ "$SIMUL" != 1 ]; then
    file -b /home/${USER}/bin/* | cut -d '`' -f 2 | cut -d "'" -f 1 > "./home/${USER}/${BINDIR}"
fi

