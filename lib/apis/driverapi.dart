import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmsui/model/driver.dart';
import 'package:tmsui/utilities/api.dart';


final driversProvider = StateNotifierProvider<DriverNotifier, DriverState>(
      (ref) => DriverNotifier(),
);


class DriverState {
  final List<Driver> drivers;
  final bool isLoading;
  final bool isUpdating;

  DriverState({required this.drivers, required this.isLoading, required this.isUpdating});
}

class DriverNotifier extends StateNotifier<DriverState> {

  String baseUrl = "http://10.0.2.2:9091/driver-service";
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isFetching = false; // Prevent duplicate fetch calls

  DriverNotifier() : super(DriverState(drivers: [], isLoading: false, isUpdating:false)) {
    fetchDrivers();
  }

   Future<void> fetchDrivers() async {
     _currentPage = 0; // Reset pagination when fetching the first page
     _hasMore = true;
     state=DriverState(drivers: [], isLoading: true,isUpdating: false);
     await loadMoreDrivers();
   }

  Future<void> loadMoreDrivers() async {
    if (!_hasMore || _isFetching) return;

    _isFetching = true;
    state = DriverState(drivers: state.drivers, isLoading: true,isUpdating: false);

    try {
      final response = await APIService.request(
        '$baseUrl/drivers?page=$_currentPage&size=10&sortBy=name&direction=asc',
        method: 'GET',
      );

      if (response.containsKey('content') && response['content'] is List) {
        final List<dynamic> contentList = response['content'];
        final newDrivers = contentList.map((e) => Driver.fromJson(e as Map<String, dynamic>)).toList();

        _currentPage++;

        _hasMore = _currentPage < (response['totalPages'] as int);
        state = DriverState(drivers: [...state.drivers, ...newDrivers], isLoading: false,isUpdating: false);
      } else {
        print("Unexpected response format: $response");
      }
    } catch (e) {
      print("Error loading more drivers: $e");
    }

    _isFetching = false;
    state = DriverState(drivers: state.drivers, isLoading: false,isUpdating: false);
  }

  Future<void> addDriver(Driver driver) async {
    state = DriverState(drivers: [...state.drivers], isLoading: false,isUpdating: true);

    try {
      final response = await APIService.request(
        '$baseUrl/drivers',
        method: 'POST',
        body: driver.toJson(),
      );
      state = DriverState(drivers: [...state.drivers, Driver.fromJson(response)], isLoading: false,isUpdating: false);
    } catch (e) {
      print("Error adding driver: $e");
    }
    state = DriverState(drivers: [...state.drivers], isLoading: false,isUpdating: false);
  }

  Future<void> updateDriver(Driver driver) async {
    state = DriverState(drivers: [...state.drivers], isLoading: false,isUpdating: true);
    try {
      final response = await APIService.request(
        '$baseUrl/drivers/${driver.id}',
        method: 'PUT',
        body: driver.toJson(),
      );
      state = DriverState(drivers:state.drivers.map((d) => d.id == driver.id ? Driver.fromJson(response) : d).toList(), isLoading: false,isUpdating: false);
    } catch (e) {
      print("Error updating driver: $e");
    }
    state = DriverState(drivers: [...state.drivers], isLoading: false,isUpdating: false);
  }

  Future<void> deleteDriver(String id) async {
    state = DriverState(drivers: [...state.drivers], isLoading: false,isUpdating: true);

    try {
      await APIService.request(
        '$baseUrl/drivers/$id',
        method: 'DELETE',
      );
      state = DriverState(drivers: state.drivers.where((d) => d.id != id).toList(), isLoading: false,isUpdating: false);
    } catch (e) {
      print("Error deleting driver: $e");
    }
    state = DriverState(drivers: [...state.drivers], isLoading: false,isUpdating: false);
  }
}