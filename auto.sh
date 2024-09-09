SCRIPT_PATH="$HOME/rbo_crontab/check_port.sh"
if [ ! -f "$SCRIPT_PATH" ]; then
    echo -e "#!/bin/bash\necho \"This is my script running!\" >> $HOME/rbo_crontab/output.log" > "$SCRIPT_PATH"
    chmod +x "$SCRIPT_PATH"
fi

# Add the cron job
CRON_JOB="* * * * * $SCRIPT_PATH"
(crontab -l; echo "$CRON_JOB") | crontab -
echo "Cron job added: $CRON_JOB"