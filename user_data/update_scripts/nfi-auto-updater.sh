#!/bin/sh
echo "Checking for NostalgiaForInfinityX.py file update on iterativv's GitHub repo..."

# Variables
strategy_path="/root/freqtrade-docker-01/user_data/strategies"
name_of_docker_container="freqtrade-01"
strategy_url="https://raw.githubusercontent.com/iterativv/NostalgiaForInfinity/main/NostalgiaForInfinityX.py"
backup_filename="NostalgiaForInfinityX.py_BACKUP"
current_filename="NostalgiaForInfinityX.py"
github_filename="NostalgiaForInfinityX.py.1"

# Go to strategy directory
cd $strategy_path

# Download strategy file as github_filename
sudo wget $strategy_url

if [ -f "$github_filename" ]; then

    # Generate checksum hashes for current and downloaded files
    curr_sum=`cksum $current_filename | awk -F" " '{print $1}'`
    downloaded_sum=`cksum $github_filename | awk -F" " '{print $1}'`

    echo $curr_sum
    echo $downloaded_sum

    # Update stratgy
    if [ $curr_sum -eq $downloaded_sum ]; then
        echo "The current strategy is already up to date."
        # Delete temp downloaded file
        sudo rm -rf $github_filename
    else
        echo "New version available, replacing strategy file..."

        # Create a new backup file
        sudo rm -rf $backup_filename
        sudo mv $current_filename $backup_filename

        # Delete current strategy file
        sudo rm -rf $current_filename

        # Rename downloaded github strategy file to current filename
        sudo mv $github_filename $current_filename

        # Delete temp downloaded file
        sudo rm -rf $github_filename

        echo "Strategy file replacement done."

        # Restart docker container
        sudo docker restart $name_of_docker_container
    fi

fi
