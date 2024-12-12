# --- Build Step -----
# Use a Node.js base image
FROM node:18-alpine AS tailwind-build



COPY tailwind_build/ ./tailwind_build
RUN ls -l /tailwind_build
# Copy the Tailwind input CSS
COPY ./app/static/css/tailwind.css ./app/static/css/tailwind.css
# Install dependencies
WORKDIR /tailwind_build

RUN npm install

# Install Tailwind CLI and build the output CSS
RUN npx tailwindcss -i ../app/static/css/tailwind.css -o ../app/static/css/styles.css --minify

# Clean up node_modules (optional, to keep the image smaller)
RUN rm -rf node_modules

# --- Server -----
FROM python:3.9-slim

ENV PYTHONDONTWRITEBYTESCODE 1
ENV PYTHONUNBUFFERED 1

COPY --from=tailwind-build /app/static/css/styles.css ./app/static/css/styles.css
COPY . .
RUN pip install --no-cache-dir -r requirements.txt


CMD ["uvicorn", "app.main:app", "--proxy-headers", "--forwarded-allow-ips=*", "--host", "0.0.0.0", "--port", "8000"]
# example commands:
# docker build --no-cache -t chat_with_data:latest . --progress=plain
# docker run --rm -p 8000:8000 --env-file=.env chat_with_data:latest
