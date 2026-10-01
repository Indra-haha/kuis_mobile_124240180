# Katalog Menu Gacoan

Aplikasi mobile sederhana katalog menu Gacoan menggunakan Flutter.
Berisi halaman Login, Home (Katalog Menu), Detail Menu, dan Profil.

## Akun Demo

| Username     | Password |
| ------------ | -------- |
| `admingacoan` | `1221`   |

Halaman Login menampilkan informasi akun demo. Ketuk kotak tersebut untuk
mengisi form secara otomatis.

## Menjalankan Aplikasi

```bash
flutter pub get
flutter run
```

Build APK:

```bash
flutter build apk --release
```

## Menjalankan Pengujian

```bash
flutter analyze
flutter test
```

## Struktur Source Code

```
lib/
├── main.dart                    # Root aplikasi dan tema
├── data.dart                    # Model User & Menu, daftar menu, format Rupiah
├── favorite_store.dart          # Penyimpanan status favorite (bonus)
├── pages/
│   ├── login_page.dart          # Halaman Login
│   ├── home_page.dart           # Halaman Home / Katalog Menu
│   ├── detail_page.dart         # Halaman Detail Menu
│   └── profile_page.dart        # Halaman Profil & Logout
└── widgets/
    └── menu_image.dart          # Widget gambar dengan placeholder
assets/images/                   # Gambar menu
```

## Fitur

### Halaman Login

- Input username dan password.
- Password ditampilkan tersembunyi, dapat ditampilkan lewat ikon mata.
- Validasi input kosong dengan pesan error per kolom.
- Validasi kredensial terhadap akun yang terdaftar.
- Loading indicator selama proses login.
- Login berhasil mengarahkan ke halaman Home.

### Halaman Home / Katalog Menu

- Menampilkan 9 menu Gacoan memakai `ListView.builder`.
- Setiap menu menampilkan gambar, nama, kategori, dan harga.
- Menu dapat diklik untuk membuka Detail Menu.
- Akses Profil melalui tombol AppBar dan tombol melayang.

### Halaman Detail Menu

- Data menu sesuai dengan menu yang dipilih pada Home.
- Menampilkan gambar, nama, kategori, harga, level kepedasan, deskripsi,
  pengatur jumlah, dan total harga.
- Tombol kembali pada AppBar dan tombol "Kembali ke Home".

### Halaman Profil & Logout

- Menampilkan username dari hasil Login, diteruskan dari Login ke Home lalu
  ke Profil, bukan hardcode.
- Ringkasan jumlah menu, kategori, dan favorite.
- Tombol Logout mengembalikan pengguna ke halaman Login.
- Setelah Logout, `pushAndRemoveUntil` mengosongkan navigation stack sehingga
  tombol Back tidak dapat kembali ke Home.

### Fitur Bonus

- Pencarian menu berdasarkan nama dan kategori.
- Filter kategori dengan `ChoiceChip` (Semua, Mie, Dimsum, Minuman).
- Favorite menu dengan indikator jumlah favorite.
- Animasi transisi gambar menggunakan `Hero` dan animasi skala logo Login.
- Grafis ringkasan pada halaman Profil.