// Widget tests for the student login and register forms.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_form_login_register/main.dart';
import 'package:flutter_form_login_register/pages/register.dart';

void main() {
  testWidgets('login form shows all fields and submits student data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login Mahasiswa'), findsOneWidget);
    expect(find.text('Nama lengkap'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('NIM'), findsOneWidget);
    expect(find.text('Jenis kelamin'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('Nama lengkap')).dy,
      lessThan(tester.getTopLeft(find.text('Email')).dy),
    );
    expect(
      tester.getTopLeft(find.text('NIM')).dy,
      lessThan(tester.getTopLeft(find.text('Jenis kelamin')).dy),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nama lengkap'),
      'Budi Santoso',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Email'),
      'budi@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'NIM'),
      'a12345678',
    );
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Perempuan').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Masuk'));
    await tester.tap(find.text('Masuk'));
    await tester.pump();

    expect(find.text('Login berhasil untuk NIM: A12345678'), findsOneWidget);
  });

  testWidgets('register page submits student data', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.ensureVisible(find.text('Belum punya akun? Daftar'));
    await tester.tap(find.text('Belum punya akun? Daftar'));
    await tester.pumpAndSettle();

    // Halaman login masih ada di bawah route register, jadi semua finder
    // dibatasi hanya ke dalam RegisterPage.
    Finder inRegister(Finder matching) =>
        find.descendant(of: find.byType(RegisterPage), matching: matching);

    expect(inRegister(find.text('Nama lengkap')), findsOneWidget);
    expect(inRegister(find.text('Email')), findsOneWidget);
    expect(inRegister(find.text('NIM')), findsOneWidget);
    expect(inRegister(find.text('Jenis kelamin')), findsOneWidget);

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
    final dropdown = inRegister(find.byType(DropdownButtonFormField<String>));
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laki-laki').last);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Daftar'));
    await tester.tap(find.text('Daftar'));
    await tester.pump();

    expect(
      find.text('Pendaftaran berhasil untuk Budi Santoso'),
      findsOneWidget,
    );
  });
}
