import 'package:flutter/material.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.user,
    required this.onLogout,
  });
  final dynamic user;
  final VoidCallback onLogout;

  Future<void> _konfirmasiLogout(BuildContext context) async {
    final mauLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Yakin ingin keluar dari akun?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (mauLogout == true) {
      onLogout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          children: [
            const SizedBox(height: 8),
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  user.username,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                user.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                user.username,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _konfirmasiLogout(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: theme.colorScheme.error,
                  side: BorderSide(color: theme.colorScheme.error),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
