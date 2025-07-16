#!/usr/bin/env bash
# Fix remaining BLoC part/export issues in nurseconnect_patient
# Run from the project root (same level as lib/)
set -e

# Detect every feature that has a presentation/bloc directory
bloc_dirs=$(find lib/features -type d -path "*/presentation/bloc")

echo "📦 Converting all feature blocs to standalone libraries + barrel..."
for dir in $bloc_dirs; do
  feature=$(basename $(dirname "$dir"))      # e.g. home, history, profile
  echo "  • $feature"

  bloc_file="$dir/${feature}_bloc.dart"
  event_file="$dir/${feature}_event.dart"
  state_file="$dir/${feature}_state.dart"
  barrel="$dir/bloc.dart"                 # unified barrel name

  # 1. Replace part directives with imports in bloc implementation
  if [ -f "$bloc_file" ]; then
    sed -i '' \
      -e "s|part '${feature}_event.dart';|import '${feature}_event.dart';|" \
      -e "s|part '${feature}_state.dart';|import '${feature}_state.dart';|" \
      "$bloc_file"
  fi

  # 2. Remove any lingering `part of` lines in event/state files
  for f in "$event_file" "$state_file"; do
    [ -f "$f" ] && sed -i '' "/^part of /d" "$f"
  done

  # 3. Re-create barrel that exports the three public libs
  cat > "$barrel" << EOF
export '${feature}_event.dart';
export '${feature}_state.dart';
export '${feature}_bloc.dart';
EOF

done

# Function to replace old direct imports with barrel import
replace_with_barrel() {
  local file=$1
  local feature=$2
  local barrel_path="package:nurseconnect_patient/features/${feature}/presentation/bloc/bloc.dart"
  sed -i '' -E \
    -e "s|import 'package:nurseconnect_patient/features/${feature}/presentation/bloc/${feature}_event.dart';|import '${barrel_path}';|g" \
    -e "s|import 'package:nurseconnect_patient/features/${feature}/presentation/bloc/${feature}_state.dart';|import '${barrel_path}';|g" "$file"
}

# 4. Update imports in all non-bloc Dart files
find lib -type f -name "*.dart" ! -path "*/presentation/bloc/*" | while read dart_file; do
  for dir in $bloc_dirs; do
    feat=$(basename $(dirname "$dir"))
    replace_with_barrel "$dart_file" "$feat"
  done
done

# 5. Inject missing Dartz/Failure imports in nursing_service repo (idempotent)
repo_file="lib/features/select_service/domain/repositories/nursing_service_repository.dart"
if [ -f "$repo_file" ]; then
  grep -q "package:dartz/dartz.dart" "$repo_file" || sed -i '' "1 i\\
import 'package:dartz/dartz.dart';\\
import 'package:nurseconnect_shared/core/error/failures.dart';\\
" "$repo_file"
fi

# 6. Ensure PaymentMethodImpl overrides toMap()
payment_impl="../nurseconnect_shared/lib/models/payment_method.freezed.dart"
if [ -f "$payment_impl" ]; then
  grep -q "Map<String, dynamic> toMap()" "$payment_impl" || sed -i '' "/class _\\\\$PaymentMethodImpl implements _PaymentMethod {/a\\
  @override\\
  Map<String, dynamic> toMap() {\\
    return this.toJson();\\
  }" "$payment_impl"
fi

echo "✅ BLoC library conversion complete!"
echo "Next steps:"
echo "  flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs && flutter run"