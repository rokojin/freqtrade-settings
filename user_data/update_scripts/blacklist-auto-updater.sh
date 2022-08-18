#!/bin/bash
echo "Checking for changes on the config files in Rokojins GitHub repo..."

# Variables
containerArray=(01)
config_path_prefix="/root/freqtrade-docker"
contig_path_suffix="/user_data/"
name_of_docker_container="freqtrade-"
config_blacklist_url="https://raw.githubusercontent.com/rokojin/freqtrade-settings/main/user_data/blacklist-binance.json"
backup_blacklist_filename="blacklist-binance.json_BACKUP"
current_blacklist_filename="blacklist-binance.json"
github_blacklist_filename="blacklist-binance.json.1"
backup_directory="/config-backup"

for n in ${containerArray[@]};
do
	# Go to user_data directory
	cd $config_path_prefix$n$contig_path_suffix

    # Download config files as github_filename
    wget $config_blacklist_url

    if [ -f "$github_blacklist_filename" ]; then

        # Generate checksum hashes for current and downloaded files
        curr_sum=`cksum $current_blacklist_filename | awk -F" " '{print $1}'`
        downloaded_sum=`cksum $github_blacklist_filename | awk -F" " '{print $1}'`

        echo $curr_sum
        echo $downloaded_sum

        # Update config
        if [ $curr_sum -eq $downloaded_sum ]; then
            echo "The current blacklist is already up to date."
            # Delete temp downloaded file
            rm -rf $github_blacklist_filename
        else
            echo "New version available, replacing blacklist files..."

            # check if backup directory exists
            if [ -d $backup_directory ];
            then
                echo "Backup folder is existing."
            else
                echo "Backup folder is not existing and will now be created."
                mkdir config-backup
            fi 

            # Create a new backup file
            rm -rf config-backup/$backup_blacklist_filename
            mv $current_blacklist_filename config-backup/$backup_blacklist_filename

            # Delete current strategy file
            rm -rf $current_blacklist_filename

            # Rename downloaded github strategy file to current filename
            mv $github_blacklist_filename $current_blacklist_filename

            # Delete temp downloaded file
            rm -rf $github_blacklist_filename

            echo "blacklist file replacement done."

            echo "Some docker container need to be reloaded."
            # Restart docker container restart every container
            for n in ${containerArray[@]};
            do
                echo "Container $name_of_docker_container$n needs to be restarted!"
                docker restart $name_of_docker_container$n
                wait
                echo "Container $name_of_docker_container$n is running again."
            done
        fi

    fi

done

echo "Updating process finished"