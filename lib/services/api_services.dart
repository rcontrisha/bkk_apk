import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiServices {
  final String baseUrl =
      'http://192.168.1.20:8000/api'; // Ganti dengan URL API Anda
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Fungsi untuk login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'), // Ganti dengan endpoint login Anda
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Jika server mengembalikan respons OK
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Simpan token di penyimpanan aman
      await secureStorage.write(key: 'token', value: data['token']);
      return data; // Mengembalikan data pengguna dan token
    } else {
      // Jika server mengembalikan respons error
      throw Exception('Failed to log in');
    }
  }

  // Fungsi untuk mendapatkan daftar lowongan
  Future<List<dynamic>> fetchLowongan() async {
    try {
      final token = await secureStorage.read(key: 'token');

      final response = await http.get(
        Uri.parse('$baseUrl/lowongan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['data'];
      } else {
        throw Exception('Gagal memuat lowongan');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      return [];
    }
  }

  // Fungsi untuk mendapatkan daftar lowongan
  Future<Map<String, dynamic>> fetchDetailLowongan(int id) async {
    try {
      final token = await secureStorage.read(key: 'token');

      final response = await http.get(
        Uri.parse('$baseUrl/lowongan/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Jika server mengembalikan 200 OK, maka parse JSON
        return json.decode(response.body);
      } else {
        // Jika server tidak mengembalikan 200 OK, lempar pengecualian
        throw Exception('Gagal memuat detail lowongan: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> storeAlumni(Map<String, dynamic> alumniData) async {
    final token = await secureStorage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/alumni'), // Endpoint untuk menyimpan data alumni
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // Jika menggunakan token untuk autentikasi
      },
      body: jsonEncode(alumniData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body); // Data berhasil disimpan
    } else {
      throw Exception('Gagal menyimpan data alumni: ${response.body}');
    }
  }

  // Method untuk mengambil data alumni berdasarkan ID
  Future<Map<String, dynamic>> getAlumniById() async {
    final token = await secureStorage.read(key: 'token');
    
    final response = await http.get(
      Uri.parse('$baseUrl/data-alumni'), // Endpoint untuk mendapatkan data alumni
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // Jika menggunakan token untuk autentikasi
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Mengembalikan data alumni
    } else {
      throw Exception('Gagal mendapatkan data alumni: ${response.body}');
    }
  }
}
