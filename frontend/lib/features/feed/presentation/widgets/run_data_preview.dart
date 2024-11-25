import 'package:flutter/material.dart';
import '../../domain/models/post.dart';

class RunDataPreview extends StatelessWidget {
  final RunData runData;

  const RunDataPreview({
    super.key,
    required this.runData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                context,
                'Distance',
                '${(runData.distance / 1000).toStringAsFixed(2)} km',
                Icons.straighten,
              ),
              _buildStatItem(
                context,
                'Duration',
                _formatDuration(runData.duration),
                Icons.timer,
              ),
              _buildStatItem(
                context,
                'Pace',
                _calculatePace(runData.distance, runData.duration),
                Icons.speed,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (runData.route.isNotEmpty)
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _buildRoutePreview(runData.route),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildRoutePreview(List<LatLng> route) {
    // TODO: Implement route preview using Google Maps or similar
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Text('Route Preview'),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  String _calculatePace(double distanceInMeters, Duration duration) {
    if (distanceInMeters == 0) return '--:--';

    final totalMinutes = duration.inMinutes;
    final paceMinutes = totalMinutes / (distanceInMeters / 1000);
    final paceMinutesInt = paceMinutes.floor();
    final paceSeconds = ((paceMinutes - paceMinutesInt) * 60).round();

    return '$paceMinutesInt:${paceSeconds.toString().padLeft(2, '0')}/km';
  }
}
