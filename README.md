# Secure Web with Docker Secret

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![Redis](https://img.shields.io/badge/redis-%23DD0031.svg?&style=for-the-badge&logo=redis&logoColor=white)

---

## 📝 Deskripsi Proyek

Proyek ini merupakan implementasi dari aplikasi web sederhana yang dibangun untuk mendemonstrasikan penggunaan Docker dalam lingkungan pengembangan dan produksi. Aplikasi ini menggunakan Python dengan framework Flask sebagai backend dan Redis sebagai database untuk menyimpan pesan dari pengguna. Fokus utama proyek adalah pada keamanan koneksi database menggunakan **Docker Secret** dan analisis perbandingan antara metode deployment **Docker Compose** dan **Docker Swarm**.

---

## 🏛️ Arsitektur Aplikasi

Arsitektur sistem ini dirancang agar setiap komponen berjalan dalam kontainer yang terisolasi namun dapat berkomunikasi melalui jaringan internal Docker.

(<img width="940" height="1127" alt="image" src="https://github.com/user-attachments/assets/9afff9e9-0505-4a79-abb1-d39d3cba20f4" />

*(Diagram ini diambil dari spesifikasi tugas)*

* **Web App (Flask)**: Bertanggung jawab atas logika bisnis dan penyajian antarmuka kepada pengguna.
* **Redis**: Berfungsi sebagai database in-memory yang cepat untuk menyimpan log pesan.
* **Docker Secret**: Mengelola kata sandi Redis secara aman, membuatnya tersedia hanya untuk layanan yang berhak tanpa mengeksposnya di dalam kode atau konfigurasi.

---

## 🛠️ Teknologi yang Digunakan

* **Backend**: Python 3.9, Flask
* **Database**: Redis
* **Platform**: Docker Engine
* **Orkestrasi**: Docker Compose & Docker Swarm

---

## 📂 Struktur Proyek

 ```bash
   ┌──(root㉿Laptop-zaidan)-[/mnt/c/Users/ZAIDAN KAMIL M/docker-project]
└─# tree
.
├── app.py
├── docker-compose.yml
├── Dockerfile
├── entrypoint.sh
├── redis_password.txt
├── requirements.txt
└── templates
    └── index.html
 ```

## 🚀 Prasyarat

* **Docker Desktop**: Terinstal dan berjalan di sistem operasi Anda (Windows, macOS, atau Linux).
* **Git**: Untuk melakukan clone repositori.

---

## ⚙️ Cara Menjalankan

### Mode 1: Lingkungan Pengembangan (Docker Compose)

Metode ini cocok untuk menjalankan dan menguji aplikasi secara cepat di mesin lokal.

1.  **Clone Repositori**
    ```bash
    git clone [URL_GITHUB_ANDA]
    cd [NAMA_FOLDER_PROYEK]
    ```
2.  **Bangun dan Jalankan Kontainer**
    Perintah ini akan membangun image jika belum ada dan menjalankan semua layanan yang didefinisikan di `docker-compose.yml`.
    ```bash
    docker-compose up --build
    ```
3.  **Akses Aplikasi**
    Buka browser dan kunjungi alamat `http://localhost:5000`.

4.  **Hentikan Aplikasi**
    Tekan `Ctrl + C` di terminal, lalu jalankan perintah berikut untuk membersihkan kontainer dan jaringan.
    ```bash
    docker-compose down
    ```

### Mode 2: Lingkungan Produksi (Docker Swarm)

Metode ini mensimulasikan bagaimana aplikasi di-deploy sebagai sebuah *stack* yang terorkestrasi.

1.  **Inisialisasi Swarm** (Hanya perlu dijalankan sekali)
    ```bash
    docker swarm init
    ```
2.  **Bangun Image Aplikasi**
    `docker swarm` tidak membangun image secara otomatis. Kita harus membangunnya terlebih dahulu.
    ```bash
    docker-compose build
    ```
3.  **Deploy Stack**
    Perintah ini akan men-deploy layanan-layanan ke dalam Swarm.
    ```bash
    docker stack deploy -c docker-compose.yml myapp
    ```
4.  **Akses Aplikasi**
    Buka browser Anda dan kunjungi `http://localhost:5000`.

5.  **Hentikan Stack**
    Untuk mematikan dan menghapus semua layanan dari stack, jalankan:
    ```bash
    docker stack rm myapp
    ```

---
## 🔍 Verifikasi dan Debugging

Berikut adalah cara untuk memeriksa langsung isi dari *secret* dan data di dalam Redis saat kontainer sedang berjalan.

### 1. Memeriksa Isi Docker Secret

Untuk membuktikan bahwa *secret* berhasil di-mount, kita akan masuk ke dalam kontainer `webapp` dan melihat isi file-nya.

1.  **Cari Nama Kontainer Web App**
    ```bash
    docker ps
    ```
    * Jika menggunakan **Compose**, cari nama seperti `docker-project_webapp_1`.
    * Jika menggunakan **Swarm**, cari nama seperti `myapp_webapp.1...`.

2.  **Masuk ke Dalam Shell Kontainer**
    ```bash
    # Ganti <NAMA_CONTAINER> dengan nama yang sesuai
    docker exec -it <NAMA_CONTAINER> sh
    ```

3.  **Lihat Isi File Secret**
    Di dalam shell kontainer, jalankan:
    ```sh
    cat /run/secrets/redis_password
    ```
    Perintah ini akan menampilkan kata sandi Anda, membuktikan *secret* telah terpasang.

4.  **Keluar**
    Ketik `exit` dan tekan Enter.

### 2. Memeriksa Data Langsung di Redis

Untuk melihat data pesan langsung dari database, kita akan masuk ke dalam kontainer `redis`.

1.  **Cari Nama Kontainer Redis**
    ```bash
    docker ps
    ```
    * Jika menggunakan **Compose**, cari nama seperti `docker-project_redis_1`.
    * Jika menggunakan **Swarm**, cari nama seperti `myapp_redis.1...`.

2.  **Masuk ke Dalam Shell Kontainer**
    ```bash
    # Ganti <NAMA_CONTAINER> dengan nama yang sesuai
    docker exec -it <NAMA_CONTAINER> sh
    ```

3.  **Hubungkan ke Klien Redis**
    Di dalam shell kontainer, jalankan perintah berikut untuk terhubung ke database dengan password dari *secret*.
    ```sh
    redis-cli -a $(cat /run/secrets/redis_password)
    ```

4.  **Tampilkan Semua Pesan**
    Setelah prompt berubah menjadi `127.0.0.1:6379>`, jalankan perintah Redis ini:
    ```redis
    LRANGE log_pesan 0 -1
    ```
    Ini akan menampilkan semua pesan yang tersimpan di dalam list `log_pesan`.

5.  **Keluar**
    Ketik `exit` untuk keluar dari klien Redis, lalu ketik `exit` lagi untuk keluar dari shell kontainer.

---

## 🧠 Analisis dan Konsep Kunci

* **Perbedaan Compose vs. Swarm**
    Perbedaan utamanya adalah skala dan orkestrasi. **Compose** ideal untuk pengembangan di **satu host**, sedangkan **Swarm** adalah orkestrator untuk produksi di **banyak host** yang menyediakan fitur canggih seperti scaling, load balancing, dan self-healing.

* **Persistensi Data dengan Volume**
    Data Redis tetap aman meskipun kontainernya dihapus. Ini karena data disimpan di **Docker Volume**, yang siklus hidupnya terpisah dari kontainer. Saat kontainer baru dibuat, ia akan terhubung kembali ke volume yang sama dan datanya akan tetap ada.

* **Isolasi Cache (Volume)**
    Cache (data) Redis **tidak sama** antara mode Compose dan Swarm. Alasannya adalah karena masing-masing mode membuat volume penyimpanannya sendiri (`proyek-docker_redis_data` vs. `myapp_redis_data`), sehingga tidak ada data yang dibagikan di antara keduanya.

* **Keamanan dengan Docker Secret**
    Password Redis tidak ditulis langsung dalam kode, melainkan dikelola oleh **Docker Secret**. Docker menyimpan *secret* ini secara terenkripsi dan hanya memberikannya kepada kontainer yang berhak dalam bentuk file sementara di `/run/secrets/`. Ini adalah praktik terbaik untuk mengelola data sensitif.

* **Kesiapan Layanan (Readiness)**
    Penggunaan `entrypoint.sh` memastikan aplikasi web tidak akan dimulai sebelum database Redis benar-benar siap menerima koneksi. Ini sangat penting dalam lingkungan terdistribusi seperti Swarm untuk mencegah error saat startup.

---

## ✍️ Author

* **Zaidan Kamil Munadi** 
