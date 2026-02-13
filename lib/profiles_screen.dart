import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'profile.dart';

class ProfilesScreen extends StatefulWidget {
  final Function(String) onSelectProfile;

  const ProfilesScreen({super.key, required this.onSelectProfile});

  @override
  State<ProfilesScreen> createState() => _ProfilesScreenState();
}

class _ProfilesScreenState extends State<ProfilesScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<Profile> profiles = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _macController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  void _loadProfiles() async {
    final allRows = await dbHelper.getProfiles();
    setState(() {
      profiles = allRows;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
      ),
      body: ListView.builder(
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return ListTile(
            title: Text(profile.name),
            subtitle: Text(profile.macAddress),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _showProfileDialog(profile: profile),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteProfile(profile.id!),
                ),
              ],
            ),
            onTap: () {
              widget.onSelectProfile(profile.macAddress);
              Navigator.pop(context);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProfileDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showProfileDialog({Profile? profile}) {
    _nameController.text = profile?.name ?? '';
    _macController.text = profile?.macAddress ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(profile == null ? 'New Profile' : 'Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Profile Name'),
              ),
              TextField(
                controller: _macController,
                decoration: const InputDecoration(labelText: 'MAC Address'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (profile == null) {
                  _addProfile();
                } else {
                  _updateProfile(profile);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _addProfile() async {
    final name = _nameController.text;
    final mac = _macController.text;
    if (name.isNotEmpty && mac.isNotEmpty) {
      await dbHelper.insert(Profile(name: name, macAddress: mac));
      _loadProfiles();
    }
  }

  void _updateProfile(Profile profile) async {
    final name = _nameController.text;
    final mac = _macController.text;
    if (name.isNotEmpty && mac.isNotEmpty) {
      profile.name = name;
      profile.macAddress = mac;
      await dbHelper.update(profile);
      _loadProfiles();
    }
  }

  void _deleteProfile(int id) async {
    await dbHelper.delete(id);
    _loadProfiles();
  }
}
