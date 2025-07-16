#!/usr/bin/env bash
set -e

# 1. Fix Home BLoC barrel to use part directives
sed -i '' \
  -e "s/export 'home_event.dart';/part 'home_event.dart';/" \
  -e "s/export 'home_state.dart';/part 'home_state.dart';/" \
  lib/features/home/presentation/bloc/bloc.dart

# 2. Replace direct imports of event/state parts with the bloc barrel
screens=(
  "lib/features/profile/presentation/screens/edit_profile_screen.dart"
  "lib/features/profile/presentation/screens/profile_screen.dart"
  "lib/features/profile/presentation/screens/privacy_settings_screen.dart"
  "lib/features/profile/presentation/screens/activity_log_screen.dart"
  "lib/core/router/app_router.dart"
)
for file in "${screens[@]}"; do
  sed -i '' \
    -e "s|import 'package:nurseconnect_patient/features/profile/presentation/bloc/profile_event.dart';|import 'package:nurseconnect_patient/features/profile/presentation/bloc/bloc.dart';|" \
    -e "s|import 'package:nurseconnect_patient/features/profile/presentation/bloc/profile_state.dart';|import 'package:nurseconnect_patient/features/profile/presentation/bloc/bloc.dart';|" \
    "$file"
done

# 3. Implement toMap override in PaymentMethodImpl (in shared package)
payment_file="../nurseconnect_shared/lib/models/payment_method.freezed.dart"
if [ -f "$payment_file" ]; then
  sed -i '' "/class _\\\$PaymentMethodImpl implements _PaymentMethod {/a\\
  @override\\
  Map<String, dynamic> toMap() {\\
    return this.toJson();\\
  }" "$payment_file"
fi

echo "🔧 Manual fixes applied. Please run:"
echo "   flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs && flutter run"
