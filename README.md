COMP2137 – Assignment 3

Automated Host Configuration Using Bash & SSH

Student: Imtiaz Mahmud Khondaker
Student Number: 85223
Date: Nov 25, 2025

📌 Description

This assignment automates hostname configuration on two LXD containers (server1 and server2) using Bash and SSH.

📌 Files Included

configure-host.sh – updates hostname, /etc/hosts, prints uptime and IP

lab3.sh – deployment script that copies and runs configure-host.sh on server1 & server2 using SSH

📌 How to Run
1️⃣ Make both scripts executable:
chmod +x configure-host.sh
chmod +x lab3.sh

2️⃣ Run the deployment script:
./lab3.sh

This script will:

SSH to server1

Copy configure-host.sh

Run configure-host.sh

Repeat for server2
