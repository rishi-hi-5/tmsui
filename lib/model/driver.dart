enum DriverStatus { available, onTrip, suspended }

class Driver {
  final String id;
  final String name;
  final String licenseNumber;
  final String email;
  final String phone;
  final String vehicleId;
  final DriverStatus status;

  Driver({
    required this.id,
    required this.name,
    required this.licenseNumber,
    required this.email,
    required this.phone,
    required this.vehicleId,
    required this.status,
  });

  /// Factory method to create a `Driver` instance from JSON.
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      licenseNumber: json['licenseNumber'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      vehicleId: json['vehicleId'] ?? '',
      status: _parseStatus(json['status']),
    );
  }

  /// Converts the `Driver` instance to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'licenseNumber': licenseNumber,
      'email': email,
      'phone': phone,
      'vehicleId': vehicleId,
      'status': _convertStatusToApiFormat(status),
    };
  }

  /// Converts API status string into `DriverStatus` enum.
  static DriverStatus _parseStatus(String? status) {
    if (status == null) return DriverStatus.available; // Default fallback
    String formattedStatus = status.toLowerCase().replaceAll('_', '');
    return DriverStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == formattedStatus,
      orElse: () => DriverStatus.available,
    );
  }

  /// Converts `DriverStatus` enum to API-compatible format.
  static String _convertStatusToApiFormat(DriverStatus status) {
    return status.name
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) => '${match.group(1)}_${match.group(2)}')
        .toUpperCase();
  }
}
