import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/models/run_session.dart';
import '../widgets/checkpoint_editor.dart';
import '../providers/run_provider.dart';
import '../../../../core/services/user_service.dart';

class RunCreateScreen extends ConsumerStatefulWidget {
  const RunCreateScreen({super.key});

  @override
  ConsumerState<RunCreateScreen> createState() => _RunCreateScreenState();
}

class _RunCreateScreenState extends ConsumerState<RunCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _userService = GetIt.I<UserService>();
  
  DateTime? _scheduledStart;
  List<Map<String, dynamic>> _checkpoints = [];
  int _maxParticipants = 10;
  String _runType = 'solo';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createRun() async {
    if (_formKey.currentState!.validate()) {
      try {
        final notifier = ref.read(runCreationProvider.notifier);
        final now = DateTime.now();
        final userId = _userService.currentUserId;
        final username = _userService.username;
        
        if (userId == null || username == null) {
          throw Exception('User not logged in');
        }
        
        final run = RunSession(
          title: _titleController.text,
          description: _descriptionController.text,
          user: User(
            id: userId,
            username: username,
          ),
          participants: [
            Participant(
              user: User(
                id: userId,
                username: username,
              ),
              role: 'host',
              joinedAt: now,
              status: 'ready',
              id: '',  // Will be set by server
            ),
          ],
          status: 'planned',
          type: _runType,
          runStyle: 'free',
          startTime: now,
          scheduledStart: _scheduledStart ?? now,
          checkpoints: _checkpoints.map((cp) => Checkpoint.fromJson(cp)).toList(),
          chat: [],
          maxParticipants: _maxParticipants,
          privacy: 'public',
          tags: [],
          metrics: [],
          photos: [],
          comments: [],
          likes: [],
          createdAt: now,
          updatedAt: now,
        );

        await notifier.createRun(run);
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create run: $e')),
        );
      }
    }
  }

  Widget _buildCheckpointEditor() {
    return CheckpointEditor(
      checkpoints: _checkpoints,
      onCheckpointsChanged: (checkpoints) {
        setState(() {
          _checkpoints = checkpoints;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Run'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter a title for your run',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter a description for your run',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'solo',
                  label: Text('Solo Run'),
                  icon: Icon(Icons.person),
                ),
                ButtonSegment(
                  value: 'group',
                  label: Text('Group Run'),
                  icon: Icon(Icons.group),
                ),
              ],
              selected: {_runType},
              onSelectionChanged: (values) {
                setState(() {
                  _runType = values.first;
                });
              },
            ),
            if (_runType == 'group') ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Maximum Participants',
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      initialValue: _maxParticipants.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Max',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _maxParticipants = int.tryParse(value) ?? 10;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Scheduled Start'),
              subtitle: Text(_scheduledStart != null
                  ? _scheduledStart!.toString()
                  : 'Not scheduled'),
              trailing: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        _scheduledStart = DateTime(
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
            ),
            const SizedBox(height: 16),
            _buildCheckpointEditor(),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _createRun,
            child: const Text('Create Run'),
          ),
        ),
      ),
    );
  }
}
