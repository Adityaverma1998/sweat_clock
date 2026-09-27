import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stop_watch/data/services/purchase_service.dart';
import 'package:stop_watch/presentation/viewmodels/purchase_viewmodel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PurchaseService & PurchaseViewModel Tests', () {
    test('Initializes with unpaid status when no prior purchase exists', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final service = PurchaseService(prefs);
      final viewModel = PurchaseViewModel(service);

      expect(viewModel.isSupporterPaid, isFalse);
      expect(viewModel.paidTier, isNull);
    });

    test('Initializes with paid status when user previously paid on this device', () async {
      SharedPreferences.setMockInitialValues({
        PurchaseService.keyIsPaid: true,
        PurchaseService.keyPaidTier: '\$4.99',
      });
      final prefs = await SharedPreferences.getInstance();

      final service = PurchaseService(prefs);
      final viewModel = PurchaseViewModel(service);

      expect(viewModel.isSupporterPaid, isTrue);
      expect(viewModel.paidTier, equals('\$4.99'));
    });

    test('Buying a tier persists paid status and updates ViewModel', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final service = PurchaseService(prefs);
      final viewModel = PurchaseViewModel(service);

      expect(viewModel.isSupporterPaid, isFalse);

      final success = await viewModel.buyTier(PurchaseService.tier2);
      expect(success, isTrue);
      expect(viewModel.isSupporterPaid, isTrue);
      expect(viewModel.paidTier, equals('\$4.99'));

      // Verify stored in SharedPreferences for device persistence
      expect(prefs.getBool(PurchaseService.keyIsPaid), isTrue);
      expect(prefs.getString(PurchaseService.keyPaidTier), equals('\$4.99'));
    });

    test('Support tiers have increased amounts as requested', () {
      expect(PurchaseViewModel.tiers.length, equals(4));
      expect(PurchaseViewModel.tiers[0].defaultPrice, equals('\$1.99'));
      expect(PurchaseViewModel.tiers[1].defaultPrice, equals('\$4.99'));
      expect(PurchaseViewModel.tiers[2].defaultPrice, equals('\$9.99'));
      expect(PurchaseViewModel.tiers[3].defaultPrice, equals('\$19.99'));
    });
  });
}
