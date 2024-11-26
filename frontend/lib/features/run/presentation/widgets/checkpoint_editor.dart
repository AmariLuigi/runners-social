import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/models/run_session.dart';
import 'animated_location_marker.dart';

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

class _CheckpointEditorState extends State<CheckpointEditor> with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  final List<CircleMarker> _circles = [];

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
    final primaryColor = Theme.of(context).primaryColor;
    
    setState(() {
      _markers.add(
        Marker(
          point: position,
          width: 60,
          height: 80,
          builder: (context) => GestureDetector(
            onPanEnd: (details) => _updateCheckpointPosition(index, position),
            child: AnimatedLocationMarker(
              color: primaryColor,
              child: Icon(
                Icons.location_on,
                color: primaryColor,
                size: 30,
              ),
              label: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      _circles.add(
        CircleMarker(
          point: position,
          radius: widget.checkpoints[index]['radius'],
          color: primaryColor.withOpacity(0.1),
          borderColor: primaryColor,
          borderStrokeWidth: 2,
          useRadiusInMeter: true,
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

  void _addNewCheckpoint() {
    final center = _mapController.center;

    final checkpoint = {
      'name': 'Checkpoint ${widget.checkpoints.length + 1}',
      'location': {
        'latitude': center.latitude,
        'longitude': center.longitude,
      },
      'radius': 20.0,
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
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    center: const LatLng(0, 0),
                    zoom: 15,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.runners_social.app',
                    ),
                    MarkerLayer(markers: _markers),
                    CircleLayer(circles: _circles),
                  ],
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

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Checkpoint'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
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
                      setState(() {
                        radius = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final updatedCheckpoints = [...widget.checkpoints];
              updatedCheckpoints[index] = {
                ...updatedCheckpoints[index],
                'name': nameController.text,
                'description': descriptionController.text,
                'radius': radius,
              };
              widget.onCheckpointsChanged(updatedCheckpoints);
              _initializeMarkers();
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
