import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AirQualityProvider with ChangeNotifier {
  double? _coIndex;
  double? _co2Index;
  double? _o3Index;
  double? _nh3Index;
  String? _coStatus;
  String? _co2Status;
  String? _o3Status;
  String? _nh3Status;
  String? _overallStatus;
  double? _temperature;
  double? _humidity;

  // Getters untuk indeks
  double? get coIndex => _coIndex;
  double? get co2Index => _co2Index;
  double? get o3Index => _o3Index;
  double? get nh3Index => _nh3Index;
  double? get temperature => _temperature;
  double? get humidity => _humidity;

  // Getters untuk status
  String? get coStatus => _coStatus;
  String? get co2Status => _co2Status;
  String? get o3Status => _o3Status;
  String? get nh3Status => _nh3Status;
  String? get overallStatus => _overallStatus;

  // New variables for date, time, and location
  DateTime _currentDateTime = DateTime.now();
  String _location = "Jakarta, Tanjung Barat";
  Timer? _timer;

  // New getters for date, time, and location
  DateTime get currentDateTime => _currentDateTime;
  String get location => _location;

  String get formattedDate =>
      DateFormat('dd MMMM yyyy', 'id_ID').format(_currentDateTime);
  String get formattedTime => DateFormat('HH:mm:ss').format(_currentDateTime);

  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref("UsersData");
  Map<dynamic, dynamic>? _sensorData;
  String? _error;
  bool _isLoading = true;

  Map<dynamic, dynamic>? get sensorData => _sensorData;
  String? get error => _error;
  bool get isLoading => _isLoading;

  AirQualityProvider() {
    _initialize();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _currentDateTime = DateTime.now();
      notifyListeners();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  void _initialize() {
    startTimer();

    _databaseRef.onValue.listen(
      (DatabaseEvent event) {
        _isLoading = false;
        if (event.snapshot.value != null) {
          _sensorData = event.snapshot.value as Map<dynamic, dynamic>;
          _error = null;

          if (_sensorData!.isNotEmpty) {
            final firstDevice =
                _sensorData!.values.first as Map<dynamic, dynamic>;

            _temperature = (firstDevice['Kelembaban'] as num?)?.toDouble();
            _humidity = (firstDevice['Suhu'] as num?)?.toDouble();

            final co = (firstDevice['CO'] as num?)?.toDouble();
            final co2 = (firstDevice['CO2'] as num?)?.toDouble();
            final o3 = (firstDevice['O3'] as num?)?.toDouble();
            final nh3 = (firstDevice['NH3'] as num?)?.toDouble();

            if (co != null) {
              calculateCOIndex(co);
            }
            if (co2 != null) {
              calculateCO2Index(co2);
            }
            if (o3 != null) {
              calculateO3Index(o3);
            }
            if (nh3 != null) {
              calculateNH3Index(nh3);
            }

            updateOverallStatus();
          }
        } else {
          _sensorData = null;
          _error = "No Sensor Data Available";
          _temperature = null;
          _humidity = null;
          _coIndex = null;
          _co2Index = null;
          _o3Index = null;
          _nh3Index = null;
          _coStatus = null;
          _co2Status = null;
          _o3Status = null;
          _nh3Status = null;
          _overallStatus = null;
        }
        notifyListeners();
      },
      onError: (error) {
        _isLoading = false;
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  String getStatusFromIndex(double? index) {
    if (index == null) return "TIDAK TERSEDIA";
    if (index <= 50) return "BAIK";
    if (index <= 100) return "SEDANG";
    if (index <= 150) return "TIDAK SEHAT";
    if (index <= 200) return "SANGAT TIDAK SEHAT";
    return "BERBAHAYA";
  }

  void updateOverallStatus() {
    List<double?> indices = [_coIndex, _co2Index, _o3Index, _nh3Index];
    double? maxIndex = 0;

    for (var index in indices) {
      if (index != null && (maxIndex == null || index > maxIndex)) {
        maxIndex = index;
      }
    }

    _overallStatus = getStatusFromIndex(maxIndex);
    notifyListeners();
  }

  double? calculateIndex(double value, List<Map<String, double>> ranges) {
    for (var range in ranges) {
      if (value >= range["Clo"]! && value <= range["Chi"]!) {
        double Clo = range["Clo"]!;
        double Chi = range["Chi"]!;
        double Ilo = range["Ilo"]!;
        double Ihi = range["Ihi"]!;

        return ((Ihi - Ilo) / (Chi - Clo)) * (value - Clo) + Ilo;
      }
    }
    return null;
  }

  void calculateCOIndex(double co) {
    final List<Map<String, double>> coRanges = [
      {"Clo": 0, "Chi": 4000, "Ilo": 0, "Ihi": 50},
      {"Clo": 4001, "Chi": 8000, "Ilo": 51, "Ihi": 100},
      {"Clo": 8001, "Chi": 13600, "Ilo": 101, "Ihi": 150},
      {"Clo": 13601, "Chi": 27000, "Ilo": 151, "Ihi": 200},
    ];

    _coIndex = calculateIndex(co, coRanges);
    _coStatus = getStatusFromIndex(_coIndex);
    notifyListeners();
  }

  void calculateCO2Index(double co2) {
    final List<Map<String, double>> co2Ranges = [
      {"Clo": 0, "Chi": 400, "Ilo": 0, "Ihi": 50},
      {"Clo": 401, "Chi": 800, "Ilo": 51, "Ihi": 100},
      {"Clo": 801, "Chi": 1200, "Ilo": 101, "Ihi": 150},
      {"Clo": 1201, "Chi": 2000, "Ilo": 151, "Ihi": 200},
    ];

    _co2Index = calculateIndex(co2, co2Ranges);
    _co2Status = getStatusFromIndex(_co2Index);
    notifyListeners();
  }

  void calculateO3Index(double o3) {
    final List<Map<String, double>> o3Ranges = [
      {"Clo": 0, "Chi": 61.1, "Ilo": 0, "Ihi": 50},
      {"Clo": 61.2, "Chi": 119.7, "Ilo": 51, "Ihi": 100},
      {"Clo": 119.8, "Chi": 203.8, "Ilo": 101, "Ihi": 150},
      {"Clo": 203.9, "Chi": 407.5, "Ilo": 151, "Ihi": 200},
    ];

    _o3Index = calculateIndex(o3, o3Ranges);
    _o3Status = getStatusFromIndex(_o3Index);
    notifyListeners();
  }

  void calculateNH3Index(double nh3) {
    final List<Map<String, double>> nh3Ranges = [
      {"Clo": 0, "Chi": 0.1, "Ilo": 0, "Ihi": 50},
      {"Clo": 0.11, "Chi": 0.3, "Ilo": 51, "Ihi": 100},
      {"Clo": 0.31, "Chi": 0.5, "Ilo": 101, "Ihi": 150},
      {"Clo": 0.51, "Chi": 1, "Ilo": 151, "Ihi": 200},
    ];

    _nh3Index = calculateIndex(nh3, nh3Ranges);
    _nh3Status = getStatusFromIndex(_nh3Index);
    notifyListeners();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "BAIK":
        return Colors.green;
      case "SEDANG":
        return Colors.yellow;
      case "TIDAK SEHAT":
        return Colors.orange;
      case "SANGAT TIDAK SEHAT":
        return Colors.red;
      case "BERBAHAYA":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
