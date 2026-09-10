# Bottomation 🚀

A delightful collection of interactive animated buttons and micro-interactions for Flutter applications. Built with 100% pure Flutter (`CustomPainter` & `AnimationController`) for peak 60/120 FPS performance with zero external asset dependencies.

[![pub package](https://img.shields.io/badge/pub-v0.0.1-blue.svg)](https://pub.dev/packages/bottomation)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter)](https://flutter.dev)

---

## ✨ Available Buttons & Features

`bottomation` comes with production-ready, highly engaging micro-interaction buttons:

### 1. 🗑️ Animated Delete Button (`Bottomation.delete`)
- **Organic Letter Suction**: Letters of the text (e.g. `D - e - l - e - t - e` or `ح - ذ - ف`) dynamically lift, scatter, and fly along Bézier curves straight into the trash bin.
- **Hinge Lid Physics**: The trash can lid tilts open dynamically to receive the incoming letters and closes once all letters are inside.
- **Pill-to-Circle Morphing**: Smooth width animation collapsing the button into a focused action circle.
- **Circular Progress Arc**: 360-degree loading ring indicating background deletion/network operation.
- **Success Checkmark State**: Morphing color transition with an animated spring checkmark (✔) on completion.
- **Arabic & RTL Support**: Native RTL detection with mirrored bin position, reverse lid tilting, and accurate Arabic cursive ligature decomposition.

### 2. 🚪 Animated Logout Button (`Bottomation.logout`)
- **3D Perspective Swinging Door**: Slender architectural doorway with arched top corners and flat sill, swinging open into 3D perspective.
- **Marching Letters**: Characters walk sequentially towards and step through the doorway threshold with a dynamic walking bounce.
- **Threshold Clipping**: Letters disappear seamlessly behind the door frame as they cross the threshold.
- **Door Latch & Success State**: The door swings shut and latches, collapsing into a loading circle and completing with a success checkmark.
- **Arabic & RTL Support**: Door places on the correct side, swings with proper perspective, and Arabic phrases (`تسجيل الخروج`) march through the threshold.

---

## 📦 Getting Started

Add `bottomation` to your `pubspec.yaml`:

```yaml
dependencies:
  bottomation: ^0.0.1
```

Or run:

```bash
flutter pub add bottomation
```

---

## 🚀 Usage & Examples

### 1. Animated Delete Button

#### Basic & Unified Usage
```dart
import 'package:flutter/material.dart';
import 'package:bottomation/bottomation.dart';

Bottomation.delete(
  text: 'Delete',
  style: DeleteButtonStyle.purple(),
  onTap: () async {
    // Perform async delete operation (e.g. API call or DB query)
    await Future.delayed(const Duration(seconds: 1));
  },
  onSuccess: () {
    print('Item deleted successfully! ✔');
  },
)
```

#### Complete Parameters & Custom Styling
```dart
Bottomation.delete(
  text: 'Delete Account',
  // Direct customization without needing a style object:
  backgroundColor: const Color(0xFFDC2626), // Custom Red
  textColor: Colors.white,
  iconColor: Colors.white,
  progressColor: Colors.amber,
  successColor: const Color(0xFF16A34A),
  checkmarkColor: Colors.white,
  width: 190.0,
  height: 52.0,
  borderRadius: 26.0,
  elevation: 6.0,
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  ),
  onTap: () async {
    await Future.delayed(const Duration(milliseconds: 1200));
  },
  onSuccess: () => print('Account deleted!'),
)
```

#### Arabic / RTL Example ("حذف المنتج") 🇸🇦 🇪🇬
```dart
Bottomation.delete(
  text: 'حذف المنتج',
  backgroundColor: const Color(0xFFE11D48),
  textColor: Colors.white,
  iconColor: Colors.white,
  onTap: () async {
    await Future.delayed(const Duration(seconds: 1));
  },
  onSuccess: () => print('تم حذف المنتج بنجاح! ✔'),
)
```

#### Programmatic Controller (`AnimatedDeleteButtonController`)
```dart
class DeleteControllerExample extends StatefulWidget {
  const DeleteControllerExample({super.key});

  @override
  State<DeleteControllerExample> createState() => _DeleteControllerExampleState();
}

class _DeleteControllerExampleState extends State<DeleteControllerExample> {
  final AnimatedDeleteButtonController _controller = AnimatedDeleteButtonController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Bottomation.delete(
          controller: _controller,
          text: 'Delete',
          onTap: () async => await Future.delayed(const Duration(seconds: 1)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _controller.trigger(), // Programmatically trigger
              child: const Text('Trigger'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => _controller.reset(), // Reset to idle
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

### 2. Animated Logout Button

#### Basic & Unified Usage
```dart
import 'package:flutter/material.dart';
import 'package:bottomation/bottomation.dart';

Bottomation.logout(
  text: 'Log out',
  style: LogoutButtonStyle.crimson(),
  onTap: () async {
    // Perform authentication logout or token cleanup
    await Future.delayed(const Duration(seconds: 1));
  },
  onSuccess: () {
    print('Logged out successfully! 🚪');
  },
)
```

#### Complete Parameters & Custom Styling
```dart
Bottomation.logout(
  text: 'Sign out',
  // Direct customization:
  backgroundColor: const Color(0xFF1E293B), // Dark Slate
  textColor: Colors.white,
  doorColor: const Color(0xFF64748B),
  doorFrameColor: const Color(0xFF94A3B8),
  progressColor: const Color(0xFF38BDF8),
  successColor: const Color(0xFF10B981),
  checkmarkColor: Colors.white,
  width: 170.0,
  height: 52.0,
  borderRadius: 26.0,
  elevation: 6.0,
  textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ),
  onTap: () async {
    await Future.delayed(const Duration(milliseconds: 1200));
  },
  onSuccess: () => print('User signed out'),
)
```

#### Arabic / RTL Example ("تسجيل الخروج") 🇸🇦 🇪🇬
```dart
Bottomation.logout(
  text: 'تسجيل الخروج',
  backgroundColor: const Color(0xFFBE123C), // Crimson
  textColor: Colors.white,
  doorColor: Colors.white70,
  doorFrameColor: Colors.white,
  onTap: () async {
    await Future.delayed(const Duration(seconds: 1));
  },
  onSuccess: () => print('تم تسجيل الخروج بنجاح! ✔'),
)
```

#### Programmatic Controller (`AnimatedLogoutButtonController`)
```dart
class LogoutControllerExample extends StatefulWidget {
  const LogoutControllerExample({super.key});

  @override
  State<LogoutControllerExample> createState() => _LogoutControllerExampleState();
}

class _LogoutControllerExampleState extends State<LogoutControllerExample> {
  final AnimatedLogoutButtonController _controller = AnimatedLogoutButtonController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Bottomation.logout(
          controller: _controller,
          text: 'Log out',
          onTap: () async => await Future.delayed(const Duration(seconds: 1)),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _controller.trigger(), // Programmatically trigger
              child: const Text('Trigger'),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => _controller.reset(), // Reset to idle
              child: const Text('Reset'),
            ),
          ],
        ),
      ],
    );
  }
}
```

---

## 🎨 Built-in Style Presets

Both buttons include ready-to-use style presets out of the box:

```dart
// Delete presets
DeleteButtonStyle.purple()
DeleteButtonStyle.dark()

// Logout presets
LogoutButtonStyle.crimson()
LogoutButtonStyle.dark()
```

Or configure custom style objects:

```dart
DeleteButtonStyle(
  backgroundColor: Colors.red.shade700,
  backgroundGradient: LinearGradient(
    colors: [Colors.red.shade400, Colors.red.shade900],
  ),
  iconColor: Colors.white,
  progressColor: Colors.amber,
  successColor: Colors.green,
  checkmarkColor: Colors.white,
  height: 56.0,
  width: 180.0,
  elevation: 8.0,
)
```

---

## 🛠️ Available Buttons

`bottomation` is designed with an extensible architecture. Currently available buttons:

| Interaction | Status | Description |
| :--- | :--- | :--- |
| `Bottomation.delete()` | ✅ Released | Letter suction along Bézier curves into trash bin, hinge lid rotation, circle morphing, loading arc, success checkmark. |
| `Bottomation.logout()` | ✅ Released | 3D swinging arched doorway, walking letter march through threshold with depth clipping, latching shut, success checkmark. |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
