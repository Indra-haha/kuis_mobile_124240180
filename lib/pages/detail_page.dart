import 'package:flutter/material.dart';

import '../data.dart';
import '../favorite_store.dart';
import '../widgets/menu_image.dart';

/// Halaman Detail Menu.
///
/// Data menu yang ditampilkan berasal dari menu yang dipilih pada halaman Home.
class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.menu});

  final Menu menu;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _quantity = 1;

  Menu get menu => widget.menu;

  int get _totalPrice => menu.price * _quantity;

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
              child: MenuImage(
                menu: menu,
                width: double.infinity,
                height: 240,
              ),
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
                          menu.name,
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
                        icon: Icons.local_dining,
                        background: theme.colorScheme.primaryContainer,
                        foreground: theme.colorScheme.onPrimaryContainer,
                      ),
                      _Tag(
                        label: menu.spicyLabel,
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
                    value: formatRupiah(menu.price),
                    highlight: true,
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: Icons.category_outlined,
                    label: "Kategori",
                    value: menu.category,
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
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              "Jumlah",
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            IconButton.outlined(
                              visualDensity: VisualDensity.compact,
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              icon: const Icon(Icons.remove),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "$_quantity",
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton.outlined(
                              visualDensity: VisualDensity.compact,
                              onPressed: () => setState(() => _quantity++),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          children: <Widget>[
                            Text(
                              "Total harga",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            const Spacer(),
                            Flexible(
                              child: Text(
                                formatRupiah(_totalPrice),
                                textAlign: TextAlign.right,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              content: Text(
                                "$_quantity x ${menu.name} "
                                "(${formatRupiah(_totalPrice)}) ditambahkan",
                              ),
                            ),
                          );
                      },
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text("Pesan Sekarang"),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: _backToHome,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Kembali ke Home"),
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