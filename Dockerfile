FROM python:3.10-slim

# Install system dependencies required by Playwright
RUN apt-get update && apt-get install -y \
    wget gnupg ca-certificates curl unzip \
    libglib2.0-0 libnss3 libatk1.0-0 libatk-bridge2.0-0 \
    libxcomposite1 libxdamage1 libxrandr2 libgbm1 \
    libasound2 libxshmfence1 libxss1 libxtst6 libx11-xcb1 \
    libxkbcommon0 libgtk-3-0 libdrm2 libudev1 libpango-1.0-0 \
    libharfbuzz-0.0.0 libdbus-1-3 xvfb fonts-liberation \
    && apt-get clean

# Set working directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install Playwright and its browsers
RUN pip install playwright && playwright install --with-deps

COPY . .

# Run the API server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
