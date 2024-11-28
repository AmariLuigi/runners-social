import 'package:flutter/material.dart';
import '../../data/models/run_data.dart';

class CreatePostResult {
  final String content;
  final List<String> images;
  final RunData? runData;

  CreatePostResult({
    required this.content,
    this.images = const [],
    this.runData,
  });
}

class CreatePostDialog extends StatefulWidget {
  const CreatePostDialog({super.key});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final _contentController = TextEditingController();
  final _images = <String>[];
  RunData? _runData;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'currentUserProfileImage', // TODO: Get from auth
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Create Post',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'What\'s on your mind?',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton.filledTonal(
                  icon: const Icon(Icons.image),
                  onPressed: _addImage,
                ),
                IconButton.filledTonal(
                  icon: const Icon(Icons.directions_run),
                  onPressed: _addRunData,
                ),
              ],
            ),
            if (_images.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _images.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          Image.network(
                            _images[index],
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: IconButton.filled(
                              icon: const Icon(Icons.close, size: 16),
                              onPressed: () => _removeImage(index),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black54,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
            if (_runData != null) ...[
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.directions_run),
                  title: Text(
                    '${(_runData!.distance / 1000).toStringAsFixed(2)} km',
                  ),
                  subtitle: Text(
                    _formatDuration(_runData!.duration),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: _removeRunData,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _contentController.text.isNotEmpty
                  ? () => _submitPost(context)
                  : null,
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addImage() async {
    // TODO: Implement image picker
    setState(() {
      _images.add('https://picsum.photos/200'); // Placeholder
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _addRunData() async {
    // TODO: Implement run data picker
    final now = DateTime.now();
    final duration = const Duration(minutes: 25);
    final distance = 5.0; // 5 km
    final averagePace = duration.inSeconds / distance / 60; // minutes per km
    
    setState(() {
      _runData = RunData(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Temporary ID
        distance: distance,
        duration: duration,
        averagePace: averagePace,
        route: const [],
        startTime: now.subtract(duration),
        endTime: now,
        caloriesBurned: distance * 60, // Rough estimate: 60 calories per km
        elevationGain: 0,
      );
    });
  }

  void _removeRunData() {
    setState(() {
      _runData = null;
    });
  }

  void _submitPost(BuildContext context) {
    Navigator.of(context).pop(
      CreatePostResult(
        content: _contentController.text,
        images: _images,
        runData: _runData,
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
}
