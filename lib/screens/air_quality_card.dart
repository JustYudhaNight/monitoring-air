import 'package:firebase_air_quality_2/providers/air_quality_provider.dart';
import 'package:firebase_air_quality_2/screens/air_quality_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../widgets/air_quality_status.dart';
import '../widgets/parameter_chart.dart';

class AirQualityCard extends StatelessWidget {
  const AirQualityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AirQualityProvider>(
      builder: (context, airData, child) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset(
                  'images/ikon.png',
                  height: 50,
                  width: 50,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Aplikasi Pemantauan\nKualitas Udara',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: const Color(0xFF8B80F8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            // Batas Judul & Lokasi, Tanggal, Waktu

            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Lokasi
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Colors.black54,
                            size: 14,
                          ),
                          Text(
                            airData.location,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              fontSize: 12,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tanggal & waktu
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          airData.formattedDate,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          airData.formattedTime,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Batas AppBar & body

          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Air Quality Card
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xffB6FFFA),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),

                    // Keterangan
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Status Kualitas Udara
                        const AirQualityStatus(),
                        const SizedBox(height: 16),

                        // Keterangan
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Kualitas udara sangat baik, tingkat polusi rendah.',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                'Tidak ada atau dampak sangat minim bagi kesehatan.',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Judul Parameter
                        Center(
                          child: Text(
                            'Parameter',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Grafik Parameter
                        const ParameterChart(),

                        // Button info
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                // Pengaturan Navigasi Button
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const AirQualityInfo(),
                                    ),
                                  );
                                },

                                // Desain Button
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue[50],
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),

                                // Teks info
                                child: const Row(
                                  children: [
                                    Text('Info'),
                                    Icon(Icons.chevron_right),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Suhu dan kelembaban
                  Row(
                    children: [
                      // Suhu
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE1FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.thermostat,
                                size: 24,
                                color: Colors.black87,
                              ),
                              const SizedBox(width: 4),
                              Column(
                                children: [
                                  const Text(
                                    'Suhu',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${airData.temperature?.toStringAsFixed(1) ?? '-'} C',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Kelembaban
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE1FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.water_drop,
                                size: 24,
                                color: Colors.black87,
                              ),
                              const SizedBox(width: 4),
                              Column(
                                children: [
                                  const Text(
                                    'Kelembaban',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    '${airData.humidity?.toStringAsFixed(0) ?? '-'} %',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
