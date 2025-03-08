import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmsui/model/vehicle.dart';
import 'package:tmsui/utilities/api.dart';

final vehiclesProvider = StateNotifierProvider<VehicleNotifier, VehicleState>(
      (ref) => VehicleNotifier(),
);

class VehicleState {
  final List<Vehicle> vehicles;
  final bool isLoading;
  final bool isUpdating;

  VehicleState({required this.vehicles, required this.isLoading, required this.isUpdating});
}

class VehicleNotifier extends StateNotifier<VehicleState> {

  String baseUrl = "http://10.0.2.2:8080/vehicle-service";
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isFetching = false;

  VehicleNotifier() : super(VehicleState(vehicles: [], isLoading: false, isUpdating:false)) {
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    _currentPage = 0;
    _hasMore = true;
    state = VehicleState(vehicles: [], isLoading: true, isUpdating: false);
    await loadMoreVehicles();
  }

  Future<void> loadMoreVehicles() async {
    if (!_hasMore || _isFetching) return;

    _isFetching = true;
    state = VehicleState(vehicles: state.vehicles, isLoading: true, isUpdating: false);

    try {
      final response = await APIService.request(
        '$baseUrl/vehicles?page=$_currentPage&size=10&sortBy=plateNumber&direction=asc',
        method: 'GET',
      );

      if (response.containsKey('content') && response['content'] is List) {
        final List<dynamic> contentList = response['content'];
        final newVehicles = contentList.map((e) => Vehicle.fromJson(e as Map<String, dynamic>)).toList();

        _currentPage++;
        _hasMore = _currentPage < (response['totalPages'] as int);
        state = VehicleState(vehicles: [...state.vehicles, ...newVehicles], isLoading: false, isUpdating: false);
      }
    } catch (e) {
      print("Error loading more vehicles: $e");
    }

    _isFetching = false;
    state = VehicleState(vehicles: state.vehicles, isLoading: false, isUpdating: false);
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    state = VehicleState(vehicles: [...state.vehicles], isLoading: false, isUpdating: true);

    try {
      final response = await APIService.request(
        '$baseUrl/vehicles',
        method: 'POST',
        body: vehicle.toJson(),
      );
      state = VehicleState(vehicles: [...state.vehicles, Vehicle.fromJson(response)], isLoading: false, isUpdating: false);
    } catch (e) {
      print("Error adding vehicle: $e");
    }
    state = VehicleState(vehicles: [...state.vehicles], isLoading: false, isUpdating: false);
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    state = VehicleState(vehicles: [...state.vehicles], isLoading: false, isUpdating: true);
    try {
      final response = await APIService.request(
        '$baseUrl/vehicles/${vehicle.id}',
        method: 'PUT',
        body: vehicle.toJson(),
      );
      state = VehicleState(vehicles: state.vehicles.map((v) => v.id == vehicle.id ? Vehicle.fromJson(response) : v).toList(), isLoading: false, isUpdating: false);
    } catch (e) {
      print("Error updating vehicle: $e");
    }
    state = VehicleState(vehicles: [...state.vehicles], isLoading: false, isUpdating: false);
  }

  Future<void> deleteVehicle(String id) async {
    state = VehicleState(vehicles: [...state.vehicles], isLoading: false, isUpdating: true);

    try {
      await APIService.request(
        '$baseUrl/vehicles/$id',
        method: 'DELETE',
      );
      state = VehicleState(vehicles: state.vehicles.where((v) => v.id != id).toList(), isLoading: false, isUpdating: false);
    } catch (e) {
      print("Error deleting vehicle: $e");
    }
    state = VehicleState(vehicles: [...state.vehicles], isLoading: false, isUpdating: false);
  }
}