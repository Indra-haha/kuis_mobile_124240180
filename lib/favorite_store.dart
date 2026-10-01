import 'package:flutter/material.dart';

/// Penyimpan status favorite menu.
///
/// Dipakai bersama oleh halaman Home dan halaman Detail Menu agar perubahan
/// favorite langsung tercermin di kedua halaman tanpa perlu passing state.
class FavoriteStore {
  static final ValueNotifier<Set<int>> favorites = ValueNotifier<Set<int>>(
    <int>{},
  );

  static bool isFavorite(int menuId) => favorites.value.contains(menuId);

  static int get count => favorites.value.length;

  static void toggle(int menuId) {
    final Set<int> next = Set<int>.from(favorites.value);
    if (!next.remove(menuId)) {
      next.add(menuId);
    }
    favorites.value = next;
  }

  static void reset() {
    favorites.value = <int>{};
  }
}