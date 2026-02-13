
import 'package:flutter/material.dart';

class CompatibilityCard extends StatelessWidget {
  final bool? isRooted;
  final bool? hasBusyBox;
  final bool? hasIproute2;

  const CompatibilityCard({
    super.key,
    required this.isRooted,
    required this.hasBusyBox,
    required this.hasIproute2,
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
            Text('COMPATIBILITY', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.secondary)),
            const SizedBox(height: 12),
            CompatibilityCheckRow(label: 'Root Access:', status: isRooted),
            const Divider(),
            CompatibilityCheckRow(label: 'BusyBox:', status: hasBusyBox),
            const Divider(),
            CompatibilityCheckRow(label: 'iproute2:', status: hasIproute2),
          ],
        ),
      ),
    );
  }
}

class CompatibilityCheckRow extends StatelessWidget {
  final String label;
  final bool? status;

  const CompatibilityCheckRow({super.key, required this.label, this.status});

  @override
  Widget build(BuildContext context) {
    Widget statusIcon;
    Color statusColor;
    String statusText;

    if (status == null) {
      statusIcon = const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2));
      statusColor = Colors.grey;
      statusText = 'Checking...';
    } else if (status == true) {
      statusIcon = const Icon(Icons.check_circle, color: Colors.green);
      statusColor = Colors.green;
      statusText = 'Detected';
    } else {
      statusIcon = const Icon(Icons.cancel, color: Colors.red);
      statusColor = Colors.red;
      statusText = 'Not Found';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          statusIcon,
          const SizedBox(width: 8),
          Text(statusText, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: statusColor, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
