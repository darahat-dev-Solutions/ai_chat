import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_starter_kit/features/home/application/home_controller.dart';
import 'package:flutter_starter_kit/features/home/application/home_state.dart';

/// Provide HomeController Functions and HomeState's state
final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>(
  (ref) {
    return HomeController();
  },
);
