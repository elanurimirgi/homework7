import 'package:flutter/material.dart';
import 'pages/ogrenciListesi.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Öğrenci Yönetim Sistemi',
      debugShowCheckedModeBanner: false, // Debug etiketi kaldırıldı
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: OgrenciListesi(),
      // Gelecekte daha fazla sayfa eklenecekse aşağıdaki `routes` kullanılabilir
      routes: {
        '/ogrenciListesi': (context) => OgrenciListesi(),
        // Diğer sayfalar buraya eklenebilir.
      },
    );
  }
}
