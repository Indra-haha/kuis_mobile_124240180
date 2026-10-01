import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_lat_kuis/main.dart';
import 'package:testing_lat_kuis/data.dart';
import 'package:testing_lat_kuis/pages/detail_page.dart';
import 'package:testing_lat_kuis/pages/home_page.dart';
import 'package:testing_lat_kuis/pages/login_page.dart';
import 'package:testing_lat_kuis/pages/profile_page.dart';

/// Durasi penundaan Future.delayed pada halaman Login sebelum navigasi.
const Duration kLoginDelay = Duration(milliseconds: 700);

/// Ukuran layar ponsel yang digunakan agar pengujian meniru perangkat nyata.
const Size kPhoneSize = Size(412, 915);
const double kPhoneRatio = 3.0;

/// Menyesuaikan ukuran layar uji dan mengembalikan ukuran semula.
void usePhoneScreen(WidgetTester tester) {
  tester.view.devicePixelRatio = kPhoneRatio;
  tester.view.physicalSize = kPhoneSize * kPhoneRatio;
  addTearDown(tester.view.reset);
}

Future<void> pumpApp(WidgetTester tester) async {
  usePhoneScreen(tester);
  await tester.pumpWidget(const MyApp());
  await tester.pump();
}

/// Menggulir [scrollable] sampai widget yang dicari terlihat di layar.
///
/// Widget yang belum dibangun (item lazy pada ListView) akan dibangun
/// selama proses pengguliran.
Future<void> ensureVisible(
  WidgetTester tester,
  Finder finder, {
  Finder? scrollable,
  double delta = 80,
}) async {
  if (scrollable == null) {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    return;
  }
  await tester.scrollUntilVisible(finder, delta, scrollable: scrollable);
  await tester.pumpAndSettle();
}

/// Memastikan widget terlihat lalu menekan widget tersebut.
Future<void> scrollToAndTap(
  WidgetTester tester,
  Finder finder, {
  Finder? scrollable,
}) async {
  await ensureVisible(tester, finder, scrollable: scrollable);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Scrollable daftar menu pada halaman Home.
Finder menuListFinder() => find.descendant(
  of: find.byType(ListView),
  matching: find.byType(Scrollable),
).last;

/// Membuka Detail Menu dengan cara memfilter katalog lewat kolom pencarian.
///
/// Dipakai untuk menu yang berada jauh di bawah daftar sehingga tidak
/// tersedia di layar tanpa pengguliran.
Future<void> openMenuBySearch(WidgetTester tester, String keyword) async {
  await tester.enterText(find.byType(TextField).first, keyword);
  await tester.pumpAndSettle();
  expect(
    find.text("1 menu ditemukan"),
    findsOneWidget,
    reason: "pencarian \"$keyword\" harus menyisakan satu menu",
  );

  // Tekan judul menu di dalam kartu katalog, bukan teks pada kolom pencarian.
  final Finder cardTitle = find.descendant(
    of: find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Card),
    ),
    matching: find.text(keyword),
  );
  expect(cardTitle, findsOneWidget);
  await tester.tap(cardTitle);
  await tester.pumpAndSettle();
  expect(find.byType(DetailPage), findsOneWidget);
}

/// Kolom password adalahEditableText kedua pada halaman Login.
bool passwordIsObscured(WidgetTester tester) {
  final EditableText editable = tester.widget<EditableText>(
    find.byType(EditableText).at(1),
  );
  return editable.obscureText;
}

Future<void> loginAsDemo(WidgetTester tester) async {
  await tester.enterText(find.byType(TextFormField).at(0), user1.username);
  await tester.enterText(find.byType(TextFormField).at(1), user1.password);
  await tester.tap(find.text("LOGIN"));
  await tester.pump();
  await tester.pump(kLoginDelay);
  await tester.pumpAndSettle();
}

void main() {
  group("Halaman Login", () {
    testWidgets("menampilkan field username dan password", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.text("Username"), findsOneWidget);
      expect(find.text("Password"), findsOneWidget);
      expect(find.text("LOGIN"), findsOneWidget);
    });

    testWidgets("password disembunyikan dan dapat ditampilkan", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      expect(passwordIsObscured(tester), isTrue);
      await tester.tap(find.byIcon(Icons.visibility_off_outlined));
      await tester.pump();
      expect(passwordIsObscured(tester), isFalse);
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();
      expect(passwordIsObscured(tester), isTrue);
    });

    testWidgets("input kosong menampilkan pesan validasi", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await tester.tap(find.text("LOGIN"));
      await tester.pump();

      expect(find.text("Username tidak boleh kosong"), findsOneWidget);
      expect(find.text("Password tidak boleh kosong"), findsOneWidget);
      expect(find.text("Username dan password wajib diisi"), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets("hanya username terisi: password tetap divalidasi", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await tester.enterText(find.byType(TextFormField).at(0), "gacoan");
      await tester.tap(find.text("LOGIN"));
      await tester.pump();

      expect(find.text("Password tidak boleh kosong"), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets("password salah ditolak dan tidak masuk ke Home", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await tester.enterText(find.byType(TextFormField).at(0), user1.username);
      await tester.enterText(find.byType(TextFormField).at(1), "salahpassword");
      await tester.tap(find.text("LOGIN"));
      await tester.pump();
      await tester.pump(kLoginDelay);

      expect(find.text("Username atau password salah"), findsOneWidget);
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
    });

    testWidgets("login berhasil mengarahkan ke Home", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(LoginPage), findsNothing);
      expect(find.text("Halo, ${user1.username}!"), findsOneWidget);
    });

    testWidgets("tombol isi akun demo mengisi form", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await tester.tap(find.textContaining("Akun demo"));
      await tester.pump();

      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).at(0))
            .controller!
            .text,
        user1.username,
      );
      expect(
        tester
            .widget<TextFormField>(find.byType(TextFormField).at(1))
            .controller!
            .text,
        user1.password,
      );
    });
  });

  group("Halaman Home / Katalog Menu", () {
    testWidgets("menampilkan 9 menu beserta nama dan harga", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);

      expect(find.byType(ListView), findsWidgets);
      expect(find.text("9 menu ditemukan"), findsOneWidget);

      // Katalog memakai ListView.builder, sehingga item digulir satu per satu.
      // Setiap menu harus dapat dibuka dan menampilkan nama serta harganya.
      for (final Menu menu in menus) {
        await scrollToAndTap(
          tester,
          find.text(menu.name).first,
          scrollable: menuListFinder(),
        );
        expect(
          find.byType(DetailPage),
          findsOneWidget,
          reason: "menu ${menu.name} harus dapat dibuka dari katalog",
        );
        // Harga menu tampil pada baris Harga dan pada Total harga.
        expect(find.text(formatRupiah(menu.price)), findsWidgets);

        await tester.tap(find.byTooltip("Kembali ke Home"));
        await tester.pumpAndSettle();
        expect(find.byType(HomePage), findsOneWidget);
      }
    });

    testWidgets("format Rupiah sesuai ketentuan", (WidgetTester tester) async {
      expect(formatRupiah(12000), "Rp12.000");
      expect(formatRupiah(9000), "Rp9.000");
      expect(formatRupiah(6000), "Rp6.000");
      expect(formatRupiah(1234567), "Rp1.234.567");
    });

    testWidgets("kategori dan gambar menu ditampilkan", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);

      expect(find.text("9 menu ditemukan"), findsOneWidget);
      for (final String category in menuCategories) {
        expect(find.text(category), findsWidgets);
      }
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets("filter kategori menyaring daftar menu", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);

      // Baris kategori digulir horizontal, gunakan scrollable-nya secara langsung.
      await scrollToAndTap(
        tester,
        find.widgetWithText(ChoiceChip, "Minuman"),
        scrollable: find.ancestor(
          of: find.widgetWithText(ChoiceChip, "Semua"),
          matching: find.byType(Scrollable),
        ),
      );

      final int expected = menus.where((Menu m) => m.category == "Minuman").length;
      expect(find.text("$expected menu ditemukan"), findsOneWidget);
      expect(find.text("Es Tea"), findsWidgets);
      expect(find.text("Mie Gacoan"), findsNothing);
    });

    testWidgets("pencarian menu bekerja", (WidgetTester tester) async {
      await pumpApp(tester);
      await loginAsDemo(tester);

      await tester.enterText(find.byType(TextField).first, "udang");
      await tester.pumpAndSettle();

      expect(find.text("2 menu ditemukan"), findsOneWidget);
      expect(find.text("Udang Keju"), findsWidgets);
      expect(find.text("Mie Gacoan"), findsNothing);
    });

    testWidgets("klik menu membuka Detail Menu yang sesuai", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);

      await scrollToAndTap(
        tester,
        find.text("Udang Keju").first,
        scrollable: menuListFinder(),
      );

      expect(find.byType(DetailPage), findsOneWidget);
      final DetailPage detail = tester.widget<DetailPage>(
        find.byType(DetailPage),
      );
      expect(detail.menu.name, "Udang Keju");
      expect(detail.menu.category, "Dimsum");
    });

    testWidgets("favorite ditandai dan jumlah favorite bertambah", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);

      expect(find.text("0 favorite"), findsOneWidget);
      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pumpAndSettle();
      expect(find.text("1 favorite"), findsOneWidget);
    });
  });

  group("Halaman Detail Menu", () {
    testWidgets("menampilkan gambar, nama, kategori, harga, deskripsi", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);
      await scrollToAndTap(tester, find.text("Mie Gacoan").first);

      final Menu expected = menus.firstWhere((Menu m) => m.name == "Mie Gacoan");
      expect(find.text(expected.name), findsOneWidget);
      expect(find.text(expected.category), findsWidgets);
      expect(find.text(formatRupiah(expected.price)), findsWidgets);
      expect(find.text(expected.description), findsOneWidget);
      expect(find.text("Deskripsi"), findsOneWidget);
      expect(find.byType(Image), findsWidgets);
    });

    testWidgets("tombol kembali ke Home berfungsi", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);
      await scrollToAndTap(tester, find.text("Mie Gacoan").first);

      await scrollToAndTap(tester, find.text("Kembali ke Home"));

      expect(find.byType(DetailPage), findsNothing);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.text("Mie Gacoan"), findsWidgets);
    });

    testWidgets("back arrow di AppBar kembali ke Home", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);
      await openMenuBySearch(tester, "Es Tea");

      await tester.tap(find.byTooltip("Kembali ke Home"));
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets("jumlah pesan mengubah total harga", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);
      await openMenuBySearch(tester, "Es Tea");

      final Menu tea = menus.firstWhere((Menu m) => m.name == "Es Tea");
      // Harga tampil pada baris Harga dan pada Total harga.
      expect(find.text(formatRupiah(tea.price)), findsNWidgets(2));

      await scrollToAndTap(
        tester,
        find.byIcon(Icons.add),
        scrollable: find.descendant(
          of: find.byType(DetailPage),
          matching: find.byType(Scrollable),
        ),
      );

      expect(find.text(formatRupiah(tea.price * 2)), findsWidgets);
      expect(find.text("2"), findsOneWidget);
    });
  });

  group("Halaman Profil & Logout", () {
    testWidgets("menampilkan username dari hasil login, bukan hardcode", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);

      // Profil menampilkan username apa pun yang diteruskan,
      // sehingga nilainya jelas bukan hardcode di dalam widget.
      await tester.pumpWidget(
        MaterialApp(
          home: ProfilePage(username: "gacoankerip", fullName: user1.name),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text("gacoankerip"), findsWidgets);
      expect(find.text(user1.name), findsWidgets);

      // Username berbeda harus ditampilkan apa adanya.
      await tester.pumpWidget(
        MaterialApp(
          home: ProfilePage(username: "user_lain", fullName: user1.name),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text("user_lain"), findsWidgets);
      expect(find.text("gacoankerip"), findsNothing);
    });

    testWidgets("username hasil login diteruskan dari Home ke Profil", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);

      // Home menerima username dari Login.
      expect(find.text("Halo, ${user1.username}!"), findsOneWidget);

      await tester.tap(find.byTooltip("Profil"));
      await tester.pumpAndSettle();

      final ProfilePage profile = tester.widget<ProfilePage>(
        find.byType(ProfilePage),
      );
      expect(profile.username, user1.username);
      expect(find.text(user1.username), findsWidgets);
    });

    testWidgets("dapat diakses dari tombol di AppBar dan FAB", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);

      await tester.tap(find.byTooltip("Profil"));
      await tester.pumpAndSettle();
      expect(find.byType(ProfilePage), findsOneWidget);

      // Tombol kembali pada AppBar Profil.
      await tester.tap(find.byTooltip("Kembali"));
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);

      await tester.tap(find.widgetWithText(FloatingActionButton, "Profil"));
      await tester.pumpAndSettle();
      expect(find.byType(ProfilePage), findsOneWidget);
    });

    testWidgets("logout kembali ke Login", (WidgetTester tester) async {
      await pumpApp(tester);
      await loginAsDemo(tester);
      await tester.tap(find.widgetWithText(FloatingActionButton, "Profil"));
      await tester.pumpAndSettle();

      await scrollToAndTap(
        tester,
        find.text("LOGOUT"),
        scrollable: find.descendant(
          of: find.byType(ProfilePage),
          matching: find.byType(Scrollable),
        ),
      );

      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(HomePage), findsNothing);
      expect(find.byType(ProfilePage), findsNothing);
    });

    testWidgets("setelah logout tombol Back tidak kembali ke Home", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);
      await tester.tap(find.widgetWithText(FloatingActionButton, "Profil"));
      await tester.pumpAndSettle();

      await scrollToAndTap(
        tester,
        find.text("LOGOUT"),
        scrollable: find.descendant(
          of: find.byType(ProfilePage),
          matching: find.byType(Scrollable),
        ),
      );

      // Coba kembali melalui tombol Back beberapa kali.
      for (int i = 0; i < 3; i++) {
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        expect(find.byType(HomePage), findsNothing);
        expect(find.byType(ProfilePage), findsNothing);
      }
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets("setelah logout login ulang kembali ke Home", (
      WidgetTester tester,
    ) async {
      await pumpApp(tester);
      await loginAsDemo(tester);
      await tester.tap(find.widgetWithText(FloatingActionButton, "Profil"));
      await tester.pumpAndSettle();
      await scrollToAndTap(
        tester,
        find.text("LOGOUT"),
        scrollable: find.descendant(
          of: find.byType(ProfilePage),
          matching: find.byType(Scrollable),
        ),
      );

      await loginAsDemo(tester);
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}