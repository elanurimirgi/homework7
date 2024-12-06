import 'package:flutter/material.dart';
import '../models/ogrenci.dart';
import '../services/sqlApi.dart';

class OgrenciListesi extends StatefulWidget {
  @override
  _OgrenciListesiState createState() => _OgrenciListesiState();
}

class _OgrenciListesiState extends State<OgrenciListesi> {
  List<Ogrenci> ogrenciler = [];
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchOgrenciler();
  }

  // Öğrenci verilerini backend'den çekme
  void fetchOgrenciler() async {
    try {
      List<Ogrenci> fetchedOgrenciler = await apiService.fetchOgrenciler();
      setState(() {
        ogrenciler = fetchedOgrenciler;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öğrenciler alınamadı: $e')),
      );
    }
  }

  // Yeni öğrenci ekleme
  void addOgrenci(String ad, String soyad, int bolumId) async {
    final newOgrenci = Ogrenci(
        id: DateTime.now().millisecondsSinceEpoch,  // Benzersiz bir ID oluşturmak için zaman damgası kullanıyoruz
        ad: ad, soyad: soyad, bolumId: bolumId
    );
    try {
      await apiService.addOgrenci(newOgrenci);
      fetchOgrenciler();  // Yeni öğrenci eklendikten sonra listeyi güncelle
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öğrenci eklendi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öğrenci eklenemedi: $e')),
      );
    }
  }

  // Öğrenci güncelleme
  void updateOgrenci(Ogrenci ogrenci) async {
    try {
      await apiService.updateOgrenci(ogrenci);
      fetchOgrenciler();  // Güncellendikten sonra listeyi güncelle
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öğrenci güncellendi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öğrenci güncellenemedi: $e')),
      );
    }
  }

  // Öğrenci silme
  void deleteOgrenci(int id) async {
    try {
      await apiService.deleteOgrenci(id);
      fetchOgrenciler();  // Silindikten sonra listeyi güncelle
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öğrenci silindi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öğrenci silinemedi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Öğrenci Listesi')),
      body: ListView.builder(
        itemCount: ogrenciler.length,
        itemBuilder: (context, index) {
          final ogrenci = ogrenciler[index];
          return ListTile(
            title: Text('${ogrenci.ad} ${ogrenci.soyad}'),
            subtitle: Text('Bölüm ID: ${ogrenci.bolumId}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditOgrenciDialog(ogrenci);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    deleteOgrenci(ogrenci.id);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddOgrenciDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Yeni öğrenci ekleme diyalogu
  void _showAddOgrenciDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final adController = TextEditingController();
        final soyadController = TextEditingController();
        final bolumController = TextEditingController();

        return AlertDialog(
          title: Text('Öğrenci Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: adController, decoration: InputDecoration(labelText: 'Ad')),
              TextField(controller: soyadController, decoration: InputDecoration(labelText: 'Soyad')),
              TextField(controller: bolumController, decoration: InputDecoration(labelText: 'Bölüm ID')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final ad = adController.text;
                final soyad = soyadController.text;
                final bolumId = int.tryParse(bolumController.text) ?? 0;

                addOgrenci(ad, soyad, bolumId);
                Navigator.of(context).pop();
              },
              child: Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  // Öğrenci güncelleme diyalogu
  void _showEditOgrenciDialog(Ogrenci ogrenci) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final adController = TextEditingController(text: ogrenci.ad);
        final soyadController = TextEditingController(text: ogrenci.soyad);
        final bolumController = TextEditingController(text: ogrenci.bolumId.toString());

        return AlertDialog(
          title: Text('Öğrenci Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: adController, decoration: InputDecoration(labelText: 'Ad')),
              TextField(controller: soyadController, decoration: InputDecoration(labelText: 'Soyad')),
              TextField(controller: bolumController, decoration: InputDecoration(labelText: 'Bölüm ID')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedOgrenci = Ogrenci(
                  id: ogrenci.id,
                  ad: adController.text,
                  soyad: soyadController.text,
                  bolumId: int.tryParse(bolumController.text) ?? 0,
                );

                updateOgrenci(updatedOgrenci);
                Navigator.of(context).pop();
              },
              child: Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }
}
