import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  final String baseUrl =
      'http://192.168.1.18:8000/api'; // Ganti dengan URL API Anda
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Fungsi untuk registrasi
  Future<Map<String, dynamic>> register(String name, String email,
      String password, String passwordConfirmation) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'), // Endpoint untuk registrasi
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      // Simpan token ke storage jika respons API menyediakan token setelah registrasi
      if (data.containsKey('token')) {
        await secureStorage.write(key: 'token', value: data['token']);
      }
      return data; // Mengembalikan data pengguna yang terdaftar
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // Fungsi untuk login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'), // Adjust to your login endpoint
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      // Save the token in secure storage
      await secureStorage.write(key: 'token', value: data['token']);

      // Save the user_id in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', data['user_id'].toString());

      return data; // Return user data and token
    } else {
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

  // Fungsi untuk mendapatkan detail lowongan
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
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat detail lowongan: ${response.statusCode}');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> storeAlumni(
      Map<String, dynamic> alumniData) async {
    final token = await secureStorage.read(key: 'token');
    final response = await http.post(
      Uri.parse('$baseUrl/alumni'), // Endpoint untuk menyimpan data alumni
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(alumniData),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal menyimpan data alumni: ${response.body}');
    }
  }

  // Method untuk mengambil data alumni berdasarkan ID
  Future<Map<String, dynamic>> getAlumniById() async {
    final token = await secureStorage.read(key: 'token');

    final response = await http.get(
      Uri.parse(
          '$baseUrl/data-alumni'), // Endpoint untuk mendapatkan data alumni
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mendapatkan data alumni: ${response.body}');
    }
  }

  // Fungsi untuk menyimpan bookmark
  Future<void> bookmarkJob(int jobId) async {
    final token = await secureStorage.read(key: 'token');
    final response = await http.post(
      Uri.parse(
          '$baseUrl/bookmarks'), // Ganti dengan endpoint untuk menyimpan bookmark
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'job_id': jobId}),
    );

    if (response.statusCode != 201) {
      throw Exception('Gagal menyimpan bookmark: ${response.body}');
    }
  }

  // Fungsi untuk mengambil semua bookmark
  Future<List<dynamic>> fetchBookmarks() async {
    try {
      final token = await secureStorage.read(key: 'token');

      final response = await http.get(
        Uri.parse(
            '$baseUrl/bookmarks'), // Ganti dengan endpoint untuk mengambil bookmark
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print(responseData[
            'bookmarks']); // Debugging untuk melihat struktur respons
        return responseData['bookmarks']; // Ambil data dari 'bookmarks'
      } else {
        throw Exception('Gagal memuat bookmark');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      return []; // Mengembalikan list kosong jika terjadi kesalahan
    }
  }

  // Fungsi untuk menghapus bookmark
  Future<void> deleteBookmark(int bookmarkId) async {
    final token = await secureStorage.read(key: 'token');

    final response = await http.delete(
      Uri.parse(
          '$baseUrl/bookmarks/$bookmarkId'), // Ganti dengan endpoint untuk menghapus bookmark
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus bookmark: ${response.body}');
    }
  }
}
