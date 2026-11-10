// Widget tests for the student login and register forms.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_form_login_register/main.dart';
import 'package:flutter_form_login_register/pages/register.dart';

void main() {
  testWidgets('login form validates and submits valid student data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login Mahasiswa'), findsOneWidget);
    expect(find.text('Nama lengkap'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('NIM'), findsOneWidget);
    expect(find.text('Jenis kelamin'), findsOneWidget);

    // Submit kosong -> semua validator unjuk rasa.
    await tester.ensureVisible(find.text('Masuk'));
    await tester.tap(find.text('Masuk'));
    await tester.pump();
    expect(find.text('Nama lengkap wajib diisi'), findsOneWidget);
    expect(find.text('Email wajib diisi'), findsOneWidget);
    expect(find.text('NIM wajib diisi'), findsOneWidget);
    expect(find.text('Pilih jenis kelamin'), findsOneWidget);

    // Email salah format -> pesan format.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama lengkap'),
      'Budi Santoso',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'budi@ salah',
    );
    await tester.ensureVisible(find.text('Masuk'));
    await tester.tap(find.text('Masuk'));
    await tester.pump();
    expect(find.text('Format email tidak valid'), findsOneWidget);

    // Isi lengkap dan valid -> snackbar.
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'budi@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'NIM'),
      'a12345678',
    );
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

    await tester.ensureVisible(find.text('Masuk'));
    await tester.tap(find.text('Masuk'));
    await tester.pump();

    expect(find.text('Login berhasil untuk NIM: A12345678'), findsOneWidget);
  });

  testWidgets('register page validates and submits student data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Belum punya akun? Daftar'));
    await tester.tap(find.text('Belum punya akun? Daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Daftar Mahasiswa'), findsOneWidget);

    // Halaman login masih ada di bawah route register, jadi semua finder
    // dibatasi hanya ke dalam RegisterPage.
    Finder inRegister(Finder matching) =>
        find.descendant(of: find.byType(RegisterPage), matching: matching);

    // Submit kosong -> semua validator register unjuk rasa.
    await tester.ensureVisible(inRegister(find.text('Daftar')));
    await tester.tap(inRegister(find.text('Daftar')));
    await tester.pump();
    expect(inRegister(find.text('Nama lengkap wajib diisi')), findsOneWidget);
    expect(inRegister(find.text('Email wajib diisi')), findsOneWidget);
    expect(inRegister(find.text('NIM wajib diisi')), findsOneWidget);
    expect(inRegister(find.text('Pilih jenis kelamin')), findsOneWidget);
    expect(inRegister(find.text('Pilih program studi')), findsOneWidget);

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
    await tester.tap(genderDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laki-laki').last);
    await tester.pumpAndSettle();

    final prodiDropdown = inRegister(
      find.widgetWithText(DropdownButtonFormField<String>, ' Program Studi'),
    );
    await tester.ensureVisible(prodiDropdown);
    await tester.tap(prodiDropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Teknik Informatika').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(inRegister(find.text('Daftar')));
    await tester.tap(inRegister(find.text('Daftar')));
    await tester.pump();

    expect(
      find.text('Pendaftaran berhasil untuk Budi Santoso'),
      findsOneWidget,
    );
  });
}
