import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';

class RunCompletionModal extends StatelessWidget {
  final double distance;
  final Duration duration;
  final double averagePace;

  const RunCompletionModal({
    Key? key,
    required this.distance,
    required this.duration,
    required this.averagePace,
  }) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  String _formatPace(double pace) {
    if (pace.isInfinite || pace.isNaN) return '0:00';
    final minutes = pace.floor();
    final seconds = ((pace - minutes) * 60).floor();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Run Completed!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildStatRow('Distance', '${(distance / 1000).toStringAsFixed(2)} km'),
            _buildStatRow('Duration', _formatDuration(duration)),
            _buildStatRow('Average Pace', '${_formatPace(averagePace)}/km'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.router.pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
