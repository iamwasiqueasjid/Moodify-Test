# Dockerfile for Selenium Python Tests with Chrome
FROM python:3.11-slim

# Set build arguments
ARG CHROME_VERSION=120.0.6099.109-1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    curl \
    xvfb \
    fonts-liberation \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libatspi2.0-0 \
    libcups2 \
    libdbus-1-3 \
    libdrm2 \
    libgbm1 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libwayland-client0 \
    libxcomposite1 \
    libxdamage1 \
    libxfixes3 \
    libxkbcommon0 \
    libxrandr2 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Chrome
RUN wget -q -O /tmp/google-chrome-stable_amd64.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${CHROME_VERSION}_amd64.deb \
    && apt-get update \
    && apt-get install -y /tmp/google-chrome-stable_amd64.deb \
    && rm /tmp/google-chrome-stable_amd64.deb \
    && rm -rf /var/lib/apt/lists/*

# Install ChromeDriver (using newer method)
RUN CHROMEDRIVER_VERSION=$(curl -sS https://googlechromelabs.github.io/chrome-for-testing/LATEST_RELEASE_120) \
    && wget -q "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROMEDRIVER_VERSION}/linux64/chromedriver-linux64.zip" -O /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /tmp \
    && mv /tmp/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver \
    && chmod +x /usr/local/bin/chromedriver \
    && rm -rf /tmp/chromedriver* \
    || (echo "Failed to download ChromeDriver from new location, trying alternative..." \
        && wget -q "https://chromedriver.storage.googleapis.com/120.0.6099.109/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
        && unzip /tmp/chromedriver.zip -d /tmp \
        && mv /tmp/chromedriver /usr/local/bin/chromedriver \
        && chmod +x /usr/local/bin/chromedriver \
        && rm -rf /tmp/chromedriver*)

# Verify installations
RUN google-chrome --version && chromedriver --version

# Set working directory
WORKDIR /app

# Create directories for test outputs
RUN mkdir -p /app/screenshots /app/test-results

# Copy requirements and install Python dependencies
COPY selenium-tests/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy test files
COPY selenium-tests/ .

# Set environment variables
ENV DISPLAY=:99
ENV PYTHONUNBUFFERED=1
ENV CHROME_BIN=/usr/bin/google-chrome

# Set permissions
RUN chmod -R 755 /app

# Health check
RUN python -c "import selenium; print(f'Selenium version: {selenium.__version__}')"

# Run tests with proper output
CMD ["python", "-u", "run_all_tests.py"]
