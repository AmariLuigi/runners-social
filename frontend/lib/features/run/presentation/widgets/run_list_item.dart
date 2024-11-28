import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/run.dart';

class RunListItem extends ConsumerWidget {
  final Run run;
  final VoidCallback onTap;
  final VoidCallback? onJoin;
  final VoidCallback? onLeave;
  final VoidCallback? onDelete;
  final bool showJoinButton;
  final bool isOwner;

  const RunListItem({
    Key? key,
    required this.run,
    required this.onTap,
    this.onJoin,
    this.onLeave,
    this.onDelete,
    this.showJoinButton = false,
    this.isOwner = false,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual user ID from auth provider
    const currentUserId = '674599ee41268c5e7d97fa01';
    
    // Debug logging
    print('\nRun List Item - ${run.name}:');
    print('Current User ID: $currentUserId');
    print('Run ID: ${run.id}');
    print('Participants: ${run.participants.map((p) => '\n  - ${p.id} (${p.role})')}');
    
    final isCurrentUserOwner = run.participants.any((p) {
      final matches = p.id == currentUserId && p.role == 'host';
      print('Checking participant ${p.id} (${p.role}) against current user: matches=$matches');
      return matches;
    });
    
    final isCurrentUserParticipant = run.participants.any((p) {
      final matches = p.id == currentUserId;
      print('Is participant check: ${p.id} matches=$matches');
      return matches;
    });
    
    print('Final checks: isCurrentUserOwner=$isCurrentUserOwner, isCurrentUserParticipant=$isCurrentUserParticipant');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(run.status).withOpacity(0.2),
          child: Icon(
            run.type == 'solo' ? Icons.person : Icons.group,
            color: _getStatusColor(run.status),
          ),
        ),
        title: Text(
          run.name,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('MMM d, y • h:mm a').format(run.startTime),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              run.description,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getStatusColor(run.status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    run.status.toUpperCase(),
                    style: TextStyle(
                      color: _getStatusColor(run.status),
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if (run.type == 'group') ...[
                  Icon(
                    Icons.group,
                    size: 16,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${run.participants.length}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                if (run.meetingPoint != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      run.meetingPoint!,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: showJoinButton && !isCurrentUserParticipant
            ? IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: onJoin,
                tooltip: 'Join Run',
              )
            : (isCurrentUserOwner || isCurrentUserParticipant)
                ? PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'leave') {
                        onLeave?.call();
                      } else if (value == 'delete') {
                        onDelete?.call();
                      }
                    },
                    itemBuilder: (context) => [
                      if (!isCurrentUserOwner && isCurrentUserParticipant)
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
                      if (isCurrentUserOwner)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete Run', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                    ],
                  )
                : null,
      ),
    );
  }
}
