#!/usr/bin/env bash
set -e

# This script restructures the nurseconnect_patient package to follow best practices:
# - Converts BLoC feature folders to independent libraries with barrel exports
# - Updates screen and router imports to use the new barrel files
# Run this from the project root (next to lib/)

# 1. Restructure each feature's BLoC
for feature_dir in lib/features/*; do
  feature=$(basename "$feature_dir")
  bloc_dir="$feature_dir/presentation/bloc"
  if [ -d "$bloc_dir" ]; then
    echo "Processing feature: $feature"
    # Remove old barrel file
    rm -f "$bloc_dir/bloc.dart"
    # Remove any 'part of' declarations from event/state
    for f in "$bloc_dir/${feature}_event.dart" "$bloc_dir/${feature}_state.dart"; do
      [ -f "$f" ] && sed -i '' "/^part of /d" "$f"
    done
    # Create new barrel file
    barrel="$bloc_dir/${feature}_bloc_barrel.dart"
    cat > "$barrel" << EOF
export '${feature}_event.dart';
export '${feature}_state.dart';
export '${feature}_bloc.dart';
EOF
    echo "  -> Created barrel: $barrel"
  fi
done

# 2. Update all Dart files (excluding bloc folder) to import barrels instead of event/state parts
find lib -type f -name "*.dart" ! -path "*/presentation/bloc/*" | while read file; do
  changed=false
  for feature in home profile history; do
    pattern_event="features/$feature/presentation/bloc/${feature}_event.dart"
    pattern_state="features/$feature/presentation/bloc/${feature}_state.dart"
    barrel_imp="package:nurseconnect_patient/features/$feature/presentation/bloc/${feature}_bloc_barrel.dart"
    if grep -q "$pattern_event" "$file"; then
      sed -i '' "s|import 'package:nurseconnect_patient/$pattern_event';|import '$barrel_imp';|g" "$file"
      changed=true
    fi
    if grep -q "$pattern_state" "$file"; then
      sed -i '' "s|import 'package:nurseconnect_patient/$pattern_state';|import '$barrel_imp';|g" "$file"
      changed=true
    fi
  done
  [ "$changed" = true ] && echo "  -> Updated imports in $file"
done

echo "✅ Restructuring complete. Next steps:"
echo " 1) Remove any remaining 'part of' lines in generated files if necessary."
echo " 2) Adjust DI, domain interfaces, and other code per best practices manually."
echo " 3) Run: flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs && flutter run"
