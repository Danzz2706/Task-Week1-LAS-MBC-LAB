# Dockerfile (Versi dengan Entrypoint)
FROM python:3.9-slim

# Install 'netcat' yang dibutuhkan oleh entrypoint script
# 'procps' juga berguna untuk beberapa hal, baik untuk dimiliki
RUN apt-get update && apt-get install -y netcat-traditional procps

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Salin semua file, termasuk entrypoint.sh
COPY . .

# Berikan izin eksekusi pada script
RUN chmod +x /app/entrypoint.sh

# Set entrypoint ke script kita
ENTRYPOINT ["/app/entrypoint.sh"]

# Perintah default yang akan dijalankan oleh entrypoint setelah Redis siap
CMD ["python", "app.py"]
