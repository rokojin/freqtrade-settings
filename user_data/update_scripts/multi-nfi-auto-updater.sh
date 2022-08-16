#!/bin/sh
echo "Checking for NostalgiaForInfinityX.py file update on iterativv's GitHub repo..."

# Variables
containerArray=(01 02 03 04 06 07 08 10)
name_of_docker_container="freqtrade-"
strategy_path="/home/roydig/multibot/strategies"
strategy_url="https://raw.githubusercontent.com/iterativv/NostalgiaForInfinity/main/NostalgiaForInfinityX.py"
backup_filename="NostalgiaForInfinityX.py_BACKUP"
current_filename="NostalgiaForInfinityX.py"
github_filename="NostalgiaForInfinityX.py.1"

# Go to strategy directory
cd $strategy_path

# Download strategy file as github_filename
wget $strategy_url

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
        rm -rf $github_filename
    else
        echo "New version available, replacing strategy file..."

        # Create a new backup file
        rm -rf $backup_filename
        mv $current_filename $backup_filename

        # Delete current strategy file
        rm -rf $current_filename

        # Rename downloaded github strategy file to current filename
        mv $github_filename $current_filename

        # Delete temp downloaded file
        rm -rf $github_filename

        echo "Strategy file replacement done."

        echo "Some docker container need to be reloaded."
        # Restart docker container restart every container
        for n in ${containerArray[@]};
        do
            echo "Container $name_of_docker_container$containerArray needs to be restarted!"
            docker restart $name_of_docker_container$containerArray
            wait
            echo "Container $name_of_docker_container$containerArray is running again."
        done    
    fi

fi
