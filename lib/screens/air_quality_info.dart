import 'package:flutter/material.dart';

class AirQualityInfo extends StatelessWidget {
  const AirQualityInfo({super.key});

  Widget _buildQualityItem(
    String title,
    String range,
    String description,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            range,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffB1F0F7),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/ikon.png"),
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildQualityItem(
            "BAIK",
            "NILAI ISPU (0-50)",
            "Tingkat Kualitas Udara Yang Sangat Baik, Tidak Memberikan Efek Negative Terhadap Manusia,Hewan, Tumbuhan. Kondisi udara juga tidak mengganggu nilai estetika lingkungan dan bangunan",
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildQualityItem(
            "SEDANG",
            "NILAI ISPU (51-100)",
            "Tingkat kualitas udara cukup aman bagi kesehatan manusia atau hewan, tapi berpengaruh pada tumbuhan yang sensitif. Kondisi udara juga mulai mengganggu nilai estetika lingkungan.",
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildQualityItem(
            "TIDAK SEHAT",
            "NILAI ISPU (101-200)",
            "Kualitas udara mulai memburuk dan tidak sehat bagi manusia maupun hewan yang sensitif. Kondisi ini bisa menimbulkan kerusakan pada tumbuhan dan nilai estetika lingkungan.",
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildQualityItem(
            "SANGAT TIDAK SEHAT",
            "NILAI ISPU (201-300)",
            "Tingkat kualitas udara dapat merugikan kesehatan seluruh masyarakat. Kondisi udara sudah sangat tidak layak, sehingga sebaiknya tetaplah berada di dalam rumah untuk menghindari paparan polusi.",
            Colors.red,
          ),
          const SizedBox(height: 16),
          _buildQualityItem(
            "BERBAHAYA",
            "NILAI ISPU (> 300)",
            "Udara mengandung partikel berbahaya yang dapat memicu masalah serius pada tubuh. Bila tidak segera diatasi, bisa mengancam kesehatan dalam jangka pendek hingga jangka panjang.",
            Colors.black,
          ),
        ],
      ),
    );
  }
}
