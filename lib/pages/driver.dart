import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:tmsui/reusable/theme.dart';
import '../apis/driverapi.dart';
import '../model/driver.dart';

class DriverManagement extends ConsumerWidget {
  const DriverManagement({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final drivers = ref.watch(driversProvider);
    final driverNotifier = ref.read(driversProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: Text('Driver Management')),
      body: Stack(children: [
        NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.extentAfter < 300) {
              driverNotifier
                  .loadMoreDrivers(); // Load more when scrolled to bottom
              return true;
            }
            return false;
          },
          child: ListView.builder(
              itemCount: drivers.isLoading
                  ? drivers.drivers.length + 1
                  : drivers.drivers.length,
              itemBuilder: (context, index) {
                if (index < drivers.drivers.length) {
                  final driver = drivers.drivers[index];
                  return Card(
                    color: AppTheme.cardColor,
                    margin: EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                        driver.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          "Email: ${driver.email}\nPhone: ${driver.phone}\nVehicle ID: ${driver.vehicleId}\nStatus: ${driver.status.name}"),
                      trailing: IconButton(
                          onPressed: () =>
                              _confirmDelete(context, ref, driver.id),
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                      onTap: () => _showDriverDetails(context, driver),
                      onLongPress: () => _showUpdateDriverDialog(context, ref, driver),
                    ),
                  );
                } else {
                  return _buildLoader(ref); // Show loader at the bottom
                }
              }),
        ),
        if (drivers.isUpdating)
          Container(
            color: Colors.white.withValues(alpha: 128),
            child: Center(
                child:
                    CircularProgressIndicator()), // Show loading overlay on add/delete
          ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        onPressed: () => _showAddDriverDialog(context, ref),
        child: Icon(
          Icons.add,
          color: AppTheme.primaryTextColor,
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String driverId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.dialogColor,
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this driver?'),
        actions: [
          TextButton(
            style:
                TextButton.styleFrom(foregroundColor: AppTheme.secondaryColor),
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AppTheme.secondaryTextColor)),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.dangerColor),
              onPressed: () => {
                    ref.read(driversProvider.notifier).deleteDriver(driverId),
                    Navigator.pop(context)
                  },
              child: Text('Delete',
                  style: TextStyle(color: AppTheme.primaryTextColor)))
        ],
      ),
    );
  }

  Widget _buildLoader(WidgetRef ref) {
    final drivers = ref.watch(driversProvider);
    return drivers.isLoading
        ? Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          )
        : SizedBox.shrink();
  }

  void _showDriverDetails(BuildContext context, Driver driver) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: AppTheme.dialogColor,
              title: Text("Driver Details"),
              content: Text(
                  "Driver Name: ${driver.name}\nLicense: ${driver.licenseNumber}\nEmail: ${driver.email}\nPhone: ${driver.phone}\nVehicle ID: ${driver.vehicleId}\nStatus: ${driver.status.name}"),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: AppTheme.primaryTextColor),
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ],
            ));
  }

  void _showAddDriverDialog(BuildContext context, WidgetRef ref) {
    TextEditingController nameController = TextEditingController();
    TextEditingController licenseController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: AppTheme.dialogColor,
              title: Text("Add driver"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      style: TextStyle(color: AppTheme.secondaryTextColor),
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Name")),
                  TextField(
                      style: TextStyle(color: AppTheme.secondaryTextColor),
                      controller: licenseController,
                      decoration: InputDecoration(labelText: "License Number")),
                  TextField(
                      style: TextStyle(color: AppTheme.secondaryTextColor),
                      controller: emailController,
                      decoration: InputDecoration(labelText: "Email")),
                  TextField(
                      style: TextStyle(color: AppTheme.secondaryTextColor),
                      controller: phoneController,
                      decoration: InputDecoration(labelText: "Phone Number")),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                    onPressed: () {
                      ref.read(driversProvider.notifier).addDriver(
                            Driver(
                                id: "",
                                name: nameController.text,
                                licenseNumber: licenseController.text,
                                email: emailController.text,
                                phone: phoneController.text,
                                vehicleId: "",
                                status: DriverStatus.available),
                          );
                      Navigator.pop(context);
                    },
                    child: Text("Add"))
              ],
            ));
  }

  void _showUpdateDriverDialog(BuildContext context, WidgetRef ref, Driver driver) {
    TextEditingController nameController = TextEditingController(text: driver.name);
    TextEditingController licenseController = TextEditingController(text: driver.licenseNumber);
    TextEditingController emailController = TextEditingController(text: driver.email);
    TextEditingController phoneController = TextEditingController(text: driver.phone);
    DriverStatus selectedStatus = driver.status;

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppTheme.dialogColor,
          title: Text("Update Driver"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name")),
              TextField(
                  controller: licenseController,
                  decoration: InputDecoration(labelText: "License Number")),
              TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email")),
              TextField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: "Phone Number")),
              DropdownButtonFormField<DriverStatus>(
                value: selectedStatus,
                decoration: InputDecoration(labelText: "Status"),
                items: DriverStatus.values.map((status) {
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
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
                onPressed: () {
                  ref.read(driversProvider.notifier).updateDriver(
                    Driver(
                        id: driver.id,
                        name: nameController.text,
                        licenseNumber: licenseController.text,
                        email: emailController.text,
                        phone: phoneController.text,
                        vehicleId: driver.vehicleId,
                        status: selectedStatus),
                  );
                  Navigator.pop(context);
                },
                child: Text("Update"))
          ],
        ));
  }
}
