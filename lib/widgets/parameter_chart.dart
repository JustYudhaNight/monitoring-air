import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/air_quality_provider.dart';

class ParameterChart extends StatelessWidget {
  const ParameterChart({super.key});

  BarChartGroupData _createBarData(int x, double? y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y ?? 0, // Gunakan 0 jika nilai null
          color: Colors.purple[200],
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
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

        return SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 300,
              barGroups: [
                _createBarData(0, provider.coIndex),
                _createBarData(1, provider.co2Index),
                _createBarData(2, provider.nh3Index),
                _createBarData(3, provider.o3Index),
              ],
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const titles = ['CO', 'CO₂', 'NH₃', 'O₃'];
                      if (value >= 0 && value < titles.length) {
                        return Text(
                          titles[value.toInt()],
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 75,
                    reservedSize: 40,
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                horizontalInterval: 75,
                drawVerticalLine: false,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  );
                },
              ),
              borderData: FlBorderData(show: false),
            ),
          ),
        );
      },
    );
  }
}
