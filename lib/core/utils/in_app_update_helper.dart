import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:in_app_update/in_app_update.dart';

class InAppUpdateHelper {
  static Future<void> checkForPlayStoreUpdate() async {
    // Only run on Android since in_app_update is Android-only
    if (kIsWeb) return;

    bool isAndroid = false;
    try {
      isAndroid = Platform.isAndroid;
    } catch (_) {
      // If Platform check fails (e.g. on web or unsupported platform)
      return;
    }

    if (!isAndroid) return;

    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Perform immediate update (blocks user until downloaded)
          await InAppUpdate.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          // Perform flexible update (downloads in background)
          await InAppUpdate.startFlexibleUpdate();
          // After download, complete the update
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint('Play Store In-App Update failed: $e');
    }
  }
}
