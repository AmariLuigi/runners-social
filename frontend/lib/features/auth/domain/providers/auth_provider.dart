import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../entities/user.dart';

final authProvider = StateProvider<User?>((ref) => null);
