import 'package:bkk/services/api_services.dart';
import 'package:bkk/widgets/sidebar.dart';
import 'package:flutter/material.dart';

class UserApplicationsScreen extends StatefulWidget {
  @override
  _UserApplicationsScreenState createState() => _UserApplicationsScreenState();
}

class _UserApplicationsScreenState extends State<UserApplicationsScreen> {
  late Future<List<dynamic>> _applicationsFuture;

  @override
  void initState() {
    super.initState();
    _applicationsFuture =
        ApiServices().getUserApplications(); // Panggil service untuk ambil data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pendaftaran Lowongan'),
      ),
      drawer: Sidebar(),
      body: FutureBuilder<List<dynamic>>(
        future: _applicationsFuture,
        builder: (context, snapshot) {
          // Proses berdasarkan status koneksi
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada data pendaftaran.'));
          } else {
            final applications = snapshot.data!;
            return ListView.builder(
              itemCount: applications.length,
              itemBuilder: (context, index) {
                var application = applications[index];

                return _buildApplicationCard(application);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildApplicationCard(dynamic application) {
    // Mengambil data dari response JSON
    final String jobTitle =
        application['lowongan']['judul'] ?? 'Judul tidak tersedia';
    final String company =
        application['lowongan']['perusahaan'] ?? 'Perusahaan tidak tersedia';
    final String location =
        application['lowongan']['lokasi'] ?? 'Lokasi tidak tersedia';
    final String status = application['status'] ?? 'Status tidak tersedia';
    final String interviewLocation =
        application['lokasi_interview'] ?? 'Lokasi interview tidak tersedia';
    final String interviewDate =
        application['tanggal_interview'] ?? 'Tanggal interview tidak tersedia';

    // Menentukan warna badge berdasarkan status lamaran
    Color badgeColor;
    String badgeText;

    switch (status) {
      case 'accepted':
        badgeColor = Colors.green;
        badgeText = 'Diterima';
        break;
      case 'rejected':
        badgeColor = Colors.red;
        badgeText = 'Ditolak';
        break;
      default:
        badgeColor = Colors.yellow;
        badgeText = 'Menunggu';
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul dan informasi lowongan
                Text(
                  jobTitle,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(company),
                Text(location),
                SizedBox(height: 8),

                // Detail interview jika diterima
                if (status == 'accepted') ...[
                  Row(
                    children: [
                      Text(
                        'Lokasi Interview: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(interviewLocation),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        'Tanggal Interview: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(interviewDate),
                    ],
                  ),
                ],
              ],
            ),
          ),
          // Badge status di pojok kanan atas
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                badgeText,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
