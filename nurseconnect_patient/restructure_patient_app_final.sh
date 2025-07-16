#!/usr/bin/env bash
set -e

# Run from project root (next to lib/)

echo "🔄 Restructuring BLoC libraries to use barrel exports..."
features=(home history profile select_service payment)
for feature in "${features[@]}"; do
  base="lib/features/${feature}/presentation/bloc"
  if [ -d "$base" ]; then
    echo "✔ Processing $feature"
    # Remove part directives
    find "$base" -type f -name "*.dart" -exec sed -i '' "/^part of /d" {} +
    find "$base" -type f -name "*.dart" -exec sed -i '' "/^part '/d" {} +
    # Recreate barrel file (bloc.dart)
    cat > "$base/bloc.dart" << EOF
export '${feature}_event.dart';
export '${feature}_state.dart';
export '${feature}_bloc.dart';
EOF
  fi
done

echo "🔄 Updating screens and router imports to use BLoC barrels..."
# Profile screens and router
screens=(
  "lib/features/profile/presentation/screens/edit_profile_screen.dart"
  "lib/features/profile/presentation/screens/profile_screen.dart"
  "lib/features/profile/presentation/screens/privacy_settings_screen.dart"
  "lib/features/profile/presentation/screens/activity_log_screen.dart"
  "lib/core/router/app_router.dart"
)
for file in "${screens[@]}"; do
  echo "  • $file"
  sed -i '' -E \
    -e "s|import .*profile_event\.dart';|import 'package:nurseconnect_patient/features/profile/presentation/bloc/bloc.dart';|g" \
    -e "s|import .*profile_state\.dart';|import 'package:nurseconnect_patient/features/profile/presentation/bloc/bloc.dart';|g" \
    "$file"
done

# History screen
hist="lib/features/history/presentation/screens/patient_service_history_screen.dart"
echo "  • $hist"
sed -i '' -E "s|import .*history_state\.dart';|import 'package:nurseconnect_patient/features/history/presentation/bloc/bloc.dart';|g" "$hist"

# Select-service confirmation screen
sel="lib/features/select_service/presentation/screens/service_confirmation_screen.dart"
echo "  • $sel"
sed -i '' -E \
  -e "s|import .*home/presentation/bloc/bloc.dart';|import 'package:nurseconnect_patient/features/select_service/presentation/bloc/bloc.dart';|g" \
  "$sel"

# Add Dartz & Failure imports to nursing service repo
echo "🔄 Injecting missing imports in nursing_service_repository..."
sed -i '' "1 i\\
import 'package:dartz/dartz.dart';\\
import 'package:nurseconnect_shared/core/error/failures.dart';\\
" lib/features/select_service/domain/repositories/nursing_service_repository.dart

# Implement toMap override in generated PaymentMethodImpl
echo "🔄 Adding toMap override in PaymentMethodImpl..."
payment_file="../nurseconnect_shared/lib/models/payment_method.freezed.dart"
if [ -f "$payment_file" ]; then
  sed -i '' "/class _\\\\$PaymentMethodImpl implements _PaymentMethod {/a\\
  @override\\
  Map<String, dynamic> toMap() {\\
    return this.toJson();\\
  }" "$payment_file"
fi

echo "✅ Restructuring complete. Next: flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs && flutter run"
