// Widget tests for the student login and register forms.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_form_login_register/main.dart';
import 'package:flutter_form_login_register/pages/register.dart';

void main() {
  testWidgets('login form validates and submits valid student data', (
    WidgetTester tester,
  ) async {
    // Form panjang; perbesar viewport agar semua field & tombol selalu
    // hit-testable tanpa balapan scroll.
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());

    expect(find.text('Login Mahasiswa'), findsOneWidget);
    expect(find.text('Nama lengkap'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('NIM'), findsOneWidget);
    expect(find.text('Jenis kelamin'), findsOneWidget);
    expect(find.text('Tanggal lahir'), findsOneWidget);

    // Submit kosong -> semua validator unjuk rasa.
    await tester.ensureVisible(find.text('Masuk'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Masuk'));
    await tester.pump();
    expect(find.text('Nama lengkap wajib diisi'), findsOneWidget);
    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('NIM wajib diisi'), findsOneWidget);
    expect(find.text('Pilih jenis kelamin'), findsOneWidget);
    expect(find.text('Tanggal lahir tidak boleh kosong'), findsOneWidget);

    // Email salah format -> pesan format.
    // Catatan: pastikan tiap field terlihat di viewport sebelum enterText,
    // karena form panjang dan ensureVisible sebelumnya sudah men-scroll jauh.
    final nameField = find.widgetWithText(TextFormField, 'Nama lengkap');
    final emailField = find.widgetWithText(TextFormField, 'Email');
    final nimField = find.widgetWithText(TextFormField, 'NIM');

    await tester.ensureVisible(nameField);
    await tester.pumpAndSettle();
    await tester.enterText(nameField, 'Budi Santoso');
    await tester.ensureVisible(emailField);
    await tester.pumpAndSettle();
    await tester.enterText(emailField, 'budi@ salah');
    await tester.ensureVisible(find.text('Masuk'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Masuk'));
    await tester.pump();
    expect(find.text('Format email tidak valid'), findsOneWidget);

    // Isi lengkap dan valid -> snackbar.
    await tester.ensureVisible(emailField);
    await tester.pumpAndSettle();
    await tester.enterText(emailField, 'budi@example.com');
    await tester.ensureVisible(nimField);
    await tester.pumpAndSettle();
    await tester.enterText(nimField, 'a12345678');
    final genderDropdown = find.widgetWithText(
      DropdownButtonFormField<String>,
      'Jenis kelamin',
    );
    await tester.ensureVisible(genderDropdown);
    await tester.pumpAndSettle();
    await tester.tap(genderDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Perempuan').last);
    await tester.pumpAndSettle();

    // Pilih tanggal lahir (memicu DatePicker), lalu tekan OK.
    final birthDateField = find.widgetWithText(
      TextFormField,
      'Tanggal lahir',
    );
    await tester.ensureVisible(birthDateField);
    await tester.pumpAndSettle();
    await tester.tap(birthDateField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Masuk'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Masuk'));
    await tester.pump();

    expect(find.text('Login berhasil untuk NIM: A12345678'), findsOneWidget);
  });

  testWidgets('register page validates and submits student data', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Belum punya akun? Daftar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Belum punya akun? Daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Daftar Mahasiswa'), findsOneWidget);

    // Halaman login masih ada di bawah route register, jadi semua finder
    // dibatasi hanya ke dalam RegisterPage.
    Finder inRegister(Finder matching) =>
        find.descendant(of: find.byType(RegisterPage), matching: matching);

    // Submit kosong -> semua validator register unjuk rasa.
    await tester.ensureVisible(inRegister(find.text('Daftar')));
    await tester.pumpAndSettle();
    await tester.tap(inRegister(find.text('Daftar')));
    await tester.pump();
    expect(inRegister(find.text('Nama lengkap wajib diisi')), findsOneWidget);
    expect(inRegister(find.text('Email wajib diisi')), findsOneWidget);
    expect(inRegister(find.text('NIM wajib diisi')), findsOneWidget);
    expect(inRegister(find.text('Pilih jenis kelamin')), findsOneWidget);
    expect(inRegister(find.text('Pilih program studi')), findsOneWidget);
    expect(
      inRegister(find.text('Tanggal lahir tidak boleh kosong')),
      findsOneWidget,
    );

    await tester.enterText(
      inRegister(find.widgetWithText(TextFormField, 'Nama lengkap')),
      'Budi Santoso',
    );
    await tester.enterText(
      inRegister(find.widgetWithText(TextFormField, 'Email')),
      'budi@mail.com',
    );
    await tester.enterText(
      inRegister(find.widgetWithText(TextFormField, 'NIM')),
      'B12345678',
    );

    final genderDropdown = inRegister(
      find.widgetWithText(DropdownButtonFormField<String>, 'Jenis kelamin'),
    );
    await tester.ensureVisible(genderDropdown);
    await tester.pumpAndSettle();
    await tester.tap(genderDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laki-laki').last);
    await tester.pumpAndSettle();

    final prodiDropdown = inRegister(
      find.widgetWithText(DropdownButtonFormField<String>, ' Program Studi'),
    );
    await tester.ensureVisible(prodiDropdown);
    await tester.pumpAndSettle();
    await tester.tap(prodiDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Teknik Informatika').last);
    await tester.pumpAndSettle();

    // Pilih tanggal lahir di halaman register, lalu tekan OK.
    final birthDateField = inRegister(
      find.widgetWithText(TextFormField, 'Tanggal lahir'),
    );
    await tester.ensureVisible(birthDateField);
    await tester.pumpAndSettle();
    await tester.tap(birthDateField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(inRegister(find.text('Daftar')));
    await tester.pumpAndSettle();
    await tester.tap(inRegister(find.text('Daftar')));
    await tester.pump();

    expect(
      find.text('Pendaftaran berhasil untuk Budi Santoso'),
      findsOneWidget,
    );
  });
}
