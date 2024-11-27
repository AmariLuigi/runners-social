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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 24),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
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
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.network(
                    'https://assets2.lottiefiles.com/packages/lf20_s2lryxtd.json',
                    repeat: false,
                    animate: true,
                    frameRate: FrameRate(60),
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 24),
                _buildStatRow(
                  Icons.directions_run,
                  'Distance',
                  '${(distance / 1000).toStringAsFixed(2)} km',
                ),
                _buildStatRow(
                  Icons.timer,
                  'Duration',
                  _formatDuration(duration),
                ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
