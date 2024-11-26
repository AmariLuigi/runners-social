import 'package:flutter/material.dart';
import '../../data/models/run_session.dart';
import '../screens/active_run_screen.dart';

class RunListItem extends StatelessWidget {
  final RunSession run;

  const RunListItem({
    super.key,
    required this.run,
  });

  void _onTap(BuildContext context) {
    if (run.id == null) return;
    
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ActiveRunScreen(runId: run.id!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: () => _onTap(context),
        leading: CircleAvatar(
          backgroundColor: run.type == 'group' ? Colors.blue : Colors.green,
          child: Icon(
            run.type == 'group' ? Icons.group : Icons.person,
            color: Colors.white,
          ),
        ),
        title: Text(run.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(run.description),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text('${run.participants.length}/${run.maxParticipants}'),
                const SizedBox(width: 16),
                Icon(
                  Icons.timer,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(run.scheduledStart != null
                    ? _formatDateTime(run.scheduledStart!)
                    : 'Starting soon'),
              ],
            ),
          ],
        ),
        trailing: run.type == 'group' && !run.isParticipant
            ? ElevatedButton(
                onPressed: () {
                  // TODO: Implement join run functionality
                },
                child: const Text('Join'),
              )
            : null,
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
