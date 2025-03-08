import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmsui/reusable/theme.dart';
import '../apis/vehicleapi.dart';
import '../model/vehicle.dart';

class VehicleManagement extends ConsumerWidget {
  const VehicleManagement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider);
    final vehicleNotifier = ref.read(vehiclesProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text('Vehicle Management')),
      body: Stack(children: [
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.extentAfter < 300) {
              vehicleNotifier.loadMoreVehicles();
              return true;
            }
            return false;
          },
          child: ListView.builder(
              itemCount: vehicles.isLoading
                  ? vehicles.vehicles.length + 1
                  : vehicles.vehicles.length,
              itemBuilder: (context, index) {
                if (index < vehicles.vehicles.length) {
                  final vehicle = vehicles.vehicles[index];
                  return Card(
                    color: AppTheme.cardColor,
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        vehicle.plateNumber,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          "Model: ${vehicle.model}\nManufacturer: ${vehicle.manufacturer}\nYear: ${vehicle.year}\nStatus: ${vehicle.status.name}"),
                      trailing: IconButton(
                          onPressed: () =>
                              _confirmDelete(context, ref, vehicle.id),
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                      onTap: () => _showVehicleDetails(context, vehicle),
                      onLongPress: () =>
                          _showUpdateVehicleDialog(context, ref, vehicle),
                    ),
                  );
                } else {
                  return _buildLoader(ref);
                }
              }),
        ),
        if (vehicles.isUpdating)
          Container(
            color: Colors.white.withValues(alpha: 128),
            child: Center(child: CircularProgressIndicator()),
          ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () => _showAddVehicleDialog(context, ref),
        child: Icon(
          Icons.add,
          color: AppTheme.primaryTextColor,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String vehicleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.dialogColor,
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this vehicle?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.dangerColor),
              onPressed: () {
                ref.read(vehiclesProvider.notifier).deleteVehicle(vehicleId);
                Navigator.pop(context);
              },
              child: Text('Delete'))
        ],
      ),
    );
  }

  Widget _buildLoader(WidgetRef ref) {
    final vehicles = ref.watch(vehiclesProvider);
    return vehicles.isLoading
        ? Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
    )
        : SizedBox.shrink();
  }

  void _showVehicleDetails(BuildContext context, Vehicle vehicle) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.dialogColor,
          title: Text("Vehicle Details"),
          content: Text(
              "License Plate: ${vehicle.plateNumber}\nModel: ${vehicle.model}\nManufacturer: ${vehicle.manufacturer}\nYear: ${vehicle.year}\nStatus: ${vehicle.status.name}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        ));
  }

  void _showAddVehicleDialog(BuildContext context, WidgetRef ref) {
    TextEditingController ownerController = TextEditingController();
    TextEditingController plateController = TextEditingController();
    TextEditingController modelController = TextEditingController();
    TextEditingController manufacturerController = TextEditingController();
    TextEditingController yearController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.dialogColor,
          title: Text("Add Vehicle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: ownerController,
                  decoration: InputDecoration(labelText: "Owner")),
              TextField(
                  controller: plateController,
                  decoration: InputDecoration(labelText: "License Plate")),
              TextField(
                  controller: modelController,
                  decoration: InputDecoration(labelText: "Model")),
              TextField(
                  controller: manufacturerController,
                  decoration: InputDecoration(labelText: "Manufacturer")),
              TextField(
                  controller: yearController,
                  decoration: InputDecoration(labelText: "Year")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
                onPressed: () {
                  ref.read(vehiclesProvider.notifier).addVehicle(
                    Vehicle(
                        id: "",
                        owner: ownerController.text,
                        plateNumber: plateController.text,
                        model: modelController.text,
                        manufacturer: manufacturerController.text,
                        year: int.tryParse(yearController.text) ?? 0,
                        status: VehicleStatus.available),
                  );
                  Navigator.pop(context);
                },
                child: Text("Add"))
          ],
        ));
  }

  void _showUpdateVehicleDialog(BuildContext context, WidgetRef ref, Vehicle vehicle) {
    TextEditingController ownerController = TextEditingController(text: vehicle.owner);
    TextEditingController plateController = TextEditingController(text: vehicle.plateNumber);
    TextEditingController modelController = TextEditingController(text: vehicle.model);
    TextEditingController manufacturerController = TextEditingController(text: vehicle.manufacturer);
    TextEditingController yearController = TextEditingController(text: vehicle.year.toString());
    VehicleStatus selectedStatus = vehicle.status;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.dialogColor,
          title: Text("Update Vehicle"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: ownerController, decoration: InputDecoration(labelText: "Owner")),
              TextField(controller: plateController, decoration: InputDecoration(labelText: "License Plate")),
              TextField(controller: modelController, decoration: InputDecoration(labelText: "Model")),
              TextField(controller: manufacturerController, decoration: InputDecoration(labelText: "Manufacturer")),
              TextField(controller: yearController, decoration: InputDecoration(labelText: "Year")),
              DropdownButtonFormField<VehicleStatus>(
                value: selectedStatus,
                decoration: InputDecoration(labelText: "Status"),
                items: VehicleStatus.values.map((status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Text(status.name),
                  );
                }).toList(),
                onChanged: (status) {
                  if (status != null) {
                    selectedStatus = status;
                  }
                },
              )
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(
                onPressed: () {
                  ref.read(vehiclesProvider.notifier).updateVehicle(
                    Vehicle(
                      id: vehicle.id,
                      owner: ownerController.text,
                      plateNumber: plateController.text,
                      model: modelController.text,
                      manufacturer: manufacturerController.text,
                      year: int.tryParse(yearController.text) ?? vehicle.year,
                      status: selectedStatus
                    ),
                  );
                  Navigator.pop(context);
                },
                child: Text("Update"))
          ],
        ));
  }
}
