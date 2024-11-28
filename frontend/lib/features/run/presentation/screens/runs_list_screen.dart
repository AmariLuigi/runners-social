import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:runners_social/features/run/domain/entities/run.dart';
import 'package:runners_social/features/run/presentation/screens/run_details_screen.dart';
import 'package:runners_social/features/run/presentation/widgets/create_group_run_dialog.dart';
import 'package:runners_social/features/run/presentation/widgets/run_list_item.dart';
import 'package:runners_social/features/run/providers/run_provider.dart';

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
            builder: (context) => const CreateGroupRunDialog(),
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
          return runs.when(
            data: (runsList) {
              final displayedRuns = myRuns
                ? runsList.where((run) => run.participants.any((p) => p.role == 'host')).toList()
                : runsList.where((run) => 
                    run.privacy == 'public' && 
                    !run.participants.any((p) => p.role == 'host')
                  ).toList();

              if (displayedRuns.isEmpty) {
                return Center(
                  child: Text(myRuns ? 'No runs created yet' : 'No public runs available'),
                );
              }

              return _buildRunList(displayedRuns, ref.read(runProvider.notifier));
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('Error loading runs: $error'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRunList(List<Run> runs, RunNotifier runProvider) {
    return ListView.builder(
      itemCount: runs.length,
      itemBuilder: (context, index) {
        final run = runs[index];
        final isOwner = run.participants.any((p) => p.id == 'currentUserId' && p.role == 'owner');
        
        return RunListItem(
          run: run,
          onTap: () => _navigateToRunDetails(run),
          showJoinButton: !run.participants.any((p) => p.id == 'currentUserId'),
          isOwner: isOwner,
          onJoin: () async {
            try {
              await runProvider.joinRun(run.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successfully joined run')),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to join run: $e')),
                );
              }
            }
          },
          onLeave: () async {
            try {
              await runProvider.leaveRun(run.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Successfully left run')),
                );
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to leave run: $e')),
                );
              }
            }
          },
          onDelete: () async {
            // Show confirmation dialog
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

            if (shouldDelete == true) {
              try {
                await runProvider.deleteRun(run.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Successfully deleted run')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete run: $e')),
                  );
                }
              }
            }
          },
        );
      },
    );
  }

  void _navigateToRunDetails(Run run) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RunDetailsScreen(run: run),
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
