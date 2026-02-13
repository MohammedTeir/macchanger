import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../network_info_provider.dart' as network_info;

class StatusCard extends StatelessWidget {
  final String? currentMac;
  final network_info.NetworkInfoData? selectedInterface;

  const StatusCard({
    super.key,
    required this.currentMac,
    required this.selectedInterface,
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
            Text('STATUS', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.secondary)),
            const SizedBox(height: 12),
            InfoRow(label: 'Current MAC:', value: currentMac ?? 'N/A'),
            const Divider(height: 20),
            InfoRow(label: 'Interface:', value: selectedInterface?.name ?? 'wlan0'),
            const Divider(height: 20),
            InfoRow(label: 'IP Address:', value: selectedInterface?.ipAddress ?? 'N/A'),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(value, style: GoogleFonts.inconsolata(fontSize: 16, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
      ],
    );
  }
}