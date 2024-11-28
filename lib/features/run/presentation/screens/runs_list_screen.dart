import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../application/run_notifier.dart';
import '../../domain/entities/run.dart';
import '../widgets/run_card.dart';
import '../widgets/create_run_modal.dart';

class RunsListScreen extends ConsumerStatefulWidget {
  const RunsListScreen({super.key});

  @override
  ConsumerState<RunsListScreen> createState() => _RunsListScreenState();
}

class _RunsListScreenState extends ConsumerState<RunsListScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showCreateRunModal() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CreateRunModal(),
    );
  }

  List<Run> _filterRuns(List<Run> runs) {
    return runs
      ..sort((a, b) {
        if (a.status != b.status) {
          return a.status.index.compareTo(b.status.index);
        }
        return a.startTime.compareTo(b.startTime);
      });
  }

  Future<void> _handleRunTap(Run run) async {
    // TODO: Implement run details screen
    print('Run tapped: ${run.id}');
  }

  Future<void> _handleJoinRun(Run run) async {
    try {
      await ref.read(runProvider.notifier).joinRun(run.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully joined run'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error joining run ${run.id}: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to join run: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleDeleteRun(Run run) async {
    try {
      await ref.read(runProvider.notifier).deleteRun(run.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Run deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error deleting run ${run.id}: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete run: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildRunsList(
    BuildContext context,
    List<Run> runs, {
    required String emptyMessage,
    required bool showJoinButton,
  }) {
    final filteredRuns = _filterRuns(runs);

    if (filteredRuns.isEmpty) {
      return Center(
        child: Text(
          emptyMessage,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredRuns.length,
      itemBuilder: (context, index) {
        final run = filteredRuns[index];
        return RunCard(
          run: run,
          onTap: () => _handleRunTap(run),
          onJoin: showJoinButton ? () => _handleJoinRun(run) : null,
          onDelete: run.isParticipant ? () => _handleDeleteRun(run) : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final runs = ref.watch(runProvider);

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
      body: TabBarView(
        controller: _tabController,
        children: [
          // My Runs Tab
          _buildRunsList(
            context,
            runs.where((run) => run.isParticipant).toList(),
            emptyMessage: 'No runs found. Create one to get started!',
            showJoinButton: false,
          ),
          // Public Runs Tab
          _buildRunsList(
            context,
            runs.where((run) => (run.isPublic ?? false) && !run.isParticipant).toList(),
            emptyMessage: 'No public runs available.',
            showJoinButton: true,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateRunModal,
        child: const Icon(Icons.add),
      ),
    );
  }
}
