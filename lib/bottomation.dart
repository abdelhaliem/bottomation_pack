/// A delightful collection of interactive animated buttons and micro-interactions
/// for Flutter applications.
library;

// Core exports
export 'src/core/bottomation_state.dart';
export 'src/core/trajectory_utils.dart';

// Unified API
export 'src/widgets/bottomation.dart';

// Delete Animation Module
export 'src/animations/delete/animated_delete_button.dart';
export 'src/animations/delete/delete_button_controller.dart';
export 'src/animations/delete/delete_button_style.dart';
export 'src/animations/delete/models/letter_flight_data.dart';
export 'src/animations/delete/painters/circular_progress_painter.dart';
export 'src/animations/delete/painters/flying_letters_painter.dart';
export 'src/animations/delete/painters/success_checkmark_painter.dart';
export 'src/animations/delete/painters/trash_bin_painter.dart';

// Logout Animation Module
export 'src/animations/logout/animated_logout_button.dart';
export 'src/animations/logout/logout_button_controller.dart';
export 'src/animations/logout/logout_button_style.dart';
export 'src/animations/logout/models/logout_letter_exit_data.dart';
export 'src/animations/logout/painters/door_exit_painter.dart';
export 'src/animations/logout/painters/exiting_letters_painter.dart';

// Add to Cart Animation Module
export 'src/animations/add_to_cart/animated_add_to_cart_button.dart';
export 'src/animations/add_to_cart/add_to_cart_button_controller.dart';
export 'src/animations/add_to_cart/add_to_cart_button_style.dart';
export 'src/animations/add_to_cart/painters/conveyor_belt_painter.dart';
export 'src/animations/add_to_cart/painters/factory_box_painter.dart';
export 'src/animations/add_to_cart/painters/isometric_box_painter.dart';
export 'src/animations/add_to_cart/painters/shopping_cart_painter.dart';

// Place Order Animation Module
export 'src/animations/place_order/animated_place_order_button.dart';
export 'src/animations/place_order/place_order_button_controller.dart';
export 'src/animations/place_order/place_order_button_style.dart';
export 'src/animations/place_order/painters/order_package_painter.dart';
export 'src/animations/place_order/painters/place_order_idle_icon_painter.dart';
export 'src/animations/place_order/painters/road_line_painter.dart';
export 'src/animations/place_order/painters/top_down_truck_painter.dart';

