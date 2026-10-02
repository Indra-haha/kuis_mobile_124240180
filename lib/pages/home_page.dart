import 'package:flutter/material.dart';

import '../data.dart';
import '../favorite_store.dart';
import '../widgets/menu_image.dart';
import 'detail_page.dart';

class DaftarProduk extends StatefulWidget {
  const DaftarProduk({super.key});

  @override
  State<DaftarProduk> createState() => _DaftarProdukState();
}

class _DaftarProdukState extends State<DaftarProduk> {
  final TextEditingController _searchController = TextEditingController();
  String _query = "";
  String _selectedCategory = "Running";

  static const String _allCategory = "Semua";

  List<String> get _categories => <String>[
    _allCategory,
    ...menuCategories,
  ];

  List<Shoe> get _filteredMenus {
    final String keyword = _query.trim().toLowerCase();
    return menus.where((Shoe menu) {
      final bool matchCategory =
          _selectedCategory == _allCategory || menu.category == _selectedCategory;
      final bool matchSearch =
          keyword.isEmpty ||
          menu.shoeName.toLowerCase().contains(keyword) ||
          menu.category.toLowerCase().contains(keyword);
      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(Shoe menu) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => DetailPage(menu: menu),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final List<Shoe> visibleMenus = _filteredMenus;

    return Scaffold(
      appBar: AppBar(
          title: const Text("Home")
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
                hintText: "Cari menu Sepatu...",
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
                      final Shoe menu = visibleMenus[index];
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

  final Shoe menu;
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
          child: Column(
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
                      menu.shoeName,
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
                      menu.price,
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