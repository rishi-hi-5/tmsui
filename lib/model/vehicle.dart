enum VehicleStatus { available, assigned, maintenance, outOfService }

class Vehicle {
  final String id;
  final String plateNumber;
  final String owner;
  final String model;
  final String manufacturer;
  final int year;
  final VehicleStatus status;

  Vehicle({
    required this.id,
    required this.plateNumber,
    required this.owner,
    required this.model,
    required this.manufacturer,
    required this.year,
    required this.status,
  });

  /// Factory method to create a `Vehicle` instance from JSON.
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      owner: json['owner'] ?? '',
      model: json['model'] ?? '',
      manufacturer: json['manufacturer'] ?? '',
      year: json['year'] ?? 0,
      status: _parseStatus(json['status']),
    );
  }

  /// Converts the `Vehicle` instance to JSON format.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plateNumber': plateNumber,
      'owner': owner,
      'model': model,
      'manufacturer': manufacturer,
      'year': year,
      'status': _convertStatusToApiFormat(status),
    };
  }

  /// Converts API status string into `VehicleStatus` enum.
  static VehicleStatus _parseStatus(String? status) {
    if (status == null) return VehicleStatus.available; // Default fallback
    String formattedStatus = status.toLowerCase().replaceAll('_', '');
    return VehicleStatus.values.firstWhere(
          (e) => e.name.toLowerCase() == formattedStatus,
      orElse: () => VehicleStatus.available,
    );
  }

  /// Converts `VehicleStatus` enum to API-compatible format.
  static String _convertStatusToApiFormat(VehicleStatus status) {
    return status.name
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) => '${match.group(1)}_${match.group(2)}')
        .toUpperCase();
  }
}