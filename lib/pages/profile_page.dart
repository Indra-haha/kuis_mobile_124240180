import 'package:flutter/material.dart';

import '../data.dart';
import '../favorite_store.dart';
import 'login_page.dart';

/// Halaman Profil.
///
/// Menampilkan username yang berasal dari halaman Login (bukan hardcode)
/// dan menyediakan tombol logout yang mengembalikan pengguna ke halaman Login
/// tanpa menyisakan halaman Home pada navigation stack.
class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.username,
    required this.fullName,
  });

  /// Username yang diteruskan dari halaman Login.
  final String username;

  /// Nama lengkap pengguna dari data akun.
  final String fullName;

  void _logout(BuildContext context) {
    FocusScope.of(context).unfocus();

    // Hapus semua halaman yang ada di stack lalu kembali ke Login.
    // Dengan demikian tombol Back tidak dapat kembali ke Home.
    FavoriteStore.reset();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (BuildContext context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String initial = username.isNotEmpty
        ? username.substring(0, 1).toUpperCase()
        : "G";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          tooltip: "Kembali",
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: <Widget>[
          Card(
            elevation: 0,
            color: theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD32F2F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    // Nama pengguna berasal dari hasil login.
                    username,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fullName,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Chip(
                    avatar: const Icon(Icons.verified, size: 18),
                    label: const Text("Pengguna Terdaftar"),
                    backgroundColor: Colors.white,
                    labelStyle: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFD32F2F),
                      fontWeight: FontWeight.w600,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _StatRow(
            username: username,
            fullName: fullName,
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text("Nama Lengkap"),
                  subtitle: Text(fullName),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.alternate_email),
                  title: const Text("Username"),
                  subtitle: Text(username),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.storefront_outlined),
                  title: const Text("Toko"),
                  subtitle: const Text("Gacoan"),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _logout(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFD32F2F),
                side: const BorderSide(color: Color(0xFFD32F2F)),
              ),
              icon: const Icon(Icons.logout),
              label: const Text("LOGOUT"),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.username, required this.fullName});

  final String username;
  final String fullName;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _StatCard(
            label: "Menu",
            value: "${menus.length}",
            icon: Icons.restaurant_menu,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            label: "Kategori",
            value: "${menuCategories.length}",
            icon: Icons.category_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ValueListenableBuilder<Set<int>>(
            valueListenable: FavoriteStore.favorites,
            builder: (BuildContext context, Set<int> value, Widget? child) {
              return _StatCard(
                label: "Favorite",
                value: "${value.length}",
                icon: Icons.favorite,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, color: theme.colorScheme.primary, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}