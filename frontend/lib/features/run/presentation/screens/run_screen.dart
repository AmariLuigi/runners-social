import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import '../../../../core/models/location_model.dart';
import '../../../../core/services/socket_service.dart';
import '../widgets/run_completion_modal_new.dart';
import '../widgets/create_group_run_dialog.dart';
import 'active_run_screen.dart';

class RunScreen extends StatefulWidget {
  const RunScreen({super.key});

  @override
  State<RunScreen> createState() => _RunScreenState();
}

class _RunScreenState extends State<RunScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Runs'),
      ),
      body: ListView.builder(
        itemCount: 10, // TODO: Replace with actual runs list
        itemBuilder: (context, index) {
          // TODO: Replace with actual run data
          final isGroupRun = index % 2 == 0;
          final startTime = DateTime.now().subtract(Duration(days: index));
          
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: isGroupRun ? Colors.orange : Colors.green,
                child: Icon(
                  isGroupRun ? Icons.group : Icons.person,
                  color: Colors.white,
                ),
              ),
              title: Text(isGroupRun ? 'Evening Group Run' : 'Morning Solo Run'),
              subtitle: Text(
                'Starting ${startTime.day}/${startTime.month} at ${startTime.hour}:${startTime.minute.toString().padLeft(2, '0')}\n'
                '${isGroupRun ? '5 participants • ' : ''}5.0 km • 30 min',
              ),
              isThreeLine: true,
              trailing: isGroupRun && index < 3 
                ? ElevatedButton(
                    onPressed: () {
                      // TODO: Join group run
                    },
                    child: const Text('Join'),
                  )
                : null,
              onTap: () {
                // TODO: View run details
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Start Solo Run'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        '/active-run',
                        arguments: {
                          'runId': DateTime.now().millisecondsSinceEpoch.toString(),
                        },
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.group),
                    title: const Text('Create Group Run'),
                    onTap: () {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (context) => const CreateGroupRunDialog(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
