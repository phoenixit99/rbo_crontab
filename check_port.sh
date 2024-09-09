#!/bin/bash

# Check if port 5050 is in use
if ! nc -z localhost 5050; then
    echo "Port 5050 is not in use. Starting the server..."
    # Start a simple HTTP server on port 5050 (example command)
    # python3 -m http.server 5050 &
    docker exec -it rainbown/rbo_indexer_testnet ./rbo_worker worker --rpc http://localhost:5000 --password $password hoanguit --username $username --start_height 43419
else
    echo "Port 5050 is already in use."
fi
