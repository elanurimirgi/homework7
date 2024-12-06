const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

// MySQL veritabanı bağlantısı
const db = mysql.createConnection({
  host: process.env.DB_HOST,  // .env dosyasından alınacak
  user: process.env.DB_USER,  // .env dosyasından alınacak
  password: process.env.DB_PASSWORD,  // .env dosyasından alınacak
  database: process.env.DB_NAME  // .env dosyasından alınacak
});

// Veritabanı bağlantısını kontrol et
db.connect((err) => {
  if (err) {
    console.error('Veritabanına bağlanılamadı: ' + err.stack);
    return;
  }
  console.log('Veritabanına başarıyla bağlanıldı.');
  
  // Veritabanı ve tabloyu oluşturma
  db.query('CREATE DATABASE IF NOT EXISTS ogrenciDB', (err, result) => {
    if (err) {
      console.error('Veritabanı oluşturulamadı: ' + err.stack);
      return;
    }
    console.log('Veritabanı oluşturuldu ya da zaten var.');
    
    // Veritabanını seç
    db.query('USE ogrenciDB', (err) => {
      if (err) {
        console.error('Veritabanı seçilemedi: ' + err.stack);
        return;
      }

      // Tabloyu oluşturma
      const createTableQuery = `
        CREATE TABLE IF NOT EXISTS ogrenciler (
          ogrenciID INT AUTO_INCREMENT PRIMARY KEY,
          ad VARCHAR(100),
          soyad VARCHAR(100),
          bolumId INT
        )
      `;
      db.query(createTableQuery, (err, result) => {
        if (err) {
          console.error('Tablo oluşturulamadı: ' + err.stack);
          return;
        }
        console.log('Tablo oluşturuldu ya da zaten var.');
      });
    });
  });
});

// CRUD işlemleri için API endpoint'leri

// Öğrencileri listeleme (GET)
app.get('/ogrenciler', (req, res) => {
  db.query('SELECT * FROM ogrenciler', (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Veritabanı hatası' });
      return;
    }
    res.json(results);
  });
});

// Yeni öğrenci ekleme (POST)
app.post('/ogrenciler', (req, res) => {
  const { ad, soyad, bolumId } = req.body;
  db.query('INSERT INTO ogrenciler (ad, soyad, bolumId) VALUES (?, ?, ?)', [ad, soyad, bolumId], (err, result) => {
    if (err) {
      res.status(500).json({ message: 'Öğrenci eklenemedi' });
      return;
    }
    res.status(201).json({ message: 'Öğrenci eklendi', id: result.insertId });
  });
});

// Öğrenci güncelleme (PUT)
app.put('/ogrenciler/:id', (req, res) => {
  const { id } = req.params;
  const { ad, soyad, bolumId } = req.body;
  db.query('UPDATE ogrenciler SET ad = ?, soyad = ?, bolumId = ? WHERE ogrenciID = ?', [ad, soyad, bolumId, id], (err, result) => {
    if (err) {
      res.status(500).json({ message: 'Öğrenci güncellenemedi' });
      return;
    }
    res.json({ message: 'Öğrenci güncellendi' });
  });
});

// Öğrenci silme (DELETE)
app.delete('/ogrenciler/:id', (req, res) => {
  const { id } = req.params;
  db.query('DELETE FROM ogrenciler WHERE ogrenciID = ?', [id], (err, result) => {
    if (err) {
      res.status(500).json({ message: 'Öğrenci silinemedi' });
      return;
    }
    res.json({ message: 'Öğrenci silindi' });
  });
});

// Sunucuyu başlat
app.listen(port, () => {
  console.log(`API sunucusu http://localhost:${port} adresinde çalışıyor`);
});
