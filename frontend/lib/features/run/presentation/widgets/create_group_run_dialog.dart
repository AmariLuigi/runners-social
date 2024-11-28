import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/entities/run.dart';
import '../../providers/run_provider.dart';
import '../widgets/route_map.dart';

class CreateGroupRunDialog extends ConsumerStatefulWidget {
  const CreateGroupRunDialog({super.key});

  @override
  ConsumerState<CreateGroupRunDialog> createState() => _CreateGroupRunDialogState();
}

class _CreateGroupRunDialogState extends ConsumerState<CreateGroupRunDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _startTime = DateTime.now().add(const Duration(minutes: 30));
  double _targetDistance = 5.0;
  Duration _targetDuration = const Duration(minutes: 30);
  int _maxParticipants = 5;
  bool _hasPlannedRoute = false;
  List<RoutePoint> _routePoints = [];
  double? _plannedDistance;
  bool _hasLocationPermission = false;
  String _runType = 'group';
  String _privacy = 'public';

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    setState(() {
      _hasLocationPermission = true;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateRoute(List<RoutePoint> points) {
    setState(() {
      _routePoints = points;
      if (_routePoints.isNotEmpty) {
        _hasPlannedRoute = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create Group Run',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _runType,
              decoration: const InputDecoration(
                labelText: 'Run Type',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'group', child: Text('GROUP')),
                DropdownMenuItem(value: 'solo', child: Text('SOLO')),
              ],
              onChanged: (value) {
                setState(() {
                  _runType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _privacy,
              decoration: const InputDecoration(
                labelText: 'Privacy',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'public', child: Text('Public')),
                DropdownMenuItem(value: 'private', child: Text('Private')),
              ],
              onChanged: (value) {
                setState(() {
                  _privacy = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Start Time'),
              subtitle: Text(
                '${_startTime.day}/${_startTime.month}/${_startTime.year} at ${_startTime.hour}:${_startTime.minute.toString().padLeft(2, '0')}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: _startTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (date != null && mounted) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_startTime),
                  );
                  if (time != null) {
                    setState(() {
                      _startTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );
                    });
                  }
                }
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Plan Route'),
              value: _hasPlannedRoute,
              onChanged: (value) {
                setState(() {
                  _hasPlannedRoute = value;
                  if (!value) {
                    _routePoints = [];
                    _plannedDistance = null;
                  }
                });
              },
            ),
            if (_hasPlannedRoute) ...[
              const SizedBox(height: 16),
              const Text(
                'Route Planning',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (!_hasLocationPermission)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Location permission is required for route planning. Please enable location services and grant permission.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              else
                SizedBox(
                  height: 300,
                  child: GestureDetector(
                    onVerticalDragUpdate: (_) {},
                    child: RouteMap(
                      routePoints: _routePoints,
                      onRouteChanged: _updateRoute,
                      isEditable: true,
                    ),
                  ),
                ),
              if (_plannedDistance != null) ...[
                const SizedBox(height: 8),
                Text(
                  'Planned Distance: ${(_plannedDistance! / 1000).toStringAsFixed(2)} km',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ] else ...[
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Target Distance (km)'),
                        Slider(
                          value: _targetDistance,
                          min: 1,
                          max: 42.2,
                          divisions: 412,
                          label: _targetDistance.toStringAsFixed(1),
                          onChanged: (value) {
                            setState(() {
                              _targetDistance = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Text('${_targetDistance.toStringAsFixed(1)} km'),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Target Duration (min)'),
                      Slider(
                        value: _targetDuration.inMinutes.toDouble(),
                        min: 5,
                        max: 240,
                        divisions: 47,
                        label: _targetDuration.inMinutes.toString(),
                        onChanged: (value) {
                          setState(() {
                            _targetDuration = Duration(minutes: value.toInt());
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Text('${_targetDuration.inMinutes} min'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Max Participants'),
                      Slider(
                        value: _maxParticipants.toDouble(),
                        min: 2,
                        max: 20,
                        divisions: 18,
                        label: _maxParticipants.toString(),
                        onChanged: (value) {
                          setState(() {
                            _maxParticipants = value.toInt();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Text(_maxParticipants.toString()),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (_titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a title')),
                      );
                      return;
                    }

                    try {
                      final run = Run(
                        id: '',
                        name: _titleController.text,
                        description: _descriptionController.text,
                        startTime: _startTime,
                        status: 'planned',
                        type: _runType,
                        privacy: _privacy,
                        style: 'free',
                        participants: [
                          Participant(
                            id: '674599ee41268c5e7d97fa01', // Current user ID
                            username: 'Current User',
                            role: 'host',
                            isActive: true,
                          ),
                        ],
                        plannedDistance: _targetDistance,
                        routePoints: _routePoints,
                      );

                      final payload = {
                        'plannedDistance': _targetDistance,
                        if (_routePoints.isNotEmpty) 'routePoints': _routePoints.map((p) => p.toJson()).toList(),
                      };

                      await ref.read(runProvider.notifier).createRun(run, payload);
                      
                      if (mounted) {
                        Navigator.of(context).pop(run);
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to create run: $e')),
                        );
                      }
                    }
                  },
                  child: const Text('Create Run'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
