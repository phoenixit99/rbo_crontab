# Use Python base image
FROM python:3.9-slim

# Install necessary tools
RUN apt-get update && apt-get install -y cron netcat-openbsd

# Set the working directory
WORKDIR /app_rainbow

# Copy the shell script and cron job file
COPY check_port.sh /app_rainbow/check_port.sh
COPY cronjob /etc/cron.d/cronjob

# Give execution rights on the script and cron job
RUN chmod +x /app_rainbow/check_port.sh
RUN chmod 0644 /etc/cron.d/cronjob

# Apply the cron job
RUN crontab /etc/cron.d/cronjob

# Create the log file to be able to run tail
RUN touch /var/log/check_port.log

# Run the cron command and tail the log file
CMD cron && tail -f /var/log/check_port.log
