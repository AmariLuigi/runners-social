import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/run_session.dart';

final runsProvider = StateProvider<List<RunSession>>((ref) => []);

class RunPage extends ConsumerWidget {
  const RunPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runs = ref.watch(runsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Runs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to run creation screen
            },
          ),
        ],
      ),
      body: runs.isEmpty
          ? const Center(
              child: Text('No runs available'),
            )
          : ListView.builder(
              itemCount: runs.length,
              itemBuilder: (context, index) {
                final run = runs[index];
                return ListTile(
                  title: Text(run.title),
                  subtitle: Text(run.description),
                  trailing: Text(run.status),
                  onTap: () {
                    // TODO: Navigate to run details screen
                  },
                );
              },
            ),
    );
  }
}
