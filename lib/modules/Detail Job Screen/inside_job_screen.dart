import 'package:flutter/material.dart';
import 'dart:convert';

class InsideJobScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const InsideJobScreen({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mengambil data dari job
    final String title = job['judul'] ?? 'Posisi tidak tersedia';
    final String company = job['perusahaan'] ?? 'Perusahaan tidak tersedia';
    final String location = job['lokasi'] ?? 'Lokasi tidak tersedia';
    final String category = job['kategori'] ?? 'Kategori tidak tersedia';
    final String type = job['tipe'] ?? 'Tipe tidak tersedia';
    final String salary = job['gaji'] != null
        ? 'Rp ${job['gaji']?.replaceAll('.', ',') ?? 'Gaji tidak tersedia'} per month'
        : 'Gaji tidak tersedia';
    final String description = job['deskripsi'] ?? 'Deskripsi tidak tersedia.';
    final List<String> requirements =
        List<String>.from(json.decode(job['requirement'] ?? '[]'));

    return Scaffold(
      appBar: AppBar(
        title: const Text('BKK SMN 19 JAKARTA'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              color: Colors.grey[300],
              child: const Center(
                child: Text(
                    'Company Logo Placeholder'), // Ganti dengan widget image jika ada
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(company),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Text(location),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.work, size: 16),
                      const SizedBox(width: 4),
                      Text(category),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 4),
                      Text(type),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, size: 16),
                      const SizedBox(width: 4),
                      Text(salary),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Posted 6 hari yang lalu'),
                  const SizedBox(height: 24),
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(description),
                  const SizedBox(height: 16),
                  const Text(
                    'Persyaratan Teknis:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...requirements.map((req) => Text('• $req')).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement apply functionality
          },
          child: const Text('Liat Lamaran'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}
