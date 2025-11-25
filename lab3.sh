#!/bin/bash

VERBOSE=0
if [ "$1" == "-verbose" ]; then
    VERBOSE=1
    VERBOSE_FLAG="-verbose"
    echo "[VERBOSE] Enabled"
else
    VERBOSE_FLAG=""
fi

SERVER1="remoteadmin@server1-mgmt"
SERVER2="remoteadmin@server2-mgmt"

# Function to test exit code
check_status() {
    if [ $1 -ne 0 ]; then
        echo "[ERROR] $2"
        exit 1
    fi
}

echo "=== Deploying configure-host.sh to servers ==="

# Copy script to server1
scp configure-host.sh $SERVER1:/root/
check_status $? "Failed to copy script to server1"

# Run on server1
ssh $SERVER1 -- /root/configure-host.sh $VERBOSE_FLAG -name loghost -ip 192.168.16.3 -hostentry webhost 192.168.16.4
check_status $? "Failed to run configure script on server1"

# Copy script to server2
scp configure-host.sh $SERVER2:/root/
check_status $? "Failed to copy script to server2"

# Run on server2
ssh $SERVER2 -- /root/configure-host.sh $VERBOSE_FLAG -name webhost -ip 192.168.16.4 -hostentry loghost 192.168.16.3
check_status $? "Failed to run configure script on server2"

echo "=== Updating local /etc/hosts ==="
sudo ./configure-host.sh -hostentry loghost 192.168.16.3
sudo ./configure-host.sh -hostentry webhost 192.168.16.4

echo "=== Deployment complete ==="
exit 0
