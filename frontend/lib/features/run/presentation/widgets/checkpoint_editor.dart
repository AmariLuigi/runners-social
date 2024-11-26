import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/models/run_session.dart';

class CheckpointEditor extends StatefulWidget {
  final List<Map<String, dynamic>> checkpoints;
  final Function(List<Map<String, dynamic>>) onCheckpointsChanged;

  const CheckpointEditor({
    super.key,
    required this.checkpoints,
    required this.onCheckpointsChanged,
  });

  @override
  State<CheckpointEditor> createState() => _CheckpointEditorState();
}

class _CheckpointEditorState extends State<CheckpointEditor> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Circle> _circles = {};

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    _markers.clear();
    _circles.clear();
    for (var i = 0; i < widget.checkpoints.length; i++) {
      final checkpoint = widget.checkpoints[i];
      _addCheckpointMarker(
        LatLng(checkpoint['location']['latitude'], checkpoint['location']['longitude']),
        checkpoint['name'],
        i,
      );
    }
  }

  void _addCheckpointMarker(LatLng position, String name, int index) {
    final markerId = MarkerId('checkpoint_$index');
    final circleId = CircleId('checkpoint_$index');

    setState(() {
      _markers.add(
        Marker(
          markerId: markerId,
          position: position,
          infoWindow: InfoWindow(title: name),
          draggable: true,
          onDragEnd: (newPosition) => _updateCheckpointPosition(index, newPosition),
        ),
      );

      _circles.add(
        Circle(
          circleId: circleId,
          center: position,
          radius: widget.checkpoints[index]['radius'] as double,
          fillColor: Colors.blue.withOpacity(0.2),
          strokeColor: Colors.blue,
          strokeWidth: 1,
        ),
      );
    });
  }

  void _updateCheckpointPosition(int index, LatLng position) {
    final updatedCheckpoints = [...widget.checkpoints];
    updatedCheckpoints[index] = {
      ...updatedCheckpoints[index],
      'location': {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
    };
    widget.onCheckpointsChanged(updatedCheckpoints);
    _initializeMarkers();
  }

  void _addNewCheckpoint() async {
    final center = await _mapController.getLatLng(
      ScreenCoordinate(
        x: MediaQuery.of(context).size.width ~/ 2,
        y: MediaQuery.of(context).size.height ~/ 2,
      ),
    );

    final checkpoint = {
      'name': 'Checkpoint ${widget.checkpoints.length + 1}',
      'location': {
        'latitude': center.latitude,
        'longitude': center.longitude,
      },
      'radius': 20,
    };

    final newCheckpoints = [...widget.checkpoints, checkpoint];
    widget.onCheckpointsChanged(newCheckpoints);
    _initializeMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Checkpoints',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNewCheckpoint,
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(0, 0),
                    zoom: 15,
                  ),
                  onMapCreated: (controller) {
                    _mapController = controller;
                  },
                  markers: _markers,
                  circles: _circles,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.checkpoints.length,
              itemBuilder: (context, index) {
                final checkpoint = widget.checkpoints[index];
                return ListTile(
                  key: Key('checkpoint_$index'),
                  leading: ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle),
                  ),
                  title: Text(checkpoint['name']),
                  subtitle: Text(
                    'Radius: ${checkpoint['radius']}m',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      final updatedCheckpoints = [...widget.checkpoints];
                      updatedCheckpoints.removeAt(index);
                      widget.onCheckpointsChanged(updatedCheckpoints);
                      _initializeMarkers();
                    },
                  ),
                  onTap: () => _editCheckpoint(index),
                );
              },
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final updatedCheckpoints = [...widget.checkpoints];
                final item = updatedCheckpoints.removeAt(oldIndex);
                updatedCheckpoints.insert(newIndex, item);
                widget.onCheckpointsChanged(updatedCheckpoints);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editCheckpoint(int index) async {
    final checkpoint = widget.checkpoints[index];
    final nameController = TextEditingController(text: checkpoint['name']);
    final descriptionController =
        TextEditingController(text: checkpoint['description'] ?? '');
    double radius = checkpoint['radius'];

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Checkpoint'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Radius (m): '),
                  Expanded(
                    child: Slider(
                      value: radius,
                      min: 10,
                      max: 100,
                      divisions: 18,
                      label: radius.round().toString(),
                      onChanged: (value) {
                        radius = value;
                        (context as Element).markNeedsBuild();
                      },
                    ),
                  ),
                  Text(radius.round().toString()),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop({
              'name': nameController.text,
              'description': descriptionController.text,
              'radius': radius,
            }),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      final updatedCheckpoints = [...widget.checkpoints];
      updatedCheckpoints[index] = {
        ...updatedCheckpoints[index],
        ...result,
      };
      widget.onCheckpointsChanged(updatedCheckpoints);
      _initializeMarkers();
    }
  }
}
