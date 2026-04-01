// Home Screen which is kind of just a place holder for now
// Author: Luis Angel Beltran Sanchez
// Version: 1.0.0

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../features/auth/presentation/providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState is AuthAuthenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        actions: [
          if (user != null)
            TextButton(
              onPressed: () => ref.read(authProvider.notifier).logout(), 
              child: const Text('Logout'),
              ),
        ],
      ),
    body: Center(
      child: user != null
          ? Text('Welcome, ${user.name}')
          : const Text('Welcome to the store'),
    ),  
    );
  }
}