import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/run.dart';
import '../../providers/run_provider.dart';
import '../screens/run_details_screen.dart';
import '../widgets/create_run_modal.dart';

class RunsListScreen extends ConsumerStatefulWidget {
  const RunsListScreen({Key? key}) : super(key: key);

  @override
  _RunsListScreenState createState() => _RunsListScreenState();
}

class _RunsListScreenState extends ConsumerState<RunsListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(runProvider.notifier).loadRuns();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Runs'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My Runs'),
            Tab(text: 'Public Runs'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => const CreateRunModal(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildRunsList(true),
          _buildRunsList(false),
        ],
      ),
    );
  }

  Widget _buildRunsList(bool myRuns) {
    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(runProvider.notifier).loadRuns();
      },
      child: Consumer(
        builder: (context, ref, child) {
          final runs = ref.watch(runProvider);
          final filteredRuns = myRuns
              ? runs.where((run) => run.isParticipant).toList()
              : runs.where((run) => run.privacy == 'public' && !run.isParticipant).toList();

          if (filteredRuns.isEmpty) {
            return Center(
              child: Text(myRuns ? 'No runs joined yet' : 'No public runs available'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: filteredRuns.length,
            itemBuilder: (context, index) {
              final run = filteredRuns[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RunDetailsScreen(run: run),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(run.status).withOpacity(0.2),
                    child: Icon(
                      run.type == RunType.solo ? Icons.person : Icons.group,
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
                      if (run.description != null)
                        Text(
                          run.description!,
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getStatusColor(run.status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getStatusText(run.status),
                              style: TextStyle(
                                color: _getStatusColor(run.status),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          if (run.type == RunType.group) ...[
                            const SizedBox(width: 8),
                            Text(
                              '${run.participants.length}/${run.maxParticipants ?? "∞"}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
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
}
