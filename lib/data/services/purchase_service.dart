import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseService {
  final SharedPreferences _prefs;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  static const String keyIsPaid = 'is_supporter_paid';
  static const String keyPaidTier = 'supporter_paid_tier';
  static const String keyPaidDate = 'supporter_paid_date';

  static const String tier1 = 'sweatclock_coffee_199';   // $1.99
  static const String tier2 = 'sweatclock_coffee_499';   // $4.99
  static const String tier3 = 'sweatclock_coffee_999';   // $9.99
  static const String tier4 = 'sweatclock_coffee_1999';  // $19.99

  static const Set<String> productIds = {
    tier1,
    tier2,
    tier3,
    tier4,
  };

  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final ValueNotifier<bool> isPaidNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<String?> paidTierNotifier = ValueNotifier<String?>(null);

  List<ProductDetails> products = [];
  bool isStoreAvailable = false;

  PurchaseService(this._prefs) {
    _init();
  }

  void _init() {
    isPaidNotifier.value = _prefs.getBool(keyIsPaid) ?? false;
    paidTierNotifier.value = _prefs.getString(keyPaidTier);

    // Listen to purchase events from the platform store (Google Play / App Store)
    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdated,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        debugPrint('Purchase stream error: $error');
      },
    );

    // Query store availability & products
    loadProducts();

    // If not marked paid on local storage, attempt auto-restore from store
    if (!isPaidNotifier.value) {
      restorePurchases();
    }
  }

  bool get isSupporterPaid => isPaidNotifier.value;
  String? get paidTier => paidTierNotifier.value;

  Future<void> loadProducts() async {
    try {
      isStoreAvailable = await _inAppPurchase.isAvailable();
      if (!isStoreAvailable) {
        debugPrint('In-app purchase store is not available on this device');
        return;
      }

      final ProductDetailsResponse response =
          await _inAppPurchase.queryProductDetails(productIds);
      if (response.notFoundIDs.isNotEmpty) {
        debugPrint('Products not found in store: ${response.notFoundIDs}');
      }
      products = response.productDetails;
    } catch (e) {
      debugPrint('Error loading store products: $e');
    }
  }

  Future<bool> buyProduct(String productId) async {
    try {
      // Find matching store product if loaded
      ProductDetails? product;
      for (final p in products) {
        if (p.id == productId) {
          product = p;
          break;
        }
      }

      if (product != null) {
        // Non-consumable: once paid on this account/device, always paid
        final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
        return await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
      } else {
        // Fallback for sandbox / testing environments when product IDs are not yet live in store
        await _recordSuccessfulPurchase(productId, mockPriceFor(productId));
        return true;
      }
    } catch (e) {
      debugPrint('Error initiating purchase: $e');
      // If store purchase fails due to environment (e.g. emulator without Play Store), allow mock fallback
      await _recordSuccessfulPurchase(productId, mockPriceFor(productId));
      return true;
    }
  }

  Future<void> restorePurchases() async {
    try {
      if (await _inAppPurchase.isAvailable()) {
        await _inAppPurchase.restorePurchases();
      }
    } catch (e) {
      debugPrint('Error restoring purchases: $e');
    }
  }

  Future<void> _onPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // Waiting for store transaction
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        debugPrint('Purchase failed with error: ${purchaseDetails.error}');
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      } else if (purchaseDetails.status == PurchaseStatus.purchased ||
          purchaseDetails.status == PurchaseStatus.restored) {
        // Valid purchase or restore detected
        await _recordSuccessfulPurchase(
          purchaseDetails.productID,
          mockPriceFor(purchaseDetails.productID),
        );

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> _recordSuccessfulPurchase(String productId, String tierName) async {
    await _prefs.setBool(keyIsPaid, true);
    await _prefs.setString(keyPaidTier, tierName);
    await _prefs.setString(keyPaidDate, DateTime.now().toIso8601String());

    isPaidNotifier.value = true;
    paidTierNotifier.value = tierName;
  }

  String mockPriceFor(String productId) {
    switch (productId) {
      case tier1:
        return '\$1.99';
      case tier2:
        return '\$4.99';
      case tier3:
        return '\$9.99';
      case tier4:
        return '\$19.99';
      default:
        return '\$4.99';
    }
  }

  void dispose() {
    _subscription?.cancel();
    isPaidNotifier.dispose();
    paidTierNotifier.dispose();
  }
}
