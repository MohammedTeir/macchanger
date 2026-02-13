import 'package:flutter/material.dart';

class AdvancedCard extends StatelessWidget {
  final bool autoRandomize;
  final ValueChanged<bool> onToggleAutoRandomization;

  const AdvancedCard({
    super.key,
    required this.autoRandomize,
    required this.onToggleAutoRandomization,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ADVANCED', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.secondary)),
            const SizedBox(height: 12),
            SwitchListTile(
              title: Text('Auto Randomize MAC', style: Theme.of(context).textTheme.bodyMedium),
              subtitle: Text('Randomize MAC on network change', style: Theme.of(context).textTheme.bodySmall),
              value: autoRandomize,
              onChanged: onToggleAutoRandomization,
              secondary: const Icon(Icons.wifi_tethering),
            ),
          ],
        ),
      ),
    );
  }
}