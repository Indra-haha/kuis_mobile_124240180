import 'package:flutter/material.dart';
import '../root_page.dart';

import '../data.dart';
import '../favorite_store.dart';

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


  void _login() {
    FocusScope.of(context).unfocus();

    // Validasi input kosong. Pesan error ditampilkan oleh validator.
    if (!(_formKey.currentState?.validate() ?? false)) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text("Username dan password wajib diisi"),
            backgroundColor: Colors.blue,
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

      if (username != user.username || password != user.password) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text("Username atau password salah"),
              backgroundColor: Colors.blue,
            ),
          );
        return;
      }

      // Login berhasil: reset favorite lalu arahkan ke Home.
      FavoriteStore.reset();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              RootPage(user : user),
        ),
        (route) => false,
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
          child: SizedBox(
            height: 200,
            width: 200,
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9Q8Ls4f_a0MIqSmz9Zj_GHOB7GvBslkNbESYWMzd9mw&s=10",
              fit: BoxFit.cover,
              errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
                return Container(
                  color: const Color(0xFFFFE3E3),
                  alignment: Alignment.center,
                  child: const Icon(Icons.shopping_bag, color: Color(0xFFD32F2F), size: 64),
                );
              },
              loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  color: Colors.grey.shade100,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Selamat Datang di Toko Sepatu",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
         const SizedBox(height: 4),
        Text(
          "Selamat Belanja",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

