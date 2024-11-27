import 'package:flutter/material.dart';

class CreateGroupRunDialog extends StatefulWidget {
  const CreateGroupRunDialog({super.key});

  @override
  State<CreateGroupRunDialog> createState() => _CreateGroupRunDialogState();
}

class _CreateGroupRunDialogState extends State<CreateGroupRunDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _startTime = DateTime.now().add(const Duration(minutes: 30));
  double _targetDistance = 5.0;
  Duration _targetDuration = const Duration(minutes: 30);
  int _maxParticipants = 5;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
                FilledButton(
                  onPressed: () {
                    if (_titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a title')),
                      );
                      return;
                    }
                    // TODO: Create group run in backend
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Create'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
