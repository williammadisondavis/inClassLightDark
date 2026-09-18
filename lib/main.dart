import 'package:flutter/material.dart';

void main() {
  runApp(const RunMyApp());
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  // Variable to manage the current theme mode
  ThemeMode _themeMode = ThemeMode.system;

  // helper getter to check if the current theme is dark
  bool get _isDark => _themeMode == ThemeMode.dark;

  // Updated changeTheme to take a boolean from the Switch widget
  void changeTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  // EXTRA CREDIT 3: Function to reset theme to system default
  void resetToSystemTheme() {
    setState(() {
      _themeMode = ThemeMode.system;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Status Card Demo',
      
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[200], // Light mode background
      ),
      darkTheme: ThemeData.dark(), // Dark mode configurator
      
      themeMode: _themeMode, // Connects the state to the app

      // Pass both the boolean dark state and the update callback down
      home: HomeScreen(
        isDarkTheme: _isDark, // Passing current dark mode status
        onThemeChanged: changeTheme,
        onResetTheme: resetToSystemTheme, // EXTRA CREDIT 3: Pass reset callback
      ),
    );
  }
}

// Extracted home screen so Theme.of(context) sits below MaterialApp
class HomeScreen extends StatelessWidget {
  final bool isDarkTheme; // Stores whether dark mode is active
  final Function(bool) onThemeChanged; // accepts a bool callback
  final VoidCallback onResetTheme; // EXTRA CREDIT 3: Callback for resetting theme

  const HomeScreen({
    super.key,
    required this.isDarkTheme, // added
    required this.onThemeChanged,
    required this.onResetTheme, // Extra credit 3
  });

  @override
  Widget build(BuildContext context) {
    // Now Theme.of(context) correctly reads from the active MaterialApp theme
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Status Card Demo'),
      ),
      body: Center(
        child: SingleChildScrollView( // Added scrollview to ensure extra credit features fit on all screens
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Part 1 : Avatar and Text
              CircleAvatar(
                radius: 45,
                backgroundColor: isDark ? Colors.teal : Colors.blueGrey,
                child: const Icon(Icons.person, size: 42, color: Colors.white),
              ),

              const SizedBox(height: 12),

              const Text(
                'Flutter Theme Lab',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 20),

              // Part 1: Status Badge Container
              // Task 1 and 3: Replaced Container with AnimatedContainer, added 400ms duration
              AnimatedContainer(
                duration: const Duration(milliseconds: 400), // Custom 400ms animation duration
                width: 240,
                height: 64,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // Use a ternary operator to check theme brightness
                  color: isDark ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Task 4: Displays open circle in light mode & filled check circle in dark mode
                    Icon(
                      isDark ? Icons.check_circle : Icons.circle_outlined,
                      size: 16,
                      color: Colors.black87,
                    ),
                    const SizedBox(width: 8),
                    // EXTRA CREDIT 1: AnimatedCrossFade for text transition on theme change
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 300),
                      crossFadeState: isDark 
                          ? CrossFadeState.showSecond 
                          : CrossFadeState.showFirst,
                      firstChild: const Text(
                        'Status: Online',
                        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      secondChild: const Text(
                        'Status: Dark Mode',
                        style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              const Text('Choose the Theme:', style: TextStyle(fontSize: 16)),
              
              const SizedBox(height: 10),

              // PART 1 TASK and TASK 2: Controls
              // CHANGED: Replaced the Row of ElevatedButtons with a switch control
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Dark Mode'),
                  const SizedBox(width: 8),
                  Switch(
                    value: isDarkTheme, // Controls which side the switch displays
                    onChanged: (bool value) {
                      onThemeChanged(value); // Triggers parent setState via callback
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(indent: 40, endIndent: 40),
              const SizedBox(height: 10),

              // EXTRA CREDIT 2: Added filter chip
              Wrap(
                spacing: 8.0,
                children: [
                  FilterChip(
                    label: const Text('Light Mode'),
                    selected: !isDarkTheme,
                    onSelected: (bool selected) {
                      if (selected) onThemeChanged(false);
                    },
                  ),
                  FilterChip(
                    label: const Text('Dark Mode'),
                    selected: isDarkTheme,
                    onSelected: (bool selected) {
                      if (selected) onThemeChanged(true);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 15),

              // EXTRA CREDIT 3: System theme reset button and app label at bottom
              OutlinedButton.icon(
                onPressed: onResetTheme,
                icon: const Icon(Icons.settings_backup_restore, size: 18),
                label: const Text('Reset to System Theme'),
              ),

              const SizedBox(height: 8),

              Text(
                'Extra Credit Demo',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}