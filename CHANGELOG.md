## 0.0.2

* Added **`Bottomation.placeOrder(...)`** (`AnimatedPlaceOrderButton`):
  * Interactive top-down delivery truck loading sequence.
  * Articulating rear cargo doors (opening and closing with realistic hinge physics).
  * Automated cardboard package sliding into truck cargo hold.
  * Illuminated front headlights with light beam projection cones.
  * Animated dashed highway road lane divider lines.
  * Vehicle anticipation recoil and high-speed acceleration drive-off.
  * Dynamic success state ("Order Placed" / "تم تأكيد الطلب") with animated checkmark.
  * Direct property customization for background, truck cab, cargo body, windshield, headlights, package, tape, and road line.
  * Presets: `PlaceOrderButtonStyle.dark()` (Default), `PlaceOrderButtonStyle.midnight()`, `PlaceOrderButtonStyle.emerald()`.
  * First-class Arabic RTL support (mirrored vehicle entry from left, drive-off to left, package from right).
* Fixed `BoxDecoration` conflict: Passing solid `backgroundColor` directly automatically clears preset gradients across all buttons (`delete`, `logout`, `addToCart`, `placeOrder`).
* Added `AnimatedPlaceOrderButtonController` for programmatic trigger and reset.
* Updated `example/` application with comprehensive interactive demos for `placeOrder`.

## 0.0.1

* Initial release of **Bottomation**!
* Added **`Bottomation.delete(...)`**:
  * Letter suction micro-interaction along Bézier trajectory curves into trash bin.
  * Rotating hinge trash can lid physics.
  * Pill-to-circle morphing container and circular progress indicator arc.
  * Dynamic success checkmark spring animation.
  * Presets: `DeleteButtonStyle.dark()`, `DeleteButtonStyle.purple()`.
* Added **`Bottomation.logout(...)`**:
  * Architectural 3D perspective swinging door with arched top corners and flat sill.
  * Characters walking through doorway threshold with bouncing physics and depth clipping.
  * Door latching shut and collapsing into circular progress and success state.
  * Presets: `LogoutButtonStyle.crimson()`, `LogoutButtonStyle.dark()`, `LogoutButtonStyle.indigo()`.
* Added **`Bottomation.addToCart(...)`**:
  * Industrial factory conveyor belt with animated rollers.
  * Overhead scanner unit with red laser beam scan.
  * Automatic cardboard box flap sealing and stamped white shipping label.
  * Parabolic gravity drop into wireframe shopping cart with suspension bounce.
  * Radiant popping `+1` notification badge.
  * Presets: `AddToCartButtonStyle.teal()` (Default), `AddToCartButtonStyle.dark()`, `AddToCartButtonStyle.indigo()`.
* First-class native bilingual LTR and RTL (Arabic/Hebrew) support across all micro-interactions.
* Direct parameter customization for all components (background, icons, text, colors).
* Clean separation of concerns with dedicated controllers for programmatic triggering and resetting.
* Standalone `example/` showcase application demonstrating all buttons and themes.
