import 'package:flutter/material.dart';
import '../../data/services/purchase_service.dart';

class SupportTier {
  final String id;
  final String titleKey;
  final String defaultTitle;
  final String defaultPrice;
  final String descKey;
  final String defaultDesc;
  final String icon;
  final bool isBest;

  const SupportTier({
    required this.id,
    required this.titleKey,
    required this.defaultTitle,
    required this.defaultPrice,
    required this.descKey,
    required this.defaultDesc,
    required this.icon,
    this.isBest = false,
  });
}

class PurchaseViewModel with ChangeNotifier {
  final PurchaseService _service;
  bool _isLoading = false;
  String? _statusMessage;

  static const List<SupportTier> tiers = [
    SupportTier(
      id: PurchaseService.tier1,
      titleKey: 'small_coffee',
      defaultTitle: 'Quick Fuel',
      defaultPrice: '\$1.99',
      descKey: 'fuel_desc',
      defaultDesc: 'Fuel a few coding hours & bug fixes.',
      icon: '☕',
      isBest: false,
    ),
    SupportTier(
      id: PurchaseService.tier2,
      titleKey: 'coffee_donut',
      defaultTitle: 'Coffee & Donut',
      defaultPrice: '\$4.99',
      descKey: 'fuel_more_desc',
      defaultDesc: 'Fuel design updates and new features.',
      icon: '🍩',
      isBest: true,
    ),
    SupportTier(
      id: PurchaseService.tier3,
      titleKey: 'tier_champion',
      defaultTitle: 'Champion Supporter',
      defaultPrice: '\$9.99',
      descKey: 'tier_champion_desc',
      defaultDesc: 'Major booster! Powers high-intensity updates and new workout modes.',
      icon: '⚡',
      isBest: false,
    ),
    SupportTier(
      id: PurchaseService.tier4,
      titleKey: 'tier_vip',
      defaultTitle: 'Legend Patron',
      defaultPrice: '\$19.99',
      descKey: 'tier_vip_desc',
      defaultDesc: 'Ultimate lifetime support! Keep SweatClock 100% ad-free forever.',
      icon: '👑',
      isBest: false,
    ),
  ];

  PurchaseViewModel(this._service) {
    _service.isPaidNotifier.addListener(_onPaidStatusChanged);
  }

  void _onPaidStatusChanged() {
    notifyListeners();
  }

  bool get isSupporterPaid => _service.isSupporterPaid;
  String? get paidTier => _service.paidTier;
  bool get isLoading => _isLoading;
  String? get statusMessage => _statusMessage;
  bool isProductInStore(String productId) => _service.isProductInStore(productId);

  Future<bool> openPlayStore() async {
    return await _service.openPlayStoreListing();
  }

  Future<bool> buyTier(String productId, {bool openStoreFallback = true}) async {
    _isLoading = true;
    _statusMessage = null;
    notifyListeners();

    try {
      final success = await _service.buyProduct(productId, openStoreFallback: openStoreFallback);
      _isLoading = false;
      if (success) {
        _statusMessage = 'Thank you for your generous support! ⭐';
      }
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _statusMessage = 'Purchase could not be completed. Please try again.';
      notifyListeners();
      return false;
    }
  }

  Future<void> restorePurchases() async {
    _isLoading = true;
    _statusMessage = null;
    notifyListeners();

    try {
      await _service.restorePurchases();
      _isLoading = false;
      if (_service.isSupporterPaid) {
        _statusMessage = 'Your supporter purchase has been successfully restored! 🎉';
      } else {
        _statusMessage = 'No previous purchases found for this store account.';
      }
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _statusMessage = 'Unable to restore purchases at this moment.';
      notifyListeners();
    }
  }

  Future<void> resetDebugStatus() async {
    await _service.resetPurchasesForDebug();
    notifyListeners();
  }

  @override
  void dispose() {
    _service.isPaidNotifier.removeListener(_onPaidStatusChanged);
    super.dispose();
  }
}
