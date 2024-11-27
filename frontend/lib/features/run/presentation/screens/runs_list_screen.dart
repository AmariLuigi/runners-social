import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../widgets/run_card.dart';
import '../widgets/create_run_modal.dart';
import '../../domain/entities/run.dart';
import '../../application/run_notifier.dart';

class RunsListScreen extends ConsumerStatefulWidget {
  const RunsListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<RunsListScreen> createState() => _RunsListScreenState();
}

class _RunsListScreenState extends ConsumerState<RunsListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  RunType? _selectedType;
  RunStatus? _selectedStatus;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateRunModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateRunModal(),
    );
  }

  List<Run> _filterRuns(List<Run> runs) {
    return runs.where((run) {
      // Apply search filter
      final nameMatches = run.name.toLowerCase().contains(_searchQuery.toLowerCase());
      
      // Apply type filter
      final typeMatches = _selectedType == null || run.type == _selectedType;
      
      // Apply status filter
      final statusMatches = _selectedStatus == null || run.status == _selectedStatus;
      
      return nameMatches && typeMatches && statusMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final runs = ref.watch(runProvider);
    final filteredRuns = _filterRuns(runs);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Runs'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search runs...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).cardColor,
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: _selectedType == null && _selectedStatus == null,
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _selectedType = null;
                        _selectedStatus = null;
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Solo'),
                  selected: _selectedType == RunType.solo,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedType = selected ? RunType.solo : null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Group'),
                  selected: _selectedType == RunType.group,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedType = selected ? RunType.group : null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Upcoming'),
                  selected: _selectedStatus == RunStatus.upcoming,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedStatus = selected ? RunStatus.upcoming : null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('Completed'),
                  selected: _selectedStatus == RunStatus.completed,
                  onSelected: (bool selected) {
                    setState(() {
                      _selectedStatus = selected ? RunStatus.completed : null;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Runs List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // TODO: Implement refresh logic when backend is connected
              },
              child: filteredRuns.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.directions_run,
                            size: 64,
                            color: Theme.of(context).disabledColor,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No runs found',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create a new run to get started',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).disabledColor,
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredRuns.length,
                      itemBuilder: (context, index) {
                        final run = filteredRuns[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: RunCard(
                            runName: run.name,
                            runType: run.type,
                            status: run.status,
                            startTime: DateFormat('MMM d, yyyy h:mm a').format(run.startTime),
                            location: run.locationName ?? 'Location not set',
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateRunModal,
        icon: const Icon(Icons.add),
        label: const Text('New Run'),
      ),
    );
  }
}
