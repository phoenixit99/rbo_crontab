#!/bin/bash
echo "                                                                    "
echo "                                                                    "
echo "                                                                    "
echo "                                                                    "
echo "  H   H  EEEEE  N   N  RRRR   Y    Y     N   N  OOO   DDDD   EEEEE  "
echo "  H   H  E      NN  N  R   R    Y Y      NN  N O   O  D   D  E      "
echo "  HHHHH  EEEE   N N N  RRRR      Y       N N N O   O  D   D  EEEE   "
echo "  H   H  E      N  NN  R  R      Y       N  NN O   O  D   D  E      "
echo "  H   H  EEEEE  N   N  R   R     Y       N   N  OOO   DDDD   EEEEE  "
echo "                                                                    "
echo "                                                                    "
echo "                                                                    "

set -e  # Exit script on error

# Setup directory and clean up any previous run
cd $HOME
rm -f rainbow_update.sh
cd $HOME/rainbown

# Prompt user for input
read -p "Enter your username: " username
read -s -p "Enter your password: " password
echo ""
read -p "Enter the lastest block : " blocks

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

cd rbo_indexer_testnet
git pull https://github.com/rainbowprotocol-xyz/rbo_indexer_testnet.git

wget https://storage.googleapis.com/rbo/rbo_worker/rbo_worker-linux-amd64-0.0.2-20240914-4ec80a8.tar.gz && tar -xzvf rbo_worker-linux-amd64-0.0.2-20240914-4ec80a8.tar.gz
rm rbo_worker-linux-amd64-0.0.2-20240914-4ec80a8.tar.gz
cp rbo_worker-linux-amd64-0.0.2-20240914-4ec80a8/rbo_worker rbo_worker
rm -r rbo_worker-linux-amd64-0.0.2-20240914-4ec80a8

./rbo_worker worker --rpc http://localhost:5000 --password $password --username $username --start_height $blocks --indexer_port 5050


echo "Script completed successfully."


