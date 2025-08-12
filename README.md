# N8N Docker Setup with FFmpeg, Tesseract OCR, and Ollama

Complete Docker setup for N8N workflow automation platform with integrated FFmpeg, Tesseract OCR, and Ollama LLM capabilities.

![N8N Tesseract OCR Setup](https://img.shields.io/badge/N8N-Tesseract_OCR-blue?style=for-the-badge)
![Docker](https://img.shields.io/badge/Docker-Ready-green?style=for-the-badge)
![OCR](https://img.shields.io/badge/OCR-Multi_Language-orange?style=for-the-badge)

## Features

- **N8N Workflow Automation** - Visual workflow builder and automation platform
- **FFmpeg Integration** - Complete video/audio processing capabilities  
- **Tesseract OCR** - Multi-language OCR text recognition with Thai and English support
- **Ollama LLM** - Run large language models locally
- **PDF Support** - PDF to image conversion for OCR processing
- **Font Support** - Custom font integration with automatic cache generation
- **Persistent Storage** - Data persistence across container restarts
- **Flexible Volume Mounting** - Easy integration with external directories

## Tech Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Containerization** | Docker, Docker Compose | Service orchestration |
| **Workflow Automation** | n8n | Visual workflow builder |
| **LLM Engine** | Ollama | Local language models |
| **Media Processing** | FFmpeg | Video/audio processing |
| **OCR Engine** | Tesseract OCR | Text recognition |
| **Base Image** | n8nio/n8n (Alpine Linux) | Container foundation |

## Prerequisites

- Docker
- Docker Compose

## Project Structure

```
project-directory/
├── Dockerfile
├── docker-compose.yml
├── fonts/                 # Place your custom fonts here
│   ├── Kanit-Regular.ttf
│   └── Kanit-Bold.ttf
├── data/                  # Persistent data directory for n8n
├── doc/                   # Document storage directory for n8n
└── ollama_data/           # Persistent storage for Ollama models
```

## Installation & Setup

### 1. Clone or Download Files

Download the `Dockerfile` and `docker-compose.yml` to your project directory.

### 2. Prepare Font Directory (Optional)

If you need custom fonts for text processing:

**Linux/macOS:**
```bash
mkdir fonts
# Copy your .ttf or .otf font files to the fonts/ directory
```

**Windows PowerShell:**
```powershell
mkdir fonts
# Copy your .ttf or .otf font files to the fonts/ directory
```

**Recommended:** Download Kanit font from [Google Fonts](https://fonts.google.com/specimen/Kanit) for Thai language support.

### 3. Create Required Directories

**Linux/macOS:**
```bash
mkdir -p data doc
```

**Windows PowerShell:**
```powershell
mkdir data
mkdir doc
```

**Windows Command Prompt:**
```cmd
mkdir data
mkdir doc
```

### 4. Build and Start Services

```bash
docker-compose up -d --build
```

## Configuration

### N8N Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `N8N_BASIC_AUTH_USER` | `admin` | N8N login username |
| `N8N_BASIC_AUTH_PASSWORD` | `admin123` | N8N login password |
| `OLLAMA_BASE_URL` | `http://ollama:11434` | Ollama service URL |
| `TESSDATA_PREFIX` | `/usr/share/tessdata` | Tesseract language data path |

### Volume Mounts

| Host Path | Container Path | Purpose |
|-----------|----------------|---------|
| `n8n_data` (Docker volume) | `/home/node/.n8n` | N8N configuration and workflows |
| `ollama_data` (Docker volume) | `/root/.ollama` | Ollama models and data |
| `C:/AI/ComfyUI/output` | `/comfy-output` | ComfyUI output integration |
| `./data` | `/data` | General data storage |
| `./doc` | `/doc` | Document processing |

## Access

- **N8N Interface**: http://localhost:5678
- **Ollama API**: http://localhost:11434

## Installed Components

- **N8N Latest** - Workflow automation platform
- **FFmpeg** - Video/audio processing
- **Tesseract OCR** - Text recognition (Thai + English support)
- **Ollama** - Large language models
- **Font Config** - Font management

## Common Operations

### Start/Stop Services
```bash
# Start in detached mode
docker-compose up -d

# Stop services
docker-compose down

# Rebuild and start
docker-compose up -d --build
```

### View Logs
```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f n8n
docker-compose logs -f ollama
```

### Access Container Shell
```bash
# Access n8n container
docker exec -it <container_name> sh

# Check container names
docker ps
```

## Pulling Ollama Models

To use a model with Ollama, you first need to pull it:

```bash
# Pull a model (e.g., llama3)
docker exec -it ollama ollama pull llama3

# List available models
docker exec -it ollama ollama list

# Pull other popular models
docker exec -it ollama ollama pull codellama
docker exec -it ollama ollama pull mistral
```

## Using Tesseract OCR

### For Images (Direct OCR)

**Execute Command Node:**
```bash
tesseract /data/input-image.png stdout -l tha+eng --psm 6
```

### For PDFs (Convert then OCR)

**Step 1: Convert PDF to PNG (Execute Command Node)**
```bash
pdftoppm -png -f 1 -l 1 /data/input-image.pdf /data/page
```

**Step 2: OCR the converted image (Execute Command Node)**
```bash
tesseract /data/page-1.png stdout -l tha+eng --psm 6
```

### OCR Parameter Tuning

**Page Segmentation Modes (PSM):**
- `--psm 3` - Fully automatic page segmentation (default)
- `--psm 6` - Assume a single uniform block of text
- `--psm 7` - Treat the image as a single text line  
- `--psm 8` - Treat the image as a single word

**OCR Engine Modes (OEM):**
- `--oem 1` - Neural nets LSTM engine only
- `--oem 3` - Default (based on what is available)

**Example with Parameters:**
```bash
tesseract /data/image.png stdout -l tha+eng --psm 6 --oem 1
```

## Using Ollama in N8N

1. **Add Ollama Node** to your workflow
2. **Set Base URL** to `http://ollama:11434`  
3. **Choose Model** that you've pulled (e.g., `llama3`)
4. **Configure** your prompts and parameters

## Example Workflow: Thai Document OCR to Google Sheets

This repository includes a complete workflow for processing Thai government documents:

### Workflow Components:
1. **Manual Trigger** - Start the workflow
2. **Convert PDF to PNG** - Using pdftoppm command
3. **OCR by Tesseract** - Extract text with Thai+English support
4. **Structure Text to JSON with LLM** - Use AI to structure extracted text
5. **Parse JSON to Sheet Format** - Clean and format the data
6. **Save to Google Sheet** - Store structured data

### Extracted Fields:
- **book_id** - Document number
- **date** - Document date
- **subject** - Document subject
- **to** - Recipient
- **attach** - Attachments
- **detail** - Document content
- **signed_by** - Signatory name
- **signed_by2** - Signatory position
- **contact_phone** - Contact phone
- **contact_email** - Contact email
- **contact_fax** - Contact fax
- **download_url** - Download link

### LLM Integration:
The workflow uses OpenRouter Chat Model (qwen/qwen3-8b:free) to intelligently extract and structure information from OCR text into a standardized JSON format suitable for database storage.

## Supported OCR Languages

- **Thai** (`tha`)
- **English** (`eng`) 
- **Multi-language** (`tha+eng`)

Additional language packs can be installed by modifying the Dockerfile.

## Security Notes

- **Change default N8N credentials** before production use
- **Ollama API** is unauthenticated and exposed locally
- **Ensure containers** are not accessible from untrusted networks

## Troubleshooting

### OCR Issues
- Ensure images are **clear and high resolution** for better accuracy
- Use **ImageMagick** to preprocess images: `convert input.jpg -enhance -sharpen 0x1 output.jpg`
- Test different **PSM values**: `--psm 3`, `--psm 6`, `--psm 8`
- Check **language codes** are correct

### Font Issues
- Place custom fonts in the `fonts/` directory **before building**
- Run `fc-cache -f -v` inside container if fonts aren't recognized

### PDF Processing
- PDFs must be **converted to images** before OCR
- Use `pdftoppm` for PDF to image conversion
- Consider **image quality** settings for better OCR results

### Container Issues
- Check **logs** with `docker-compose logs -f`
- Verify **ports** are not in use by other services
- Ensure **sufficient disk space** for volumes

## Example Workflows

### Simple OCR Workflow
```
[Manual Trigger] → [Execute Command: OCR] → [Process Text] → [Output]
```

### PDF Processing Workflow  
```
[File Trigger] → [Convert PDF] → [OCR Text] → [AI Analysis] → [Store Results]
```

### Thai Document Processing (Included)
```
[Manual Trigger] → [PDF to PNG] → [Tesseract OCR] → [LLM Structuring] → [JSON Parse] → [Google Sheets]
```

---
![Alt text](https://drive.google.com/thumbnail?id=1qVyaDbdnTU-z6uKLTpMaOKX0ZAedFRQP&sz=w1200)
