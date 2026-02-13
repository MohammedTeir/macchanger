import 'package:flutter/material.dart';

class ActionsCard extends StatelessWidget {
  final VoidCallback onRandomMac;
  final VoidCallback onChangeMac;
  final VoidCallback onNavigateToProfiles;
  final VoidCallback onRestoreOriginal;

  const ActionsCard({
    super.key,
    required this.onRandomMac,
    required this.onChangeMac,
    required this.onNavigateToProfiles,
    required this.onRestoreOriginal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.shuffle),
          onPressed: onRandomMac,
          label: const Text('Random MAC'),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          icon: const Icon(Icons.edit),
          onPressed: onChangeMac,
          label: const Text('Change MAC'),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          icon: const Icon(Icons.list),
          onPressed: onNavigateToProfiles,
          label: const Text('Profiles'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          icon: const Icon(Icons.restore),
          onPressed: onRestoreOriginal,
          label: const Text('Restore Original'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
            side: BorderSide(color: Theme.of(context).colorScheme.secondary),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }
}
