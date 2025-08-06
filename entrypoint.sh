#!/bin/sh
# entrypoint.sh

# Ambil host dan port redis dari environment variable,
# atau gunakan default jika tidak ada.
REDIS_HOST=${REDIS_HOST:-redis}
REDIS_PORT=${REDIS_PORT:-6379}

# Ulangi terus sampai Redis siap
# 'nc' (netcat) adalah alat untuk memeriksa koneksi jaringan
while ! nc -z $REDIS_HOST $REDIS_PORT; do
  echo "Tunggu sebentar, Redis belum siap..."
  sleep 1
done

echo "Redis sudah siap! Menjalankan aplikasi..."
# Jalankan perintah utama yang diberikan ke kontainer
# (dalam kasus ini, "python app.py")
exec "$@"
