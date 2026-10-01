import 'package:flutter/material.dart';

import '../data.dart';
import '../favorite_store.dart';
import '../widgets/menu_image.dart';
import 'detail_page.dart';
import 'profile_page.dart';

/// Halaman Home / Katalog Menu.
///
/// Menampilkan seluruh menu Gacoan dengan `ListView`, menyediakan fitur
/// pencarian, filter kategori, dan favorite sebagai bonus.
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.username, required this.fullName});

  /// Username hasil login, diteruskan dari halaman Login.
  final String username;

  /// Nama lengkap pengguna dari data akun.
  final String fullName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = "";
  String _selectedCategory = "Semua";

  static const String _allCategory = "Semua";

  List<String> get _categories => <String>[
    _allCategory,
    ...menuCategories,
  ];

  List<Menu> get _filteredMenus {
    final String keyword = _query.trim().toLowerCase();
    return menus.where((Menu menu) {
      final bool matchCategory =
          _selectedCategory == _allCategory || menu.category == _selectedCategory;
      final bool matchSearch =
          keyword.isEmpty ||
          menu.name.toLowerCase().contains(keyword) ||
          menu.category.toLowerCase().contains(keyword);
      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(Menu menu) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => DetailPage(menu: menu),
      ),
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => ProfilePage(
          username: widget.username,
          fullName: widget.fullName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Menu> visibleMenus = _filteredMenus;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text("Gacoan", style: TextStyle(fontSize: 20)),
            Text(
              "Halo, ${widget.username}!",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.onPrimary.withValues(
                  alpha: 0.85,
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _openProfile,
            tooltip: "Profil",
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openProfile,
        icon: const Icon(Icons.account_circle),
        label: const Text("Profil"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: (String value) => setState(() => _query = value),
              decoration: InputDecoration(
                hintText: "Cari menu Gacoan...",
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = "");
                        },
                        icon: const Icon(Icons.clear),
                        tooltip: "Hapus pencarian",
                      ),
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              children: _categories.map((String category) {
                final bool selected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (bool value) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: <Widget>[
                Text(
                  "${visibleMenus.length} menu ditemukan",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                const Spacer(),
                ValueListenableBuilder<Set<int>>(
                  valueListenable: FavoriteStore.favorites,
                  builder: (BuildContext context, Set<int> value, Widget? child) {
                    return Text(
                      "${value.length} favorite",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: visibleMenus.isEmpty
                ? _EmptyState(
                    keyword: _query,
                    onReset: () {
                      _searchController.clear();
                      setState(() {
                        _query = "";
                        _selectedCategory = _allCategory;
                      });
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: visibleMenus.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Menu menu = visibleMenus[index];
                      return _MenuCard(
                        menu: menu,
                        onTap: () => _openDetail(menu),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({required this.menu, required this.onTap});

  final Menu menu;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Hero(
                tag: "menu-image-${menu.id}",
                child: MenuImage(
                  menu: menu,
                  width: 96,
                  height: 96,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      menu.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        menu.category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      formatRupiah(menu.price),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              ValueListenableBuilder<Set<int>>(
                valueListenable: FavoriteStore.favorites,
                builder: (BuildContext context, Set<int> value, Widget? child) {
                  final bool isFavorite = value.contains(menu.id);
                  return IconButton(
                    onPressed: () => FavoriteStore.toggle(menu.id),
                    tooltip: isFavorite
                        ? "Hapus dari favorite"
                        : "Tambah favorite",
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.keyword, required this.onReset});

  final String keyword;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              keyword.isEmpty
                  ? "Tidak ada menu pada kategori ini"
                  : "Menu \"$keyword\" tidak ditemukan",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh),
              label: const Text("Tampilkan semua menu"),
            ),
          ],
        ),
      ),
    );
  }
}