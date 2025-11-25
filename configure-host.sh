#!/bin/bash

# Ignore TERM, HUP, INT
trap "" TERM HUP INT

VERBOSE=0

log() {
    if [ $VERBOSE -eq 1 ]; then
        echo "$1"
    fi
}

# Parse arguments
while [ "$1" != "" ]; do
    case $1 in
        -verbose )
            VERBOSE=1
            ;;
        -name )
            shift
            NEWNAME=$1
            ;;
        -ip )
            shift
            NEWIP=$1
            ;;
        -hostentry )
            shift
            HOSTNAME=$1
            shift
            HOSTIP=$1
            ;;
    esac
    shift
done

# -----------------------------
# Change hostname
# -----------------------------
if [ ! -z "$NEWNAME" ]; then
    CURRENT=$(hostname)

    if [ "$CURRENT" != "$NEWNAME" ]; then
        log "Updating hostname to $NEWNAME"

        # Update /etc/hostname
        echo "$NEWNAME" > /etc/hostname

        # Update /etc/hosts (127.0.1.1)
        sed -i "s/127.0.1.1.*/127.0.1.1   $NEWNAME/" /etc/hosts

        # Apply hostname live
        hostnamectl set-hostname "$NEWNAME"

        logger "Hostname changed to $NEWNAME"
    else
        log "Hostname already correct"
    fi
fi

# -----------------------------
# Change IP address
# -----------------------------
if [ ! -z "$NEWIP" ]; then

    NETPLAN_FILE=$(ls /etc/netplan/*.yaml | head -n 1)

    CURRENT_IP=$(grep -oP '\d+\.\d+\.\d+\.\d+' $NETPLAN_FILE | head -n 1)

    if [ "$CURRENT_IP" != "$NEWIP" ]; then
        log "Updating IP address to $NEWIP"

        sed -i "s/$CURRENT_IP/$NEWIP/" $NETPLAN_FILE

        netplan apply

        logger "IP changed to $NEWIP"
    else
        log "IP address already correct"
    fi
fi

# -----------------------------
# Ensure hostentry exists
# -----------------------------
if [ ! -z "$HOSTNAME" ] && [ ! -z "$HOSTIP" ]; then
    if ! grep -q "$HOSTNAME" /etc/hosts; then
        echo "$HOSTIP   $HOSTNAME" >> /etc/hosts
        log "Added hostentry: $HOSTNAME $HOSTIP"
        logger "Host entry added for $HOSTNAME"
    else
        log "Host entry already exists"
    fi
fi

exit 0
