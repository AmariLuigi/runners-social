import 'package:flutter/material.dart';
import '../../domain/entities/run.dart';
import 'package:intl/intl.dart';

class RunCard extends StatelessWidget {
  final Run run;
  final VoidCallback? onTap;
  final VoidCallback? onJoin;
  final VoidCallback? onDelete;

  const RunCard({
    super.key,
    required this.run,
    this.onTap,
    this.onJoin,
    this.onDelete,
  });

  Color _getStatusColor() {
    switch (run.status) {
      case RunStatus.upcoming:
        return Colors.blue;
      case RunStatus.ongoing:
        return Colors.green;
      case RunStatus.completed:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon() {
    return run.type == RunType.solo ? Icons.person : Icons.group;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_getTypeIcon()),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      run.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      run.status.toString().split('.').last,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM d, y HH:mm').format(run.startTime),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              if (run.locationName != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      run.locationName!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
              if (run.distanceGoal != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.straighten, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${run.distanceGoal} km',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
              if (onJoin != null || onDelete != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (onJoin != null)
                      TextButton.icon(
                        onPressed: onJoin,
                        icon: const Icon(Icons.add),
                        label: const Text('Join'),
                      ),
                    if (onDelete != null)
                      TextButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
