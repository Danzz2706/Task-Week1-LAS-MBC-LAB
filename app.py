# app.py
import os
from flask import Flask, render_template, request, redirect, url_for
import redis

app = Flask(__name__)

REDIS_HOST = os.environ.get('REDIS_HOST', 'localhost')
REDIS_PORT = int(os.environ.get('REDIS_PORT', 6379))

def get_redis_password():
    try:
        with open('/run/secrets/redis_password', 'r') as secret_file:
            return secret_file.read().strip()
    except IOError:
        return None

REDIS_PASSWORD = get_redis_password()

try:
    r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, password=REDIS_PASSWORD, db=0, decode_responses=True)
    r.ping()
    print("Berhasil terhubung ke Redis.")
except Exception as e:
    print(f"Gagal terhubung ke Redis: {e}")
    r = None

@app.route('/', methods=['GET', 'POST'])
def index():
    if request.method == 'POST':
        if r:
            pesan = request.form['pesan']
            r.lpush('log_pesan', pesan)
        return redirect(url_for('index'))

    logs = []
    if r:
        logs = r.lrange('log_pesan', 0, 9)

    return render_template('index.html', logs=logs)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
