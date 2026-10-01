/// Model data untuk aplikasi Katalog Menu Gacoan.
///
/// Struktur model ini mengikuti model pada repository acuan
/// https://github.com/ZakinandaFaishal/latkuis/blob/main/data.dart
/// dan dikembangkan agar siap dipakai pada halaman Login, Home,
/// Detail Menu, dan Profil.
library;

/// Model data user (akun) Gacoan.
class User {
  String username;
  String password;
  String name;

  User({required this.username, required this.password, required this.name});
}

/// Akun demo yang dapat dipakai untuk masuk ke aplikasi.
User user1 = User(username: "admingacoan", password: "1221", name: "Jokowi");

/// Model data menu Gacoan.
class Menu {
  int id;
  String name;
  String category;
  String description;

  /// Harga menu dalam satuan Rupiah (tanpa titik pemisah).
  int price;

  /// Nama file gambar pada folder `assets/images`.
  String image;

  /// Level kepedasan 0 (tidak pedas) sampai 3 (ekstra pedas).
  int spicyLevel;

  Menu({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.price,
    required this.image,
    this.spicyLevel = 0,
  });

  /// Label level kepedasan yang mudah dibaca pengguna.
  String get spicyLabel {
    switch (spicyLevel) {
      case 1:
        return "Level 1 - Sedang";
      case 2:
        return "Level 2 - Pedas";
      case 3:
        return "Level 3 - Extra Pedas";
      default:
        return "Tidak Pedas";
    }
  }
}

/// Daftar seluruh menu Gacoan yang ditampilkan pada halaman katalog.
final List<Menu> menus = [
  Menu(
    id: 1,
    name: "Mie Gacoan",
    category: "Mie",
    price: 12000,
    image: "assets/images/mie_gacoan.jpg",
    spicyLevel: 2,
    description:
        "Mie ayam jahe khas Gacoan dengan potongan ayam, kembang goyang, "
        "serta kaldu jahe yang gurih. Tersedia level kepedasan 0 sampai 3.",
  ),
  Menu(
    id: 2,
    name: "Mie Hompimpa",
    category: "Mie",
    price: 12000,
    image: "assets/images/mie_aceh.jpg",
    spicyLevel: 2,
    description:
        "Mie bergaya Aceh dengan cita rasa kaldu bening dan potongan daging "
        "yang menggugah selera. Cocok dicocolkan dengan kerupuk.",
  ),
  Menu(
    id: 3,
    name: "Mie Suit",
    category: "Mie",
    price: 12000,
    image: "assets/images/mie_suit.jpg",
    spicyLevel: 1,
    description:
        "Mie dengan cita rasa gurih yang lebih ringan dan tidak terlalu "
        "pedas. Cocok untuk kamu yang menyukai rasa gurih tanpa terlalu pedas.",
  ),
  Menu(
    id: 4,
    name: "Udang Keju",
    category: "Dimsum",
    price: 12000,
    image: "assets/images/udang_keju.jpg",
    spicyLevel: 0,
    description:
        "Dimsum udang dengan isian keju creamy yang gurih, dibungkus kulit "
        "pangsit tipis dan dikukus sampai matang sempurna.",
  ),
  Menu(
    id: 5,
    name: "Udang Rambutan",
    category: "Dimsum",
    price: 12000,
    image: "assets/images/udang_rambutan.jpg",
    spicyLevel: 0,
    description:
        "Dimsum udang dengan tekstur kulit yang renyah dan rasa udang segar "
        "di setiap gigitannya. Favorit pelanggan kami.",
  ),
  Menu(
    id: 6,
    name: "Pangsit Goreng",
    category: "Dimsum",
    price: 12000,
    image: "assets/images/pangsit_goreng.jpg",
    spicyLevel: 1,
    description:
        "Pangsit goreng dengan tekstur renyah dan gurih, diisi daging "
        "cincang kecap manis. Cocok menjadi teman ngobrol sore.",
  ),
  Menu(
    id: 7,
    name: "Es Gobak Sodor",
    category: "Minuman",
    price: 9000,
    image: "assets/images/es_gobak_sodor.jpg",
    spicyLevel: 0,
    description:
        "Minuman dingin khas Gacoan yang menyegarkan dengan cita rasa "
        "manis dan sedikit asam, dicampur es serut dan nata de coco.",
  ),
  Menu(
    id: 8,
    name: "Es Teklek",
    category: "Minuman",
    price: 9000,
    image: "assets/images/es_teklek.jpg",
    spicyLevel: 0,
    description:
        "Minuman es warna-warni khas Gacoan berisi jelly, nata de coco, "
        "serta campuran buah yang menyegarkan.",
  ),
  Menu(
    id: 9,
    name: "Es Tea",
    category: "Minuman",
    price: 6000,
    image: "assets/images/es_tea.jpg",
    spicyLevel: 0,
    description:
        "Es teh segar dengan cita rasa manis yang menyegarkan, pilihan "
        "teh original untuk menyertai hidangan berat Gacoan.",
  ),
];

/// Daftar seluruh kategori menu yang unik, dipakai untuk filter kategori.
List<String> get menuCategories {
  final Set<String> categories = <String>{};
  for (final menu in menus) {
    categories.add(menu.category);
  }
  return categories.toList();
}

/// Mengubah angka menjadi format Rupiah, contoh: 12000 menjadi Rp12.000.
String formatRupiah(int value) {
  final String digits = value.toString();
  final StringBuffer buffer = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buffer.write(".");
    }
    buffer.write(digits[i]);
  }
  return "Rp$buffer";
}