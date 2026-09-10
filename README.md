# Bottomation 🚀

A delightful collection of interactive animated buttons and micro-interactions for Flutter applications. Built with 100% pure Flutter (`CustomPainter` & `AnimationController`) for peak 60/120 FPS performance with zero external asset dependencies.

[![pub package](https://img.shields.io/badge/pub-v0.0.1-blue.svg)](https://pub.dev/packages/bottomation)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?logo=flutter)](https://flutter.dev)

---

## ✨ Features

- **🗑️ Animated Delete Button**:
  - **Organic Letter Suction**: Letters of the text (e.g. `D - e - l - e - t - e`) dynamically scatter and fly along Bézier curves directly into the trash bin.
  - **Hinge Lid Physics**: The trash can lid tilts open dynamically and closes when suction is complete.
  - **Pill-to-Circle Morphing**: Smooth width animation collapsing the button into a focused action circle.
  - **Circular Progress Arc**: 360-degree loading ring indicating background deletion progress.
  - **Success Checkmark State**: Color transition with an animated spring checkmark (✔) on completion.
- **🎨 Built-in Presets**:
  - `DeleteButtonStyle.dark()` (Sleek charcoal with deep shadows).
  - `DeleteButtonStyle.purple()` (Vibrant purple gradient).
  - Fully customizable colors, dimensions, gradients, text styles, and elevation.
- **⚡ Unified API**: Consistent, modular API (`Bottomation.delete(...)`) ready for multiple future button micro-interactions.
- **🎯 Full Control**: Includes `AnimatedDeleteButtonController` for programmatic triggering and resetting.

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

## 🚀 Quick Usage

### 1. Unified API (Recommended)

```dart
import 'package:flutter/material.dart';
import 'package:bottomation/bottomation.dart';

class MyDeleteScreen extends StatelessWidget {
  const MyDeleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Bottomation.delete(
        text: 'Delete',
        style: DeleteButtonStyle.purple(),
        onTap: () async {
          // Perform your delete API or database operation
          await Future.delayed(const Duration(seconds: 1));
        },
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Item deleted successfully!')),
          );
        },
      ),
    );
  }
}
```

### 2. Using Dark Preset

```dart
Bottomation.delete(
  style: DeleteButtonStyle.dark(),
  onSuccess: () => print('Deleted!'),
)
```

### 2. Direct Color Customization

You don't even need to instantiate `DeleteButtonStyle` — customize colors directly:

```dart
Bottomation.delete(
  text: 'Delete',
  backgroundColor: const Color(0xFFDC2626), // Custom Red
  textColor: Colors.white,
  iconColor: Colors.white,
  successColor: const Color(0xFF16A34A),
  onSuccess: () => print('Item deleted! ✔'),
)
```

### 3. Arabic & RTL Support ("حذف") 🇸🇦 🇪🇬

Full native Right-to-Left support with automatic Arabic script detection. In RTL mode, the trash bin positions itself on the right, the lid tilts open facing the letters, and the Arabic cursive word dynamically breaks apart into individual flying glyphs (`ح - ذ - ف`):

```dart
Bottomation.delete(
  text: 'حذف',
  backgroundColor: const Color(0xFFE11D48),
  textColor: Colors.white,
  iconColor: Colors.white,
  onSuccess: () => print('تم الحذف بنجاح! ✔'),
)
```

### 4. Programmatic Control (Controller)

```dart
final controller = AnimatedDeleteButtonController();

// Trigger the animation sequence programmatically:
controller.trigger();

// Reset the button back to its initial idle state:
controller.reset();

// Listen to state changes:
controller.addListener(() {
  print('Current State: ${controller.state}');
});
```

---

## 🎨 Customizing Styles

You can customize all aspects of the button:

```dart
DeleteButtonStyle(
  backgroundColor: Colors.red.shade700,
  backgroundGradient: LinearGradient(
    colors: [Colors.red.shade400, Colors.red.shade900],
  ),
  iconColor: Colors.white,
  textStyle: const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 18,
  ),
  progressColor: Colors.amber,
  successColor: Colors.green,
  checkmarkColor: Colors.white,
  height: 56.0,
  width: 180.0,
  elevation: 10.0,
)
```

---

## 🛠️ Architecture & Roadmap

`bottomation` is architected to house a growing library of button micro-interactions:

| Interaction | Status | Description |
| :--- | :--- | :--- |
| `Bottomation.delete()` | ✅ Released | Letter suction, lid rotation, circle morphing, loading arc, success checkmark. |
| `Bottomation.addToCart()` | 🚧 In Progress | Cart fly-in, item drop, badge count pop. |
| `Bottomation.create()` | 📋 Planned | Plus morphing into checkmark or unfolding panel. |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
