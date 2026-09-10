import 'package:flutter/foundation.dart';
import '../../core/bottomation_state.dart';

/// Optional controller to programmatically trigger or reset an [AnimatedAddToCartButton].
class AnimatedAddToCartButtonController extends ChangeNotifier {
  BottomationState _state = BottomationState.idle;

  /// Current state of the animated add-to-cart button.
  BottomationState get state => _state;

  VoidCallback? _triggerCallback;
  VoidCallback? _resetCallback;

  /// Internal attachment to widget state.
  void attach({
    required VoidCallback onTrigger,
    required VoidCallback onReset,
  }) {
    _triggerCallback = onTrigger;
    _resetCallback = onReset;
  }

  /// Internal detachment from widget state.
  void detach() {
    _triggerCallback = null;
    _resetCallback = null;
  }

  /// Updates the current state and notifies listeners.
  void updateState(BottomationState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  /// Programmatically triggers the add-to-cart animation flow.
  void trigger() {
    _triggerCallback?.call();
  }

  /// Resets the button back to its initial idle state.
  void reset() {
    _resetCallback?.call();
  }
}
