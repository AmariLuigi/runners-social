import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/run_session.dart';
import '../screens/run_create_screen.dart';
import '../providers/run_provider.dart';
import '../widgets/run_list_item.dart';

class RunPage extends ConsumerWidget {
  const RunPage({super.key});

  Widget _buildRunsList(BuildContext context, List<RunSession> runs) {
    if (runs.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_run,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No runs available',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: runs.length,
      itemBuilder: (context, index) => RunListItem(run: runs[index]),
    );
  }

  Widget _buildErrorView(BuildContext context, Object error, WidgetRef ref,
      FutureProvider<List<RunSession>> provider) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            size: 48,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading runs',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () => ref.refresh(provider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRuns = ref.watch(runsProvider);
    final myRuns = ref.watch(myRunsProvider);
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Runs'),
          bottom: TabBar(
            tabs: const [
              Tab(text: 'Active Runs'),
              Tab(text: 'My Runs'),
            ],
            indicatorColor: theme.colorScheme.primary,
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        body: TabBarView(
          children: [
            // Active Runs Tab
            activeRuns.when(
              data: (runsList) => _buildRunsList(
                context,
                runsList.where((run) => 
                  run.status == 'planned' || run.status == 'active'
                ).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorView(context, error, ref, runsProvider),
            ),
            // My Runs Tab
            myRuns.when(
              data: (runsList) => _buildRunsList(context, runsList),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildErrorView(context, error, ref, myRunsProvider),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (context) => const RunCreateScreen(),
            );
            
            if (result == true) {
              // Refresh both providers when a new run is created
              ref.refresh(runsProvider);
              ref.refresh(myRunsProvider);
            }
          },
          icon: const Icon(Icons.add_location),
          label: const Text('Create Run'),
        ),
      ),
    );
  }
}
