import 'package:flutter/material.dart';
import 'package:bottomation/bottomation.dart';

void main() {
  runApp(const BottomationExampleApp());
}

class BottomationExampleApp extends StatelessWidget {
  const BottomationExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bottomation Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const BottomationShowcasePage(),
    );
  }
}

class BottomationShowcasePage extends StatefulWidget {
  const BottomationShowcasePage({super.key});

  @override
  State<BottomationShowcasePage> createState() =>
      _BottomationShowcasePageState();
}

class _BottomationShowcasePageState extends State<BottomationShowcasePage> {
  // Delete animation controllers
  final AnimatedDeleteButtonController _purpleDeleteController =
      AnimatedDeleteButtonController();
  final AnimatedDeleteButtonController _darkDeleteController =
      AnimatedDeleteButtonController();
  final AnimatedDeleteButtonController _arabicDeleteController =
      AnimatedDeleteButtonController();

  // Logout animation controllers
  final AnimatedLogoutButtonController _crimsonLogoutController =
      AnimatedLogoutButtonController();
  final AnimatedLogoutButtonController _arabicLogoutController =
      AnimatedLogoutButtonController();

  // Add to cart animation controllers
  final AnimatedAddToCartButtonController _tealCartController =
      AnimatedAddToCartButtonController();
  final AnimatedAddToCartButtonController _darkCartController =
      AnimatedAddToCartButtonController();
  final AnimatedAddToCartButtonController _arabicCartController =
      AnimatedAddToCartButtonController();

  // Place order animation controllers
  final AnimatedPlaceOrderButtonController _darkPlaceOrderController =
      AnimatedPlaceOrderButtonController();
  final AnimatedPlaceOrderButtonController _midnightPlaceOrderController =
      AnimatedPlaceOrderButtonController();
  final AnimatedPlaceOrderButtonController _arabicPlaceOrderController =
      AnimatedPlaceOrderButtonController();

  String _lastEvent = 'Tap any button to see the micro-interactions in action';

  @override
  void dispose() {
    _purpleDeleteController.dispose();
    _darkDeleteController.dispose();
    _arabicDeleteController.dispose();
    _crimsonLogoutController.dispose();
    _arabicLogoutController.dispose();
    _tealCartController.dispose();
    _darkCartController.dispose();
    _arabicCartController.dispose();
    _darkPlaceOrderController.dispose();
    _midnightPlaceOrderController.dispose();
    _arabicPlaceOrderController.dispose();
    super.dispose();
  }

  void _showFeedback(String message) {
    setState(() {
      _lastEvent = message;
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        title: const Text(
          'Bottomation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top notification status
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x08000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.touch_app,
                        size: 18,
                        color: Color(0xFF7C3AED),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _lastEvent,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // ==========================================
                // SECTION 1: ANIMATED DELETE BUTTONS
                // ==========================================
                _buildSectionHeader(
                  badge: 'Micro-Interaction #1',
                  title: 'Animated Delete Button (Suction & Basket)',
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildButtonCard(
                      title: 'Purple Gradient',
                      subtitle: 'Preset Style',
                      child: Bottomation.delete(
                        controller: _purpleDeleteController,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        onTap: () async {
                          _showFeedback('Deleting item (Red)...');
                        },
                        onSuccess: () {
                          _showFeedback('Red: Item deleted successfully! ✔');
                        },
                      ),
                      onReset: () => _purpleDeleteController.reset(),
                    ),
                    _buildButtonCard(
                      title: 'Dark Charcoal',
                      subtitle: 'Preset Style',
                      child: Bottomation.delete(
                        controller: _darkDeleteController,
                        style: DeleteButtonStyle.dark(),
                        onTap: () async {
                          _showFeedback('Deleting item (Dark)...');
                        },
                        onSuccess: () {
                          _showFeedback('Dark: Item deleted successfully! ✔');
                        },
                      ),
                      onReset: () => _darkDeleteController.reset(),
                    ),
                    _buildButtonCard(
                      title: 'Arabic RTL (حذف. المنتج)',
                      subtitle: 'Custom Crimson Color',
                      child: Bottomation.delete(
                        controller: _arabicDeleteController,
                        text: 'حذف. المنتج',
                        width: 195.0,
                        height: 56.0,
                        backgroundColor: const Color(0xFFE11D48),
                        textColor: Colors.white,
                        iconColor: Colors.white,
                        progressColor: Colors.white,
                        successColor: const Color(0xFF10B981),
                        onTap: () async {
                          _showFeedback('جاري حذف المنتج...');
                        },
                        onSuccess: () {
                          _showFeedback('تم حذف المنتج بنجاح! ✔');
                        },
                      ),
                      onReset: () => _arabicDeleteController.reset(),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // ==========================================
                // SECTION 2: ANIMATED LOGOUT BUTTONS
                // ==========================================
                _buildSectionHeader(
                  badge: 'Micro-Interaction #2',
                  title: 'Animated Logout Button (3D Door Exit)',
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildButtonCard(
                      title: 'Crimson Rose',
                      subtitle: 'Preset Style',
                      child: Bottomation.logout(
                        controller: _crimsonLogoutController,
                        text: 'Logout',
                        style: LogoutButtonStyle.crimson(),
                        onTap: () async {
                          _showFeedback('Logging out of account...');
                        },
                        onSuccess: () {
                          _showFeedback('Logged out successfully! 🚪✔');
                        },
                      ),
                      onReset: () => _crimsonLogoutController.reset(),
                    ),
                    _buildButtonCard(
                      title: 'Arabic RTL (تسجيل الخروج)',
                      subtitle: '3D Door & Hebrew/Arabic RTL',
                      child: Bottomation.logout(
                        controller: _arabicLogoutController,
                        text: 'تسجيل الخروج',
                        width: 210.0,
                        height: 56.0,
                        style: LogoutButtonStyle.crimson(),
                        onTap: () async {
                          _showFeedback('جاري إنهاء الجلسة...');
                        },
                        onSuccess: () {
                          _showFeedback('تم تسجيل الخروج بنجاح! 🚪✔');
                        },
                      ),
                      onReset: () => _arabicLogoutController.reset(),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // ==========================================
                // SECTION 3: ANIMATED ADD TO CART BUTTONS
                // ==========================================
                _buildSectionHeader(
                  badge: 'Micro-Interaction #3',
                  title: 'Animated Add to Cart (Factory & Conveyor)',
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildButtonCard(
                      title: 'Teal Forest (Default)',
                      subtitle: 'Conveyor, Laser, Cart & +1 Badge',
                      child: Bottomation.addToCart(
                        controller: _tealCartController,
                        text: 'Add to cart',
                        style: AddToCartButtonStyle.teal(),
                        onTap: () async {
                          _showFeedback(
                            'Packaging item and adding to cart (Teal)...',
                          );
                        },
                        onSuccess: () {
                          _showFeedback('Item added to cart! 🛒+1 ✔');
                        },
                      ),
                      onReset: () => _tealCartController.reset(),
                    ),
                    _buildButtonCard(
                      title: 'Dark Charcoal Factory',
                      subtitle: 'Industrial Factory Theme',
                      child: Bottomation.addToCart(
                        controller: _darkCartController,
                        text: 'Add to cart',
                        // style: AddToCartButtonStyle.dark(),
                        backgroundColor: Colors.blue,
                        borderRadius: 20,

                        onTap: () async {
                          _showFeedback('Packaging item (Dark)...');
                        },
                        onSuccess: () {
                          _showFeedback('Dark: Item added to cart! 🛒+1 ✔');
                        },
                      ),
                      onReset: () => _darkCartController.reset(),
                    ),
                    _buildButtonCard(
                      title: 'Arabic RTL (أضف إلى السلة)',
                      subtitle: 'Mirrored Conveyor & Cart Physics',
                      child: Bottomation.addToCart(
                        controller: _arabicCartController,
                        text: 'أضف إلى السلة',
                        successText: 'تمت الإضافة',
                        width: 215.0,
                        height: 56.0,
                        style: AddToCartButtonStyle.teal(),
                        onTap: () async {
                          _showFeedback('جاري تجهيز الصندوق وإضافته للسلة...');
                        },
                        onSuccess: () {
                          _showFeedback(
                            'تمت إضافة المنتج إلى السلة بنجاح! 🛒+1 ✔',
                          );
                        },
                      ),
                      onReset: () => _arabicCartController.reset(),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // ==========================================
                // SECTION 4: PLACE ORDER BUTTONS
                // ==========================================
                _buildSectionHeader(
                  badge: 'NEW IN V0.0.2',
                  title: '4. 🚚 Animated Place Order Button',
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildButtonCard(
                      title: 'Asphalt & Cobalt Truck',
                      subtitle: 'Top-Down Delivery Sequence',
                      child: Bottomation.placeOrder(
                        controller: _darkPlaceOrderController,
                        text: 'Complete Order',
                        successText: 'Order Placed',
                        style: PlaceOrderButtonStyle.dark(),
                        onTap: () async {
                          _showFeedback('Loading package into delivery truck...');
                        },
                        onSuccess: () {
                          _showFeedback('Order dispatched! Fast highway delivery 🚚💨 ✔');
                        },
                      ),
                      onReset: () => _darkPlaceOrderController.reset(),
                    ),
                    _buildButtonCard(
                      title: 'Midnight & Orange Truck',
                      subtitle: 'Midnight Freight Theme',
                      child: Bottomation.placeOrder(
                        controller: _midnightPlaceOrderController,
                        text: 'Place Order',
                        successText: 'Dispatched',
                        style: PlaceOrderButtonStyle.midnight(),
                        onTap: () async {
                          _showFeedback('Dispatched: Preparing cargo box...');
                        },
                        onSuccess: () {
                          _showFeedback('Midnight: Order on its way! 🚚💨 ✔');
                        },
                      ),
                      onReset: () => _midnightPlaceOrderController.reset(),
                    ),
                    _buildButtonCard(
                      title: 'Arabic RTL (إتمام الطلب)',
                      subtitle: 'Mirrored Left-Exit Highway Drive',
                      child: Bottomation.placeOrder(
                        controller: _arabicPlaceOrderController,
                        text: 'إتمام الطلب',
                        successText: 'تم تأكيد الطلب',
                        width: 220.0,
                        height: 54.0,
                        style: PlaceOrderButtonStyle.dark(),
                        onTap: () async {
                          _showFeedback('جاري تحميل الشحنة وتأكيد الطلب...');
                        },
                        onSuccess: () {
                          _showFeedback(
                            'تم تأكيد الطلب وانطلاق الشاحنة بنجاح! 🚚💨 ✔',
                          );
                        },
                      ),
                      onReset: () => _arabicPlaceOrderController.reset(),
                    ),
                  ],
                ),

                const SizedBox(height: 44),

                // ==========================================
                // INFO & ARCHITECTURE CARD
                // ==========================================
                Container(
                  padding: const EdgeInsets.all(20),
                  constraints: const BoxConstraints(maxWidth: 500),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A000000),
                        blurRadius: 20,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 20,
                            color: Color(0xFF6D28D9),
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Bottomation Architecture',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildStageStep(
                        '1',
                        'Modular Design',
                        'Each button micro-interaction is completely decoupled in its own domain module.',
                      ),
                      _buildStageStep(
                        '2',
                        '100% Pure Flutter',
                        'Vector CustomPainters & AnimationControllers (60/120 FPS, zero Lottie/assets).',
                      ),
                      _buildStageStep(
                        '3',
                        'Bilingual LTR / RTL',
                        'Arabic ligature bounding box tracking & mirrored hinge mechanics.',
                      ),
                      _buildStageStep(
                        '4',
                        'Success Checkmark',
                        'Satisfying state transitions with color morphing and spring feedback.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required String badge, required String title}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFEDE9FE),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              color: Color(0xFF6D28D9),
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonCard({
    required String title,
    required String subtitle,
    required Widget child,
    required VoidCallback onReset,
  }) {
    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0E000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
          ),
          const SizedBox(height: 20),
          SizedBox(height: 60, child: Center(child: child)),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: onReset,
            icon: const Icon(Icons.refresh, size: 15),
            label: const Text('Reset', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildStageStep(String number, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: const Color(0xFFEDE9FE),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D28D9),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 13, color: Color(0xFF475569)),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: desc),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
