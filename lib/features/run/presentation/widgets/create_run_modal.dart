import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/run.dart';
import '../../providers/run_provider.dart';

class CreateRunModal extends ConsumerStatefulWidget {
  const CreateRunModal({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Create New Run',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
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
            TextFormField(
              controller: _distanceController,
              decoration: const InputDecoration(
                labelText: 'Distance Goal (km)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a distance goal';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Date'),
              subtitle: Text(
                '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _selectDate,
              ),
            ),
            ListTile(
              title: const Text('Time'),
              subtitle: Text('${_selectedTime.hour}:${_selectedTime.minute}'),
              trailing: IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: _selectTime,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<RunType>(
              value: _runType,
              decoration: const InputDecoration(
                labelText: 'Run Type',
                border: OutlineInputBorder(),
              ),
              items: RunType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _runType = value;
                  });
                }
              },
            ),
            if (_runType == RunType.group) ...[
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Public Run'),
                value: _isPublic,
                onChanged: (value) {
                  setState(() {
                    _isPublic = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Enable Chat'),
                value: _hasChatEnabled,
                onChanged: (value) {
                  setState(() {
                    _hasChatEnabled = value;
                  });
                },
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final startTime = DateTime(
                    _selectedDate.year,
                    _selectedDate.month,
                    _selectedDate.day,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  );

                  final run = Run(
                    id: const Uuid().v4(),
                    name: _nameController.text,
                    type: _runType,
                    status: RunStatus.upcoming,
                    startTime: startTime,
                    locationName: 'Selected Location', // TODO: Get actual location
                    distanceGoal: double.tryParse(_distanceController.text),
                    isPublic: _isPublic,
                    hasChatEnabled: _hasChatEnabled,
                    participants: ['current_user'], // Mock user ID
                    isParticipant: true,
                  );

                  ref.read(runProvider.notifier).addRun(run);
                  Navigator.pop(context);
                }
              },
              child: const Text('Create Run'),
            ),
          ],
        ),
      ),
    );
  }
}
