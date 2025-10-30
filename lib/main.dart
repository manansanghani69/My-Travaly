import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';
import 'injection_container.dart';

Future<void> main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      FlutterError.onError = (details) {
        FlutterError.presentError(details);
        if (kReleaseMode) {
          Zone.current.handleUncaughtError(details.exception, details.stack ?? StackTrace.empty);
        }
      };

      ErrorWidget.builder = (details) {
        if (kDebugMode) {
          return ErrorWidget(details.exception);
        }
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
                  const SizedBox(height: 16),
                  const Text(
                    'Something went wrong',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    details.exceptionAsString(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      };

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      await init();

      runApp(const MyTravalyApp());
    },
    (error, stackTrace) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('Uncaught error: $error');
      }
    },
  );
}
