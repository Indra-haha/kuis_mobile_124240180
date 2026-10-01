import 'package:flutter/material.dart';

import '../data.dart';
import '../favorite_store.dart';
import 'home_page.dart';

/// Halaman Login.
///
/// Mengumpulkan username dan password, memvalidasi input kosong, lalu
/// meneruskan username ke halaman Home.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  /// Menentukan apakah isi password ditampilkan atau disembunyikan.
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Mengisi form dengan akun demo sehingga mudah diuji.
  void _fillDemoAccount() {
    setState(() {
      _usernameController.text = user1.username;
      _passwordController.text = user1.password;
    });
  }

  void _login() {
    FocusScope.of(context).unfocus();

    // Validasi input kosong. Pesan error ditampilkan oleh validator.
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Username dan password wajib diisi"),
            backgroundColor: Colors.red,
          ),
        );
      return;
    }

    final String username = _usernameController.text.trim();
    final String password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    // Simulasi proses login agar terlihat seperti aplikasi sungguhan.
    Future<void>.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
      });

      if (username != user1.username || password != user1.password) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text("Username atau password salah"),
              backgroundColor: Colors.red,
            ),
          );
        return;
      }

      // Login berhasil: reset favorite lalu arahkan ke Home.
      FavoriteStore.reset();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>
              HomePage(username: username, fullName: user1.name),
        ),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _LoginHeader(),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      hintText: "Masukkan username",
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Username tidak boleh kosong";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: "Password",
                      hintText: "Masukkan password",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                        tooltip: _obscurePassword
                            ? "Tampilkan password"
                            : "Sembunyikan password",
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      return null;
                    },
                    onFieldSubmitted: (String value) => _login(),
                  ),
                  const SizedBox(height: 12),
                  _DemoAccountHint(onTap: _fillDemoAccount),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _login,
                      child: _isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text("LOGIN"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.6, end: 1),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutBack,
          builder: (BuildContext context, double value, Widget? child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Container(
            height: 108,
            width: 108,
            decoration: BoxDecoration(
              color: const Color(0xFFD32F2F),
              borderRadius: BorderRadius.circular(32),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x33D32F2F),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.ramen_dining, size: 60, color: Colors.white),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Gacoan",
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFFD32F2F),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Katalog Menu Gacoan",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

class _DemoAccountHint extends StatelessWidget {
  const _DemoAccountHint({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF3E0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFE0B2)),
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.info_outline, color: Color(0xFFEF6C00), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                "Akun demo: ${user1.username} / ${user1.password}\n"
                "Ketuk untuk mengisi otomatis",
                style: const TextStyle(fontSize: 12, color: Color(0xFFE65100)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}