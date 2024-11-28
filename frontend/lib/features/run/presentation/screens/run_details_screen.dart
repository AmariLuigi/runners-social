import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/run.dart';
import '../../providers/run_provider.dart';

class RunDetailsScreen extends ConsumerStatefulWidget {
  final Run run;

  const RunDetailsScreen({
    Key? key,
    required this.run,
  }) : super(key: key);

  @override
  ConsumerState<RunDetailsScreen> createState() => _RunDetailsScreenState();
}

class _RunDetailsScreenState extends ConsumerState<RunDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.run.name),
        actions: [
          if (widget.run.isParticipant)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'leave') {
                  await ref.read(runProvider.notifier).leaveRun(widget.run.id);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                } else if (value == 'delete') {
                  // Show confirmation dialog
                  if (context.mounted) {
                    final shouldDelete = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Run'),
                        content: const Text('Are you sure you want to delete this run? This action cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );

                    if (shouldDelete == true && context.mounted) {
                      await ref.read(runProvider.notifier).deleteRun(widget.run.id);
                      Navigator.of(context).pop();
                    }
                  }
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'leave',
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Leave Run'),
                    ],
                  ),
                ),
                // Only show delete option for the run creator
                if (widget.run.participants.any((p) => p.role == 'host' && p.id == widget.run.participants.first.id))
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Run', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          widget.run.type == RunType.solo ? Icons.person : Icons.group,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.run.type == RunType.solo ? 'Solo Run' : 'Group Run',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (widget.run.type == RunType.group) ...[
                          const Spacer(),
                          Text(
                            '${(widget.run.participants.length)}/${widget.run.maxParticipants ?? "∞"}',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('MMM d, y • h:mm a').format(widget.run.startTime),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    if (widget.run.description != null) ...[
                      const Divider(),
                      Text(
                        widget.run.description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    const Divider(),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(widget.run.status),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            _getStatusText(widget.run.status),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    // Participants section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Participants',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ...widget.run.participants.map((participant) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              const Icon(Icons.person_outline, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                participant.username,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 8),
                              if (participant.role == 'host')
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Host',
                                    style: TextStyle(
                                      color: Colors.blue[700],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )).toList(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (!widget.run.isParticipant &&
                widget.run.status == RunStatus.planned)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 45),
                  ),
                  onPressed: () async {
                    await ref.read(runProvider.notifier).joinRun(widget.run.id);
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Join Run'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(RunStatus status) {
    switch (status) {
      case RunStatus.planned:
        return Colors.blue;
      case RunStatus.active:
        return Colors.green;
      case RunStatus.paused:
        return Colors.orange;
      case RunStatus.completed:
        return Colors.grey;
      case RunStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(RunStatus status) {
    switch (status) {
      case RunStatus.planned:
        return 'Planned';
      case RunStatus.active:
        return 'Active';
      case RunStatus.paused:
        return 'Paused';
      case RunStatus.completed:
        return 'Completed';
      case RunStatus.cancelled:
        return 'Cancelled';
    }
  }
}
