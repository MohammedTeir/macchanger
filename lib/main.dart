import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:io';
import 'dart:math';
import 'root_checker.dart';
import 'network_info_provider.dart' as network_info;
import 'mac_changer.dart';
import 'profiles_screen.dart';
import 'network_watcher.dart';
import 'widgets/compatibility_card.dart';
import 'widgets/status_card.dart';
import 'widgets/advanced_card.dart';
import 'widgets/actions_card.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const RootMacApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class RootMacApp extends StatelessWidget {
  const RootMacApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primarySeedColor = Colors.blueGrey;

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.orbitron(fontSize: 57, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.orbitron(fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.inconsolata(fontSize: 16),
      labelLarge: GoogleFonts.orbitron(fontSize: 16, fontWeight: FontWeight.bold),
    );

    final ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.light,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primarySeedColor,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.orbitron(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primarySeedColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.orbitron(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primarySeedColor,
        brightness: Brightness.dark,
        surface: Colors.black,
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.cyanAccent,
        titleTextStyle: GoogleFonts.orbitron(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.cyanAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.orbitron(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'RootMAC',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeProvider.themeMode,
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RootChecker _rootChecker = RootChecker();
  final network_info.NetworkInfoProvider _networkInfoProvider = network_info.NetworkInfoProvider();
  final MacChanger _macChanger = MacChanger();
  NetworkWatcher? _networkWatcher;

  bool? _isRooted;
  bool? _hasBusyBox;
  bool? _hasIproute2;
  bool _isLoading = true;
  bool _autoRandomize = false;

  String? _currentMac;
  String? _originalMac;
  network_info.NetworkInfoData? _selectedInterface;

  final TextEditingController _macController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _runInitialChecks();
  }

  @override
  void dispose() {
    _networkWatcher?.dispose();
    super.dispose();
  }

  Future<void> _runInitialChecks() async {
    await _runCompatibilityChecks();
    await _fetchNetworkInfo();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _runCompatibilityChecks() async {
    if (Platform.isAndroid) {
      final isRooted = await _rootChecker.isDeviceRooted();
      final hasBusyBox = await _rootChecker.isBusyBoxInstalled();
      final hasIproute2 = await _rootChecker.isIproute2Installed();
      setState(() {
        _isRooted = isRooted;
        _hasBusyBox = hasBusyBox;
        _hasIproute2 = hasIproute2;
      });
    } else {
      setState(() {
        _isRooted = false;
        _hasBusyBox = false;
        _hasIproute2 = false;
      });
    }
  }

  Future<void> _fetchNetworkInfo() async {
    final interfaces = await _networkInfoProvider.getNetworkInterfaces();
    if (interfaces.isNotEmpty) {
      _selectedInterface = interfaces.first;
    }

    if (Platform.isAndroid && _isRooted == true) {
      final mac = await _macChanger.getMacAddress('wlan0');
      setState(() {
        _currentMac = mac;
        _originalMac ??= mac;
      });
    }

    setState(() {});
  }

  String _generateRandomMac() {
    final random = Random();
    final parts = List<String>.generate(6, (index) {
      return random.nextInt(256).toRadixString(16).padLeft(2, '0');
    });
    // Ensure it's a locally administered, unicast address
    parts[0] = (int.parse(parts[0], radix: 16) & 0xFE | 0x02).toRadixString(16).padLeft(2, '0');
    return parts.join(':');
  }

  Future<void> _changeMac(String newMac) async {
    if (_isRooted != true) {
      _showSnackbar('Root access is required to change MAC address.', isError: true);
      return;
    }

    final bool success = await _macChanger.changeMacAddress('wlan0', newMac);

    if (success) {
      _showSnackbar('MAC address changed successfully!');
      await _fetchNetworkInfo();
    } else {
      _showSnackbar('Failed to change MAC address.', isError: true);
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  void _showChangeMacDialog() {
    _macController.text = _currentMac ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change MAC Address'),
          content: TextField(
            controller: _macController,
            decoration: const InputDecoration(labelText: 'New MAC Address'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _changeMac(_macController.text);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToProfilesScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfilesScreen(
          onSelectProfile: (String mac) {
            _changeMac(mac);
          },
        ),
      ),
    );
  }

  void _toggleAutoRandomization(bool value) {
    setState(() {
      _autoRandomize = value;
    });

    if (_autoRandomize) {
      _networkWatcher = NetworkWatcher(
        onNetworkChange: (List<ConnectivityResult> result) {
          if (result.first != ConnectivityResult.none) {
            _showSnackbar('Network change detected! Randomizing MAC...');
            final randomMac = _generateRandomMac();
            _changeMac(randomMac);
          }
        },
      );
      _showSnackbar('Automatic MAC randomization enabled.');
    } else {
      _networkWatcher?.dispose();
      _networkWatcher = null;
      _showSnackbar('Automatic MAC randomization disabled.', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('RootMAC'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchNetworkInfo,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  CompatibilityCard(
                    isRooted: _isRooted,
                    hasBusyBox: _hasBusyBox,
                    hasIproute2: _hasIproute2,
                  ),
                  const SizedBox(height: 16),
                  StatusCard(
                    currentMac: _currentMac,
                    selectedInterface: _selectedInterface,
                  ),
                  const SizedBox(height: 16),
                  AdvancedCard(
                    autoRandomize: _autoRandomize,
                    onToggleAutoRandomization: _toggleAutoRandomization,
                  ),
                  const SizedBox(height: 32),
                  ActionsCard(
                    onRandomMac: () {
                      final randomMac = _generateRandomMac();
                      _macController.text = randomMac;
                      _changeMac(randomMac);
                    },
                    onChangeMac: _showChangeMacDialog,
                    onNavigateToProfiles: _navigateToProfilesScreen,
                    onRestoreOriginal: () {
                      if (_originalMac != null) {
                        _changeMac(_originalMac!);
                      } else {
                        _showSnackbar('Original MAC not saved.', isError: true);
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
