FROM n8nio/n8n:latest

USER root

# Install essential packages, ffmpeg, fontconfig และ Tesseract OCR
RUN apk add --no-cache \
    poppler-utils \
    ffmpeg \
    fontconfig \
    ttf-freefont \
    tesseract-ocr \
    tesseract-ocr-data-tha \
    tesseract-ocr-data-eng \
    imagemagick

# คัดลอกฟอนต์จากโฟลเดอร์ fonts บน host ไปยัง container
COPY fonts /usr/share/fonts/custom

# สร้างแคชฟอนต์ใหม่
RUN fc-cache -f -v

# สร้าง directories และกำหนด permission
RUN mkdir -p /data /doc && \
    chown -R node:node /data /doc

# กำหนด Tesseract data path (ตรวจสอบ path ที่ถูกต้อง)
ENV TESSDATA_PREFIX=/usr/share/tessdata

USER node
WORKDIR /home/node