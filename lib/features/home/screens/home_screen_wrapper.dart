import 'package:flutter/material.dart';
import '../../../services/first_login_service.dart';
import '../../checker/screens/checker_screen.dart';
import 'home_screen.dart';

/// Wrapper for HomeScreen that handles first login system check
class HomeScreenWrapper extends StatefulWidget {
  const HomeScreenWrapper({super.key});

  @override
  State<HomeScreenWrapper> createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreenWrapper> {
  late Future<bool> _firstLoginFuture;

  @override
  void initState() {
    super.initState();
    _firstLoginFuture = FirstLoginService.isFirstLogin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _firstLoginFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const HomeScreen();
        }

        final isFirstLogin = snapshot.data ?? false;

        if (isFirstLogin) {
          return _FirstLoginChecker(
            onCheckComplete: () {
              FirstLoginService.markFirstLoginCompleted();
              Navigator.of(context).pushReplacementNamed('/');
            },
          );
        }

        return const HomeScreen();
      },
    );
  }
}

/// Widget that shows system checker on first login
class _FirstLoginChecker extends StatefulWidget {
  final VoidCallback onCheckComplete;

  const _FirstLoginChecker({required this.onCheckComplete});

  @override
  State<_FirstLoginChecker> createState() => _FirstLoginCheckerState();
}

class _FirstLoginCheckerState extends State<_FirstLoginChecker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("أهلا وسهلا"),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Welcome message
              Text(
                "مرحبا بك في سجادي",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "سنقوم بفحص جهازك للتأكد من أن كل شيء جاهز",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // System checker embedded with continue button
              CheckerScreen(
                showContinueButton: true,
                onContinue: () {
                  FirstLoginService.markFirstLoginCompleted();
                  widget.onCheckComplete();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
