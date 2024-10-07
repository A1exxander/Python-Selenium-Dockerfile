# Use the official Python image from the Docker Hub
FROM python:latest

# Install Chrome
RUN apt-get update && apt-get install -y wget gnupg2
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update && apt-get install -y google-chrome-stable

# Install Chromedriver
RUN wget -q "https://chromedriver.storage.googleapis.com/$(wget -q -O - https://chromedriver.storage.googleapis.com/LATEST_RELEASE)/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /usr/local/bin/ \
    && rm /tmp/chromedriver.zip

# Install Selenium
RUN pip install selenium

# Set environment variable to avoid "chrome not reachable" error
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

# Copy the Selenium test scripts to the container
COPY *.py /usr/src/app/

# Set the working directory
WORKDIR /usr/src/app

# Run the test(s) - defaults to sample-suite.py
ENTRYPOINT ["python"]
CMD ["sample-suite.py"]
