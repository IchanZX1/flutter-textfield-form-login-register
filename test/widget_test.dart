// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutte_form_login_register/main.dart';

void main() {
  testWidgets('login form validates and submits valid student data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login Mahasiswa'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('NIM')).dy,
      lessThan(tester.getTopLeft(find.text('Jenis kelamin')).dy),
    );
    expect(find.text('Jenis kelamin'), findsOneWidget);
    expect(find.text('NIM'), findsOneWidget);

    await tester.tap(find.text('Masuk'));
    await tester.pump();
    expect(find.text('Pilih jenis kelamin'), findsOneWidget);
    expect(find.text('NIM wajib diisi'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Perempuan').last);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'a12345678');
    await tester.tap(find.text('Masuk'));
    await tester.pump();

    expect(find.text('Login berhasil untuk NIM: A12345678'), findsOneWidget);
  });

  testWidgets('register page validates and submits student data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Belum punya akun? Daftar'));
    await tester.pumpAndSettle();
    expect(find.text('Daftar Mahasiswa'), findsOneWidget);

    await tester.tap(find.text('Daftar'));
    await tester.pump();
    expect(find.text('Nama lengkap wajib diisi'), findsOneWidget);
    expect(find.text('NIM wajib diisi'), findsOneWidget);
    expect(find.text('Pilih jenis kelamin'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, 'Budi Santoso');
    await tester.enterText(find.byType(TextFormField).at(1), 'B12345678');
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Laki-laki').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Daftar'));
    await tester.pump();

    expect(
      find.text('Pendaftaran berhasil untuk Budi Santoso'),
      findsOneWidget,
    );
  });
}
