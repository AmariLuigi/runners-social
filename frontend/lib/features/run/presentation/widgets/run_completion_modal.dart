import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
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
            Lottie.network(
              'https://assets9.lottiefiles.com/packages/lf20_rc5d0f61.json',
              height: 150,
              repeat: true,
            ),
            const SizedBox(height: 24),
            _buildStatRow(
              Icons.directions_run,
              'Distance',
              '${(distance / 1000).toStringAsFixed(2)} km',
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              Icons.timer,
              'Duration',
              _formatDuration(duration),
            ),
            const SizedBox(height: 16),
            _buildStatRow(
              Icons.speed,
              'Average Pace',
              '${averagePace.toStringAsFixed(2)} min/km',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.router.pop(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
