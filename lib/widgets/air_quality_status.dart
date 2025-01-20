import 'package:firebase_air_quality_2/providers/air_quality_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AirQualityStatus extends StatelessWidget {
  const AirQualityStatus({super.key});

  String _selectHighestIndex(AirQualityProvider provider) {
    double highestIndex = 0; // Hapus tanda ? karena kita inisialisasi dengan 0
    String parameter = "N/A";

    // Check CO
    if (provider.coIndex != null && provider.coIndex! > highestIndex) {
      highestIndex = provider.coIndex!;
      parameter = "CO";
    }
    // Check CO2
    if (provider.co2Index != null && provider.co2Index! > highestIndex) {
      highestIndex = provider.co2Index!;
      parameter = "CO₂";
    }
    // Check O3
    if (provider.o3Index != null && provider.o3Index! > highestIndex) {
      highestIndex = provider.o3Index!;
      parameter = "O₃";
    }
    // Check NH3
    if (provider.nh3Index != null && provider.nh3Index! > highestIndex) {
      highestIndex = provider.nh3Index!;
      parameter = "NH₃";
    }

    return parameter;
  }

  double? _getValueForParameter(String parameter, AirQualityProvider provider) {
    switch (parameter) {
      case "CO":
        return provider.coIndex;
      case "CO₂":
        return provider.co2Index;
      case "O₃":
        return provider.o3Index;
      case "NH₃":
        return provider.nh3Index;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AirQualityProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return Center(child: Text(provider.error!));
        }

        final dominantParameter = _selectHighestIndex(provider);
        final parameterValue =
            _getValueForParameter(dominantParameter, provider);

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFBEFFF7),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                'KUALITAS UDARA',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    dominantParameter,
                    style: TextStyle(
                      fontSize: 18,
                      color: provider.getStatusColor(
                          provider.overallStatus ?? "TIDAK TERSEDIA"),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('|',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  Text(
                    parameterValue?.toStringAsFixed(1) ?? "N/A",
                    style: TextStyle(
                      fontSize: 18,
                      color: provider.getStatusColor(
                          provider.overallStatus ?? "TIDAK TERSEDIA"),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('|',
                      style: TextStyle(fontSize: 18, color: Colors.grey)),
                  Text(
                    provider.overallStatus ?? "TIDAK TERSEDIA",
                    style: TextStyle(
                      fontSize: 18,
                      color: provider.getStatusColor(
                          provider.overallStatus ?? "TIDAK TERSEDIA"),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
