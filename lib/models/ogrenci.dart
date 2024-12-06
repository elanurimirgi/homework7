class Ogrenci {
  final int id;
  final String ad;
  final String soyad;
  final int bolumId; // Yeni eklenen bolumId parametresi

  Ogrenci({required this.id, required this.ad, required this.soyad, required this.bolumId});

  // JSON'dan Ogrenci nesnesi oluşturma
  factory Ogrenci.fromJson(Map<String, dynamic> json) {
    return Ogrenci(
      id: json['ogrenciID'],
      ad: json['ad'],
      soyad: json['soyad'],
      bolumId: json['bolumId'], // JSON'daki bolumId'yi kullan
    );
  }

  // Ogrenci nesnesini JSON'a çevirme
  Map<String, dynamic> toJson() {
    return {
      'ogrenciID': id,
      'ad': ad,
      'soyad': soyad,
      'bolumId': bolumId, // Ogrenci nesnesindeki bolumId'yi kullan
    };
  }
}
