import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ogrenci.dart';

class ApiService {
  final String baseUrl = 'http://192.168.56.1:3000/ogrenciler'; // Backend URL

  // Öğrencileri çekme
  Future<List<Ogrenci>> fetchOgrenciler() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Ogrenci.fromJson(json)).toList();
    } else {
      throw Exception('Öğrenciler alınamadı');
    }
  }

  // Yeni öğrenci ekleme
  Future<void> addOgrenci(Ogrenci ogrenci) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ogrenci.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Öğrenci eklenemedi');
    }
  }

  // Öğrenci silme
  Future<void> deleteOgrenci(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Öğrenci silinemedi');
    }
  }

  // Öğrenci güncelleme
  Future<void> updateOgrenci(Ogrenci ogrenci) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${ogrenci.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(ogrenci.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Öğrenci güncellenemedi');
    }
  }
}
