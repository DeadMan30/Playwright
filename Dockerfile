FROM mcr.microsoft.com/playwright/python:v1.52.0-jammy

WORKDIR /app

# Install FastAPI + Uvicorn
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy your app files
COPY . .

# Expose port (Render uses 10000 internally)
EXPOSE 10000

# Run the FastAPI server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
