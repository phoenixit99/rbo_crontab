#!/bin/bash
echo "                                                                   "
echo "                                                                   "
echo "                                                                   "
echo "                                                                   "
echo "  H   H  EEEEE  N   N  RRRR   Y    Y     N   N  OOO   DDDD   EEEEE "
echo "  H   H  E      NN  N  R   R    Y Y      NN  N O   O  D   D  E     "
echo "  HHHHH  EEEE   N N N  RRRR      Y       N N N O   O  D   D  EEEE  "
echo "  H   H  E      N  NN  R  R      Y       N  NN O   O  D   D  E     "
echo "  H   H  EEEEE  N   N  R   R     Y       N   N  OOO   DDDD   EEEEE "
echo "                                                                   "
echo "                                                                   "
echo "                                                                   "

set -e  # Exit script on error

# Setup directory and clean up any previous run
cd $HOME
rm -f cron_rainbow.sh
mkdir -p rbo_crontab
cd rbo_crontab

# Prompt user for input
read -p "Enter your username: " username
read -s -p "Enter your password: " password
read -p "Enter the lastest block : " blocks
echo ""

# Ensure username, password, and wallet name are not empty
if [[ -z "$username" || -z "$password"  ]]; then
  echo "Error: All fields (username, password) must be filled."
  exit 1
fi

# Check if jq is installed, install it if not
if ! command -v jq &> /dev/null
then
    echo "jq is not installed. Installing jq..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # For Debian/Ubuntu-based systems
        sudo apt-get update
        sudo apt-get install -y jq
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # For macOS
        brew install jq
    else
        echo "Unsupported OS. Please install jq manually."
        exit 1
    fi
fi
# Output variables with jq (optional)
echo "{\"username\": \"$username\", \"password\": \"$password\", \"blockes\": \"$blocks\"}" | jq .

# Generate check port with the provided input
cat > check_port.sh <<EOL
#!/bin/bash

# Check if port 5050 is in use
if ! nc -z localhost 5050; then
    echo "Port 5050 is not in use. Starting the server..." >> $HOME/rbo_crontab/output.log
    echo "Run start by command..."
    echo "cd $HOME && cd rainbown && cd rbo_indexer_testnet && ./rbo_worker worker --rpc http://localhost:5000 --password $password --username $username --start_height $blocks"
    cd $HOME && cd rainbown && cd rbo_indexer_testnet && ./rbo_worker worker --rpc http://localhost:5000 --password $password --username $username --start_height $blocks
else
    echo "Port 5050 is already in use." >> $HOME/rbo_crontab/output.log
fi

EOL

 # For permision run file
chmod +x check_port.sh
 # For create file logs
touch output.log

curl -L -o auto.sh https://github.com/phoenixit99/rbo_crontab/raw/main/auto.sh

chmod +x auto.sh

./auto.sh


echo "Script completed successfully."




