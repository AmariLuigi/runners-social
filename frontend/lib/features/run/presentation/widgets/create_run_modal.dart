import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/run.dart';
import '../../providers/run_provider.dart';

class CreateRunModal extends ConsumerStatefulWidget {
  const CreateRunModal({Key? key}) : super(key: key);

  @override
  _CreateRunModalState createState() => _CreateRunModalState();
}

class _CreateRunModalState extends ConsumerState<CreateRunModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  RunType _runType = RunType.solo;
  DateTime _startTime = DateTime.now().add(const Duration(hours: 1));
  int? _maxParticipants;
  String _privacy = 'public';
  String? _runStyle;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
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
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Run',
                  style: Theme.of(context).textTheme.titleLarge,
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
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
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
                      child: Text(type.toString().split('.').last.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _runType = value!;
                    });
                  },
                ),
                if (_runType == RunType.group) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Max Participants (optional)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _maxParticipants = int.tryParse(value);
                      });
                    },
                  ),
                ],
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Run Style (optional)',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Easy pace, Training, Race pace',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _runStyle = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDateTime(context),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Start Time',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      DateFormat('MMM d, y • h:mm a').format(_startTime),
                    ),
                  ),
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
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final run = Run(
                          id: '',
                          name: _nameController.text,
                          type: _runType,
                          status: RunStatus.planned,
                          startTime: _startTime,
                          description: _descriptionController.text.isEmpty
                              ? null
                              : _descriptionController.text,
                          runStyle: _runStyle,
                          maxParticipants: _maxParticipants,
                          privacy: _privacy,
                        );

                        try {
                          await ref.read(runProvider.notifier).createRun(run);
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to create run: $e')),
                            );
                          }
                        }
                      }
                    },
                    child: const Text('Create Run'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
