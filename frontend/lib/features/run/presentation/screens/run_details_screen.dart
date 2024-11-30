import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/run.dart';
import '../../providers/run_provider.dart';
import '../widgets/route_map.dart';

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
  bool _isDescriptionExpanded = true;  // Start expanded by default
  bool _isParticipantsExpanded = true;  // Add state for participants section

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with actual user ID from auth provider
    const currentUserId = '674599ee41268c5e7d97fa01';
    
    // Debug logging
    print('Run Details - Current User ID: $currentUserId');
    print('Run Details - Run ID: ${widget.run.id}');
    print('Run Details - Participants: ${widget.run.participants.map((p) => '\n  - ${p.id} (${p.role})')}');
    
    final isOwner = widget.run.participants.any((p) {
      final matches = p.id == currentUserId && p.role == 'host';
      print('Run Details - Checking participant ${p.id} (${p.role}) against current user: matches=$matches');
      return matches;
    });
    
    final isParticipant = widget.run.participants.any((p) {
      final matches = p.id == currentUserId;
      print('Run Details - Is participant check: ${p.id} matches=$matches');
      return matches;
    });
    
    print('Run Details - Final checks: isOwner=$isOwner, isParticipant=$isParticipant');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.run.name),
        actions: [
          if (isParticipant || isOwner)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) async {
                if (value == 'leave') {
                  try {
                    await ref.read(runProvider.notifier).leaveRun(widget.run.id);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Successfully left run')),
                      );
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to leave run: $e')),
                      );
                    }
                  }
                } else if (value == 'delete') {
                  final shouldDelete = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Run'),
                      content: const Text('Are you sure you want to delete this run? This action cannot be undone.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('DELETE', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );

                  if (shouldDelete == true && mounted) {
                    try {
                      await ref.read(runProvider.notifier).deleteRun(widget.run.id);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Successfully deleted run')),
                        );
                        Navigator.of(context).pop();
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to delete run: $e')),
                        );
                      }
                    }
                  }
                }
              },
              itemBuilder: (context) => [
                if (!isOwner && isParticipant)
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
                if (isOwner)
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
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Run Details',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MMM d, y • h:mm a').format(widget.run.startTime),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Route',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      // Debug logging for route points
                      print('\nRun Details - Route Points Debug:');
                      print('Run ID: ${widget.run.id}');
                      print('Has routePoints: ${widget.run.routePoints != null}');
                      print('RoutePoints length: ${widget.run.routePoints?.length ?? 0}');
                      if (widget.run.routePoints != null) {
                        print('Route Points:');
                        for (var point in widget.run.routePoints!) {
                          print('  - Point ${point.order}: (${point.latitude}, ${point.longitude})');
                        }
                      }
                      
                      if (widget.run.routePoints != null && widget.run.routePoints!.isNotEmpty)
                        return Container(
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: RouteMap(
                              routePoints: widget.run.routePoints!,
                              isEditable: false,
                            ),
                          ),
                        );
                      else
                        return const Text('No planned route');
                    }
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isDescriptionExpanded = !_isDescriptionExpanded;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Description',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                _isDescriptionExpanded 
                                  ? Icons.keyboard_arrow_up 
                                  : Icons.keyboard_arrow_down,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                          if (_isDescriptionExpanded) ...[
                            const SizedBox(height: 8),
                            Text(
                              widget.run.description,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isParticipantsExpanded = !_isParticipantsExpanded;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Participants',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  _isParticipantsExpanded 
                                    ? Icons.keyboard_arrow_up 
                                    : Icons.keyboard_arrow_down,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                          if (_isParticipantsExpanded)
                            ...widget.run.participants.map((participant) => ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                child: Icon(
                                  Icons.person,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              title: Text(
                                participant.username,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                participant.role,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            )).toList(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
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
      case RunStatus.completed:
        return Colors.purple;
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
      case RunStatus.completed:
        return 'Completed';
      case RunStatus.cancelled:
        return 'Cancelled';
    }
  }
}
