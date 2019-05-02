#!/bin/bash

use=" $0 [-s] [[--sysv] [--cups] [--nuts] [--apt] [--ram] [--logs [[--kill]] | [-a]]"
#-a: remove all
#-s: simulate
#--nuts: remove thumbnails, backup file~, Adobe flash tmp, dirty Windows-Mac files
#--ram: empty ram
#--logs: remove compressed log
#--kill: empty log

# @TODO: empty some log file and other stuff in /var

####################################################################################################
# Deb packet on system, image (hard)cache
#purge_cache='find /home/*/.thumbnails -type f -print0| xargs -0 rm; '

# Backup file from some editor
#purge_back='find ~/${User} -name *~ -print0 | xargs -0 rm'

# Purge RamDisk
#purge_ram='echo "1" > /proc/sys/vm/drop_caches;sleep 3 ; echo "0" > /proc/sys/vm/drop_caches'

# Configuration file packet only on filesystem
#purge_conf='aptitude purge `dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2`'

# Adobe flash player temp files
#rm -r .macromedia/Flash_Player/
#rm -r .adobe/Flash_Player

####################################################################################################

logext=".gz"
#nutsfile[1]="/home/*/.thumbnails"
#nutsfile[2]="~/.macromedia/Flash_Player"
#nutsfile[3]="~/.adobe/Flash_Player"
#nutsfile[4]="*~"
## Extremly carrefull to * to not remove everithing !
nutsfiles=".thumbnails/* .macromedia/Flash_Player/* .adobe/Flash_Player/* *~ desktop.ini Thumbs.db .DS_Store"

sysv_files="avahi-daemon cups-browsed cups docker mongod \
	bluetooh rpcbind exim4 minissdpd saned bind9 mysqld ntp"

cups_files="cups cups-browsed avahi-daemon"

PurgeNuts=""
PurgeApt=""
PurgeRam=""
PurgeLogs="" #todo
PurgeSysV=""
PurgeCups=""
All=""

# For security
Simulate=""
Force=""
Kill=""

Verbose=""

# Argument Parser
nbArg=$#
for i in `seq 1 $nbArg`; do
    arg="$1"
    if [ "$arg" == "-s" ]; then
        Simulate="s"
    elif [ "$arg" == "--apt" ]; then
        PurgeApt="apt"
    elif [ "$arg" == "--ram" ]; then
        PurgeRam="ram"
    elif [ "$arg" == "--logs" ]; then
        PurgeLogs="logs"
    elif [ "$arg" == "--nuts" ]; then
        PurgeNuts="nuts"
    elif [ "$arg" == "--sysv" ]; then
        PurgeSysV="1"
    elif [ "$arg" == "-f" ]; then
        Force="y"
    elif [ "$arg" == "--kill" ]; then
        Kill="y"
    elif [ "$arg" == "--cups" ]; then
        PurgeCups="y"
    elif [ "$arg" == "-a" ]; then
        All="y"
    elif [ "$arg" == "-v" ]; then
        Verbose="y"
    else
        echo "error:${use}"
        exit 1
    fi
    shift
done

if [ "$nbArg" == 0 ]; then
    echo "error:${use}"
    exit 1
fi

if [ "$All" == "y" ]; then
    PurgeApt="apt"
    PurgeRam="ram"
    PurgeLogs="logs"
    PurgeNuts="nuts"
fi

if [ "$Verbose" == "y" ]; then
    Verbose=">&0"
else
    Verbose=">/dev/null"
fi

if [ "$Simulate" == "s" ]; then

    echo '=== Simulation ==='

    if [ "$PurgeLogs" != "" ]; then
        if [ "$Kill" == "y" ]; then
            sizeLogs=`find /var/log -type f -exec sh -c "echo \"del log.gz: {}\" $Verbose" \; -print0 |\
                xargs -0 du -ch --exclude="del *" --exclude="." | tail -n 1 | tr -s ' ' | cut -d "t" -f 1`
        else
            sizeLogs=`find /var/log -name "*[1-9]*\.gz" -type f -exec sh -c "echo \"del log.gz: {}\" $Verbose" \; -print0 |\
                xargs -0 du -ch --exclude="del *" --exclude="." | tail -n 1 | tr -s ' ' | cut -d "t" -f 1`
        fi
        echo "/var/log files purged size: $sizeLogs"
    fi

    if [ "$PurgeRam" != "" ]; then
        echo 'Purge RAM: echo "1" > /proc/sys/vm/drop_caches;sleep 3 ; echo "0" > /proc/sys/vm/drop_caches'
        echo 'Purge WAP: swapoff -a && swapon -a'
    fi

    if [ "$PurgeNuts" != "" ]; then
        #_sizeNuts[1]=`find /home/*/.thumbnails -type f -exec sh -c "echo \"del thumbnails: {}\" $Verbose" \; -print0 |\
        #    xargs -0 du --exclude="del *" --exclude="." -c | tail -n 1 | tr -s ' ' | cut -d "t" -f 1`
        #_sizeNuts[2]=`find /home/*/.macromedia/Flash_Player -type f -exec sh -c "echo \"del tmp flash: {}\" $Verbose" \; -print0 |\
        #    xargs -0 du --exclude="del *" --exclude="." -c | tail -n 1 | tr -s ' ' | cut -d "t" -f 1`
        #_sizeNuts[3]=`find /home/*/.adobe/Flash_Player -type f  -exec sh -c "echo \"del tmp flash: {}\" $Verbose" \; -print0 |\
        #    xargs -0 du --exclude="del *" --exclude="." -c | tail -n 1 | tr -s ' ' | cut -d "t" -f 1`
        #_sizeNuts[4]=`find ~ -name *~  -type f -exec sh -c "echo \"del backup: ~/*~:{}\" $Verbose" \; -print0 |\
        #    xargs -0 du --exclude="del *" --exclude="." -c | tail -n 1 | tr -s ' ' | cut -d "t" -f 1`
        #sizeNuts="0"
        #NB=${_sizeNuts[i]}
        #let "sizeNuts = $NB + $sizeNuts"

        CPT=1
        sizeNuts="0"
        for f in $nutsfiles; do
            BASEN="`basename $f`"
            FF="/home/*/$f"
            DD=`dirname "$FF"`
            _sizeNuts[$CPT]=`find $DD  -name "$BASEN" -type f -exec sh -c "echo \"del $f: {}\" $Verbose" \; -print0 |\
                xargs -0 du --exclude="del *" --exclude="." -c | tail -n 1 | tr -s ' ' | cut -d "t" -f 1`
            NB=${_sizeNuts[CPT]}
            let "sizeNuts = $NB + $sizeNuts"
            CPT=$((CPT+1))
            #echo "$NB Ko"
        done

        nbDigit=${#sizeNuts}
        echo "nuts file purged size: ${sizeNuts} Ko"
        echo "+ hystory -c"

    fi

    if [ "$PurgeApt" != "" ]; then
        apt -s -y clean
        apt -s -y purge `dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2`
        du -sh /var/cache/apt/archives
        apt -s autoremove
    fi

    if [ "$PurgeSysV" != "" ]; then
        echo 'purge systemV init:'
        for f in $sysv_files;do
            echo block deamon $f
        done
    fi

    if [ "$PurgeCups" != "" ]; then
        echo 'purge cups:'
        for f in $cups_files;do
            echo service $f stop
        done
    fi
else
    if [ "$Force" == "y" ]; then
        if [ "$PurgeLogs" != "" ]; then
            find /var/log -name "*[1-9]*\.gz" -type f -print0 | xargs -0 rm -f
            if [ "$Kill" == "y" ]; then
                for F in `find /var/log -type f `; do
                    echo "" > $F
                done
            fi
        fi

        if [ "$PurgeNuts" != "" ]; then
            #find /home/*/.thumbnails -type f -print0 | xargs -0 rm
            #find ~ -name *~ -type f -print0 | xargs -0 rm
            #find ~/.macromedia/Flash_Player -type f -name *~ -print0 | xargs -0 rm
            #find ~/.adobe/Flash_Player -type f -print0 | xargs -0 rm
            history -c
            echo "" > $HOME/.bash_history
            for f in $nutsfiles; do
                BASEN="`basename $f`"
                FF="/home/*/$f"
                DD=`dirname "$FF"`
                find $DD -name "$BASEN" -type f -print0 | xargs -0 rm -f
            done
        fi

        if [ "$PurgeRam" != "" ]; then
            echo "1" > /proc/sys/vm/drop_caches;sleep 3 ; echo "0" > /proc/sys/vm/drop_caches
            swapoff -a && swapon -a
        fi

        if [ "$PurgeApt" != "" ]; then
            apt clean
            apt purge `dpkg -l | grep "^rc" | tr -s ' ' | cut -d ' ' -f 2`
            apt autoremove

        fi

        if [ "$PurgeSysV" != "" ]; then
            echo 'purge systemV init:'
            for f in $sysv_files;do
                service $f stop
                update-rc.d -f $f remove
                #systemctl mask $f
            done
        fi

    if [ "$PurgeCups" != "" ]; then
        echo 'purge cups:'
        for f in $cups_files;do
            service $f stop
            update-rc.d -f $f remove
            # upstart is deprecated (update-rc...service also ?⁾
            #systemctl stop $f
            systemctl disable $f
        done
    fi

    else
        echo "use -f to realy purge instantly or -s to simulate"
        exit 255
    fi
fi

