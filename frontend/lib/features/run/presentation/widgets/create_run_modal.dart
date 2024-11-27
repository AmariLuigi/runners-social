import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod/riverpod.dart';
import '../../domain/entities/run.dart';
import '../../providers/run_provider.dart';

class CreateRunModal extends ConsumerStatefulWidget {
  const CreateRunModal({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateRunModal> createState() => _CreateRunModalState();
}

class _CreateRunModalState extends ConsumerState<CreateRunModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _distanceController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  RunType _runType = RunType.solo;
  bool _isPublic = false;
  bool _hasChatEnabled = true;
  LatLng? _selectedLocation;
  final List<String> _selectedFriends = [];

  @override
  void dispose() {
    _nameController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Widget _buildMapPicker() {
    return SizedBox(
      height: 200,
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(51.5, -0.09),
          zoom: 13.0,
          onTap: (tapPosition, point) {
            setState(() {
              _selectedLocation = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          if (_selectedLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  width: 40.0,
                  height: 40.0,
                  point: _selectedLocation!,
                  builder: (ctx) => const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Run Type Selector
              SegmentedButton<RunType>(
                segments: const [
                  ButtonSegment<RunType>(
                    value: RunType.solo,
                    label: Text('Solo Run'),
                    icon: Icon(Icons.person),
                  ),
                  ButtonSegment<RunType>(
                    value: RunType.group,
                    label: Text('Group Run'),
                    icon: Icon(Icons.group),
                  ),
                ],
                selected: {_runType},
                onSelectionChanged: (Set<RunType> newSelection) {
                  setState(() {
                    _runType = newSelection.first;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              // Run Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Run Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a run name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date and Time Pickers
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _selectTime,
                      icon: const Icon(Icons.access_time),
                      label: Text(
                        _selectedTime.format(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Distance Goal
              TextFormField(
                controller: _distanceController,
                decoration: const InputDecoration(
                  labelText: 'Distance Goal (km)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              // Location Picker
              const Text(
                'Select Location',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              _buildMapPicker(),
              const SizedBox(height: 16),

              // Group Run Options
              if (_runType == RunType.group) ...[
                // Public/Private Toggle
                SwitchListTile(
                  title: const Text('Public Run'),
                  subtitle: const Text('Anyone can join this run'),
                  value: _isPublic,
                  onChanged: (bool value) {
                    setState(() {
                      _isPublic = value;
                    });
                  },
                ),

                // Chat Enable/Disable
                SwitchListTile(
                  title: const Text('Enable Group Chat'),
                  subtitle: const Text('Allow participants to chat'),
                  value: _hasChatEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _hasChatEnabled = value;
                    });
                  },
                ),

                // Friend Selection (Mock)
                const Text(
                  'Invite Friends',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: const Text('John'),
                      selected: _selectedFriends.contains('John'),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedFriends.add('John');
                          } else {
                            _selectedFriends.remove('John');
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: const Text('Sarah'),
                      selected: _selectedFriends.contains('Sarah'),
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedFriends.add('Sarah');
                          } else {
                            _selectedFriends.remove('Sarah');
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 24),
              
              // Create Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() && _selectedLocation != null) {
                      final notifier = ref.read(runProvider.notifier);
                      notifier.addRun(
                        name: _nameController.text,
                        type: _runType,
                        startTime: selectedDateTime,
                        location: _selectedLocation!,
                        locationName: 'Selected Location', // TODO: Implement reverse geocoding
                        distanceGoal: _distanceController.text.isNotEmpty
                            ? double.parse(_distanceController.text)
                            : null,
                        isPublic: _runType == RunType.group ? _isPublic : null,
                        participants: _runType == RunType.group ? _selectedFriends : null,
                        hasChatEnabled: _runType == RunType.group ? _hasChatEnabled : null,
                      );
                      Navigator.pop(context);
                    } else if (_selectedLocation == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a location for the run'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Create Run'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
