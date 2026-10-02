import 'package:flutter/material.dart';

import '../data.dart';
import '../favorite_store.dart';
import '../widgets/menu_image.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.menu});

  final Shoe menu;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Shoe get menu => widget.menu;

  void _backToHome() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Menu"),
        leading: IconButton(
          onPressed: _backToHome,
          icon: const Icon(Icons.arrow_back),
          tooltip: "Kembali ke Home",
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Hero(
              tag: "menu-image-${menu.id}",
              child: MenuImage(menu: menu, width: double.infinity, height: 240),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          menu.shoeName,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ValueListenableBuilder<Set<int>>(
                        valueListenable: FavoriteStore.favorites,
                        builder:
                            (
                              BuildContext context,
                              Set<int> value,
                              Widget? child,
                            ) {
                              final bool isFavorite = value.contains(menu.id);
                              return IconButton.filledTonal(
                                onPressed: () => FavoriteStore.toggle(menu.id),
                                tooltip: isFavorite
                                    ? "Hapus dari favorite"
                                    : "Tambah favorite",
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite ? Colors.red : null,
                                ),
                              );
                            },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      _Tag(
                        label: menu.category,
                        icon: Icons.local_fire_department,
                        background: const Color(0xFFFFE3E3),
                        foreground: const Color(0xFFD32F2F),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  _InfoRow(
                    icon: Icons.sell_outlined,
                    label: "Harga",
                    value: menu.price,
                    highlight: true,
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      _InfoRow(
                        icon: Icons.category_outlined,
                        label: "Jumlah Produk",
                        value: "",
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            "Like ${menu.likes}",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Stock ${menu.stock}",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      _InfoRow(
                        icon: Icons.category_outlined,
                        label: "Ukuran",
                        value: "",
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            itemCount: menu.sizes.length,
                            itemBuilder: (BuildContext context, int index) {
                              final String size = menu.sizes[index];
                              return SizedBox(
                                width: 2,
                                height: 2,
                                child: Text(
                                  size,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Deskripsi",
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),
                  Text(
                    menu.description,
                    textAlign: TextAlign.justify,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.icon,
    required this.background,
    required this.foreground,
  });

  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 14, color: foreground),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Text(
          "$label: ",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: highlight ? theme.colorScheme.primary : null,
            ),
          ),
        ),
      ],
    );
  }
}
