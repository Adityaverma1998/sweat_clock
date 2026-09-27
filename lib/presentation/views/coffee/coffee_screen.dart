import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/localization_ext.dart';
import '../../../core/theme/theme_ext.dart';
import '../../../widgets/confetti_view.dart';
import '../../viewmodels/purchase_viewmodel.dart';

class CoffeeScreen extends StatefulWidget {
  const CoffeeScreen({super.key});

  @override
  State<CoffeeScreen> createState() => _CoffeeScreenState();
}

class _CoffeeScreenState extends State<CoffeeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0.0, end: -15.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _showPurchaseDialog(
    BuildContext context,
    SupportTier tier,
    PurchaseViewModel purchaseViewModel,
  ) {
    final title = context.translate(tier.titleKey) != tier.titleKey
        ? context.translate(tier.titleKey)
        : tier.defaultTitle;

    final description = context.translate(tier.descKey) != tier.descKey
        ? context.translate(tier.descKey)
        : tier.defaultDesc;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: context.bgSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(color: context.borderSubtle),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: context.accent.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(tier.icon, style: const TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.accent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tier.defaultPrice,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: context.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.bgBase.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: context.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.verified_user_rounded,
                          size: 18, color: Colors.tealAccent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'One-time purchase • Always remembered on this device.',
                          style: TextStyle(
                            fontSize: 11,
                            color: context.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      final success = await purchaseViewModel.buyTier(tier.id);
                      if (context.mounted) {
                        if (success) {
                          _showSuccessDialog(context, tier);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Purchase was cancelled or failed.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.payment_rounded, size: 18),
                    label: Text(
                      '${context.translate('support_now')} ${tier.defaultPrice}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.accent,
                      foregroundColor: context.fabForeground,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(dialogContext);
                      await purchaseViewModel.openPlayStore();
                    },
                    icon: const Icon(Icons.shop_two_rounded, size: 16),
                    label: Text(
                      context.translate('open_play_store'),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: context.textPrimary,
                      side: BorderSide(color: context.borderSubtle),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: TextButton.styleFrom(
                    foregroundColor: context.textMuted,
                  ),
                  child: Text(context.translate('cancel')),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, SupportTier tier) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Stack(
          alignment: Alignment.center,
          children: [
            const ConfettiView(),
            Dialog(
              backgroundColor: context.bgSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: BorderSide(color: Colors.amber.withValues(alpha: 0.6), width: 1.5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Text('👑', style: TextStyle(fontSize: 38)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'THANK YOU!',
                      style: TextStyle(
                        fontFamily: 'Bebas Neue',
                        fontSize: 32,
                        letterSpacing: 2,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your support is deeply appreciated! SweatClock has permanently activated your Lifetime Supporter status on this device.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textPrimary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Enjoy SweatClock ⚡',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final purchaseViewModel = context.watch<PurchaseViewModel>();

    return Scaffold(
      backgroundColor: context.bgBase,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: context.textPrimary, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: context.bgSurface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: context.borderSubtle),
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.translate('buy_coffee'),
          style: TextStyle(
            color: context.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.accent.withValues(alpha: 0.08),
                  boxShadow: [
                    BoxShadow(
                      color: context.accent.withValues(alpha: 0.1),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  purchaseViewModel.isSupporterPaid ? '👑' : '☕',
                  style: const TextStyle(fontSize: 64),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              purchaseViewModel.isSupporterPaid
                  ? context.translate('supporter_active')
                  : context.translate('buy_coffee'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Bebas Neue',
                fontSize: 34,
                letterSpacing: 1.5,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                purchaseViewModel.isSupporterPaid
                    ? context.translate('supporter_active_desc')
                    : 'Help keep SweatClock ad-free, completely private, and evolving. Your support makes a direct difference!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Supporter VIP Status Banner if paid ──
            if (purchaseViewModel.isSupporterPaid) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.shade900.withValues(alpha: 0.25),
                      context.bgSurface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.6),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_rounded,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'LIFETIME SUPPORTER ACTIVE',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.w900,
                              fontSize: 14,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            purchaseViewModel.paidTier != null
                                ? 'Status: ${purchaseViewModel.paidTier} supporter'
                                : 'Forever active on this device & account.',
                            style: TextStyle(
                              color: context.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // ── Developer Bio Card ──
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.bgSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: context.borderSubtle),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [context.accent, context.accentLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'AD',
                        style: TextStyle(
                          color: context.fabForeground,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Aditya Verma',
                              style: TextStyle(
                                color: context.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: context.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Solo Dev',
                                style: TextStyle(
                                  color: Colors.amber,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Building clean, focus-oriented workout tools for athletes.',
                          style: TextStyle(
                            color: context.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Google Play Store Banner Card ──
            GestureDetector(
              onTap: () => purchaseViewModel.openPlayStore(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.teal.shade900.withValues(alpha: 0.25),
                      context.bgSurface,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.tealAccent.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.tealAccent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.shop_two_rounded,
                        color: Colors.tealAccent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.translate('open_play_store'),
                            style: TextStyle(
                              color: context.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            context.translate('open_play_store_desc'),
                            style: TextStyle(
                              color: context.textMuted,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.tealAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Open',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_outward_rounded, size: 14, color: Colors.black),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Support Tiers ──
            ...PurchaseViewModel.tiers.map((tier) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCoffeeTier(
                  context: context,
                  tier: tier,
                  isPaid: purchaseViewModel.isSupporterPaid,
                  isLoading: purchaseViewModel.isLoading,
                  onTap: () => _showPurchaseDialog(context, tier, purchaseViewModel),
                ),
              );
            }),

            const SizedBox(height: 12),

            // ── Restore Purchases Button ──
            TextButton.icon(
              onPressed: purchaseViewModel.isLoading
                  ? null
                  : () async {
                      await purchaseViewModel.restorePurchases();
                      if (context.mounted && purchaseViewModel.statusMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_outline_rounded,
                                    color: Colors.tealAccent),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(purchaseViewModel.statusMessage!),
                                ),
                              ],
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    },
              icon: const Icon(Icons.restore_rounded, size: 18),
              label: Text(
                context.translate('restore_purchases'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: context.accent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),

            Text(
              context.translate('restore_hint'),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: context.textMuted,
                fontSize: 11,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.security_rounded,
                    color: context.textMuted, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Processed securely via App Store / Google Play',
                  style: TextStyle(
                    color: context.textMuted,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (kDebugMode && purchaseViewModel.isSupporterPaid) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () async {
                  await purchaseViewModel.resetDebugStatus();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Supporter status reset (Debug mode).'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.refresh_rounded, size: 16),
                label: const Text(
                  'Reset Supporter Status (Debug)',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.orangeAccent,
                ),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCoffeeTier({
    required BuildContext context,
    required SupportTier tier,
    required bool isPaid,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    final isBest = tier.isBest;
    final bgColor = isBest ? context.coffeeTierBgBest : context.coffeeTierBg;
    final borderColor =
        isBest ? context.coffeeTierBorderBest : context.coffeeTierBorder;

    final title = context.translate(tier.titleKey) != tier.titleKey
        ? context.translate(tier.titleKey)
        : tier.defaultTitle;

    final description = context.translate(tier.descKey) != tier.descKey
        ? context.translate(tier.descKey)
        : tier.defaultDesc;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderColor, width: isBest ? 2 : 1),
          boxShadow: isBest
              ? [
                  BoxShadow(
                    color: context.accent.withValues(alpha: 0.12),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: context.bgBase.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(tier.icon, style: const TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: context.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: TextStyle(
                            color: context.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isLoading ? null : onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isBest ? context.accent : context.bgSurface3,
                      foregroundColor: context.fabForeground,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      minimumSize: Size.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      isPaid ? '${tier.defaultPrice} ⚡' : tier.defaultPrice,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isBest)
              Positioned(
                top: -12,
                right: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [context.accent, context.accentLight],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'MOST POPULAR',
                    style: TextStyle(
                      color: context.fabForeground,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
