#!/bin/sh
echo "Checking for changes on the config files in Rokojins GitHub repo..."

# Variables
container_array={"01" "02"}
#container_array={"01" "02" "03" "04" "06" "07" "08" "10"}
config_path_prefix="/root/freqtrade-docker-"
contig_path_suffix="/user_data/"
name_of_docker_container="freqtrade-"
config_trading_settings_url="https://raw.githubusercontent.com/rokojin/freqtrade-settings/main/user_data/trading-settings.json"
backup_trading_settings_filename="trading-settings.json_BACKUP"
current_trading_settings_filename="trading-settings.json"
github_trading_settings_filename="trading-settings.json.1"
config_pairlist_volume_binance_busd_url="https://raw.githubusercontent.com/rokojin/freqtrade-settings/main/user_data/pairlist-volume-binance-busd.json"
backup_pairlist_volume_binance_busd_filename="pairlist-volume-binance-busd.json_BACKUP"
current_pairlist_volume_binance_busd_filename="pairlist-volume-binance-busd.json"
github_pairlist_volume_binance_busd_filename="pairlist-volume-binance-busd.json.1"
config_pairlist_volume_binance_usdt_url="https://raw.githubusercontent.com/rokojin/freqtrade-settings/main/user_data/pairlist-volume-binance-usdt.json"
backup_pairlist_volume_binance_usdt_filename="pairlist-volume-binance-usdt.json_BACKUP"
current_pairlist_volume_binance_usdt_filename="pairlist-volume-binance-usdt.json"
github_pairlist_volume_binance_usdt_filename="pairlist-volume-binance-usdt.json.1"
config_proxy_config_url="https://raw.githubusercontent.com/rokojin/freqtrade-settings/main/user_data/proxy-config.json"
backup_proxy_config_filename="proxy-config.json_BACKUP"
current_proxy_config_filename="proxy-config.json"
github_proxy_config_filename="proxy-config.json.1"
config_no_proxy_config_url="https://raw.githubusercontent.com/rokojin/freqtrade-settings/main/user_data/no-proxy-config.json"
backup_no_proxy_config_filename="no-proxy-config.json_BACKUP"
current_no_proxy_config_filename="no-proxy-config.json"
github_no_proxy_config_filename="no-proxy-config.json.1"


for n in ${container_array[@]}
do
	# Go to user_data directory
	cd $config_path_prefix$n$contig_path_suffix

	# Download config files as github_filename
	sudo wget $config_trading_settings_url
	sudo wget $config_pairlist_volume_binance_usdt_url
	sudo wget $config_pairlist_volume_binance_busd_url
	sudo wget $config_proxy_config_url
	sudo wget $config_no_proxy_config_url


	if [ -f "$github_trading_settings_filename" ]; then

		# Generate checksum hashes for current and downloaded files
		curr_sum=`cksum $current_trading_settings_filename | awk -F" " '{print $1}'`
		downloaded_sum=`cksum $github_trading_settings_filename | awk -F" " '{print $1}'`

		echo $curr_sum
		echo $downloaded_sum

		# Update config
		if [ $curr_sum -eq $downloaded_sum ]; then
			echo "The current trading-settings is already up to date."
			# Delete temp downloaded file
			sudo rm -rf $github_trading_settings_filename
		else
			echo "New version available, replacing trading-settings file..."

			# Create a new backup file
			sudo rm -rf config-backup/$backup_trading_settings_filename
			sudo mv $current_trading_settings_filename config-backup/$backup_trading_settings_filename

			# Delete current strategy file
			sudo rm -rf $current_trading_settings_filename

			# Rename downloaded github strategy file to current filename
			sudo mv $github_trading_settings_filename $current_trading_settings_filename

			# Delete temp downloaded file
			sudo rm -rf $github_trading_settings_filename

			echo "trading-settings file replacement done."

			# Restart docker container
			sudo docker restart $name_of_docker_container$n
		fi

	fi

	if [ -f "$github_pairlist_volume_binance_busd_filename" ]; then

		# Generate checksum hashes for current and downloaded files
		curr_sum=`cksum $current_pairlist_volume_binance_busd_filename | awk -F" " '{print $1}'`
		downloaded_sum=`cksum $github_pairlist_volume_binance_busd_filename | awk -F" " '{print $1}'`

		echo $curr_sum
		echo $downloaded_sum

		# Update config
		if [ $curr_sum -eq $downloaded_sum ]; then
			echo "The current pairlist-volume-binance-busd is already up to date."
			# Delete temp downloaded file
			sudo rm -rf $github_pairlist_volume_binance_busd_filename
		else
			echo "New version available, replacing pairlist-volume-binance-busd..."

			# Create a new backup file
			sudo rm -rf config-backup/$backup_pairlist_volume_binance_busd_filename
			sudo mv $current_pairlist_volume_binance_busd_filename config-backup/$backup_pairlist_volume_binance_busd_filename

			# Delete current strategy file
			sudo rm -rf $current_pairlist_volume_binance_busd_filename

			# Rename downloaded github strategy file to current filename
			sudo mv $github_pairlist_volume_binance_busd_filename $current_pairlist_volume_binance_busd_filename

			# Delete temp downloaded file
			sudo rm -rf $github_pairlist_volume_binance_busd_filename

			echo "pairlist-volume-binance-busd replacement done."

			# Restart docker container
			sudo docker restart $name_of_docker_container$n
		fi

	fi

	if [ -f "$github_pairlist_volume_binance_usdt_filename" ]; then

		# Generate checksum hashes for current and downloaded files
		curr_sum=`cksum $current_pairlist_volume_binance_usdt_filename | awk -F" " '{print $1}'`
		downloaded_sum=`cksum $github_pairlist_volume_binance_usdt_filename | awk -F" " '{print $1}'`

		echo $curr_sum
		echo $downloaded_sum

		# Update config
		if [ $curr_sum -eq $downloaded_sum ]; then
			echo "The current pairlist-volume-binance-usdt is already up to date."
			# Delete temp downloaded file
			sudo rm -rf $github_pairlist_volume_binance_usdt_filename
		else
			echo "New version available, replacing pairlist-volume-binance-usdt..."

			# Create a new backup file
			sudo rm -rf config-backup/$backup_pairlist_volume_binance_usdt_filename
			sudo mv $current_pairlist_volume_binance_usdt_filename config-backup/$backup_pairlist_volume_binance_usdt_filename

			# Delete current strategy file
			sudo rm -rf $current_pairlist_volume_binance_usdt_filename

			# Rename downloaded github strategy file to current filename
			sudo mv $github_pairlist_volume_binance_usdt_filename $current_pairlist_volume_binance_usdt_filename

			# Delete temp downloaded file
			sudo rm -rf $github_pairlist_volume_binance_usdt_filename

			echo "pairlist-volume-binance-usdt replacement done."

			# Restart docker container
			sudo docker restart $name_of_docker_container$n
		fi

	fi

	if [ -f "$github_proxy_config_filename" ]; then

		# Generate checksum hashes for current and downloaded files
		curr_sum=`cksum $current_proxy_config_filename | awk -F" " '{print $1}'`
		downloaded_sum=`cksum $github_proxy_config_filename| awk -F" " '{print $1}'`

		echo $curr_sum
		echo $downloaded_sum

		# Update config
		if [ $curr_sum -eq $downloaded_sum ]; then
			echo "The current proxy file is already up to date."
			# Delete temp downloaded file
			sudo rm -rf $github_proxy_config_filename
		else
			echo "New version available, replacing proxy file..."

			# Create a new backup file
			sudo rm -rf config-backup/$backup_proxy_config_filename
			sudo mv $current_proxy_config_filename config-backup/$backup_proxy_config_filename

			# Delete current strategy file
			sudo rm -rf $current_proxy_config_filename

			# Rename downloaded github strategy file to current filename
			sudo mv $github_proxy_config_filename $current_proxy_config_filename

			# Delete temp downloaded file
			sudo rm -rf $github_proxy_config_filename

			echo "proxy file replacement done."

			# Restart docker container
			sudo docker restart $name_of_docker_container$n
		fi

	fi

	if [ -f "$github_no_proxy_config_filename" ]; then

		# Generate checksum hashes for current and downloaded files
		curr_sum=`cksum $current_no_proxy_config_filename | awk -F" " '{print $1}'`
		downloaded_sum=`cksum $github_no_proxy_config_filename| awk -F" " '{print $1}'`

		echo $curr_sum
		echo $downloaded_sum

		# Update config
		if [ $curr_sum -eq $downloaded_sum ]; then
			echo "The current no-proxy file is already up to date."
			# Delete temp downloaded file
			sudo rm -rf $github_no_proxy_config_filename
		else
			echo "New version available, replacing no-proxy file ..."

			# Create a new backup file
			sudo rm -rf config-backup/$backup_no_proxy_config_filename
			sudo mv $current_no_proxy_config_filename config-backup/$backup_no_proxy_config_filename

			# Delete current strategy file
			sudo rm -rf $current_no_proxy_config_filename

			# Rename downloaded github strategy file to current filename
			sudo mv $github_no_proxy_config_filename $current_no_proxy_config_filename

			# Delete temp downloaded file
			sudo rm -rf $github_no_proxy_config_filename

			echo "no-proxy file replacement done."

			# Restart docker container
			sudo docker restart $name_of_docker_container$n
		fi

	fi
done	

echo "Updating process finished"