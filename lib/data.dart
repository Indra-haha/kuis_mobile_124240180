class User {
  String username;
  String password;
  String name;

  User({required this.username, required this.password, required this.name});
}

User user = User(username: "indra", password: "180", name: "Indra Suryanto");

class Shoe {
  int id;
  String shoeName;
  String category;
  String description;
  String price;
  String image;
  int likes;
  int stock;
  List sizes;

  Shoe({
    required this.id,
    required this.shoeName,
    required this.category,
    required this.description,
    required this.price,
    required this.image,
    required this.likes,
    required this.stock,
    required this.sizes,
  });
}
final List<Shoe> menus = [
  Shoe(
    id: 201,
    shoeName: "Urban Runner X1",
    category: "Running",
    price: "Rp799.000",
    image:
        "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
    description:
        "Sepatu running ringan dengan desain modern yang nyaman digunakan untuk aktivitas sehari-hari.",
    likes: 34,
    stock: 24,
    sizes: ["39", "40", "41", "42", "43"],
  ),

  Shoe(
    id: 202,
    shoeName: "Street Classic Low",
    category: "Sneakers",
    price: "Rp649.000",
    image:
        "https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77",
    description:
        "Sneakers bergaya klasik dengan desain sederhana yang cocok dipadukan dengan berbagai outfit.",
    likes: 48,
    stock: 31,
    sizes: ["39", "40", "41", "42", "43", "44"],
  ),

  Shoe(
    id: 203,
    shoeName: "Velocity Pro",
    category: "Running",
    price: "Rp1.199.000",
    image:
        "https://images.unsplash.com/photo-1551107696-a4b0c5a0d9a2",
    description:
        "Sepatu performa tinggi dengan konstruksi ringan untuk mendukung aktivitas olahraga dan lari.",
    likes: 56,
    stock: 17,
    sizes: ["40", "41", "42", "43", "44"],
  ),

  Shoe(
    id: 204,
    shoeName: "Court Max",
    category: "Basketball",
    price: "Rp1.499.000",
    image:
        "https://images.unsplash.com/photo-1515955656352-a1fa3ffcd111",
    description:
        "Sepatu basketball dengan desain sporty dan sol yang dirancang untuk memberikan kestabilan.",
    likes: 67,
    stock: 14,
    sizes: ["40", "41", "42", "43", "44"],
  ),

  Shoe(
    id: 205,
    shoeName: "Daily Walk",
    category: "Lifestyle",
    price: "Rp549.000",
    image:
        "https://images.unsplash.com/photo-1495555961986-6d4c1ecb7be3",
    description:
        "Sepatu casual yang ringan dan nyaman untuk digunakan berjalan maupun aktivitas sehari-hari.",
    likes: 29,
    stock: 38,
    sizes: ["38", "39", "40", "41", "42"],
  ),

  Shoe(
    id: 206,
    shoeName: "Retro Court 90",
    category: "Sneakers",
    price: "Rp899.000",
    image:
        "https://images.unsplash.com/photo-1549298916-b41d501d3772",
    description:
        "Sneakers bergaya retro dengan kombinasi warna klasik dan desain yang timeless.",
    likes: 45,
    stock: 21,
    sizes: ["39", "40", "41", "42", "43"],
  ),

  Shoe(
    id: 207,
    shoeName: "Trail Explorer",
    category: "Outdoor",
    price: "Rp1.299.000",
    image:
        "https://images.unsplash.com/photo-1551698618-1dfe5d97d256",
    description:
        "Sepatu outdoor dengan desain kokoh yang cocok digunakan untuk aktivitas di berbagai medan.",
    likes: 38,
    stock: 16,
    sizes: ["40", "41", "42", "43", "44"],
  ),

  Shoe(
    id: 208,
    shoeName: "Cloud Step",
    category: "Running",
    price: "Rp949.000",
    image:
        "https://images.unsplash.com/photo-1552346154-21d32810aba3",
    description:
        "Sepatu dengan bantalan empuk untuk memberikan kenyamanan saat berjalan dan berlari.",
    likes: 52,
    stock: 27,
    sizes: ["39", "40", "41", "42", "43"],
  ),

  Shoe(
    id: 209,
    shoeName: "Street Flex",
    category: "Lifestyle",
    price: "Rp699.000",
    image:
        "https://images.unsplash.com/photo-1520256862855-398228c41684",
    description:
        "Sepatu lifestyle dengan desain minimalis yang cocok digunakan untuk aktivitas santai.",
    likes: 31,
    stock: 33,
    sizes: ["39", "40", "41", "42", "43"],
  ),

  Shoe(
    id: 210,
    shoeName: "Power Dunk",
    category: "Basketball",
    price: "Rp1.399.000",
    image:
        "https://images.unsplash.com/photo-1556817411-31ae72fa3ea0",
    description:
        "Sepatu basketball dengan desain sporty untuk menunjang pergerakan selama bermain.",
    likes: 61,
    stock: 12,
    sizes: ["40", "41", "42", "43", "44"],
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