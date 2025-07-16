{\rtf1\ansi\ansicpg1252\cocoartf2822
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 #!/usr/bin/env bash\
set -e\
\
# Run this from project root (next to lib/)\
\
echo "Applying fixes across nurseconnect_patient package..."\
\
# 1. Convert part directives to exports in all bloc barrel files\
find lib/features -type f -path "*/presentation/bloc/bloc.dart" \\\
  -exec sed -i '' -E \\\
    -e "s|part '([a-z_]+_event\\.dart)';|export '\\1';|g" \\\
    -e "s|part '([a-z_]+_state\\.dart)';|export '\\1';|g" \\\
    -e "s|part '([a-z_]+_bloc\\.dart)';||g" \\\
  \{\} +\
\
# 2. Remove any remaining `part of` declarations in event/state files\
echo "Removing part-of from event/state files..."\
find lib/features -type f \\( -name "*_event.dart" -o -name "*_state.dart" \\) \\\
  -exec sed -i '' "/^part of /d" \{\} +\
\
# 3. Update screens and router to import only bloc.dart\
echo "Updating imports in screens and app_router.dart..."\
find lib/features -type f -path "*/screens/*.dart" -or -path "lib/core/router/app_router.dart" \\\
  -exec sed -i '' -E \\\
    -e "s|import .*bloc/([a-z_]+)_(event|state)\\.dart';|import 'package:nurseconnect_patient/features/\\1/presentation/bloc/bloc.dart';|g" \\\
  \{\} +\
\
# 4. Add missing GeoPoint import in data files\
echo "Injecting Firestore import..."\
find lib/features -type f \\( -name "*repository_impl.dart" -o -name "*remote_data_source.dart" \\) \\\
  -exec grep -L "cloud_firestore" \{\} \\; \\\
  -exec sed -i '' "1 i\\\\import 'package:cloud_firestore/cloud_firestore.dart';\\\\" \{\} +\
\
# 5. Add Dartz & Failure imports in domain interfaces\
echo "Injecting Dartz and Failure imports..."\
find lib/features -type f -path "*/domain/repositories/*.dart" \\\
  -exec grep -L "dartz" \{\} \\; \\\
  -exec sed -i '' "1 i\\\\import 'package:dartz/dartz.dart';\\\\nimport 'package:nurseconnect_shared/core/error/failures.dart';\\\\" \{\} +\
\
# 6. Align Future<T> \uc0\u8594  Future<Either<Failure, T>> in domain\
echo "Aligning return types in domain interfaces..."\
for f in lib/features/*/domain/repositories/*.dart; do\
  sed -i '' -E "s/Future<([^>]+)>/Future<Either<Failure, \\1>>/g" "$f"\
done\
\
# 7. Fix DI registrations to use remoteDataSource: sl()\
echo "Patching DI container..."\
DI="lib/core/dependency_injection/injection_container.dart"\
sed -i '' -E \\\
  -e "s/(RepositoryImpl)\\(firestore:/\\1(remoteDataSource: sl(),/" \\\
  -e "s/(RepositoryImpl)\\(auth:/\\1(remoteDataSource: sl(),/" \\\
  -e "s/(RepositoryImpl)\\(functions:/\\1(remoteDataSource: sl(),/" \\\
  -e "s/(RepositoryImpl)\\(storage:/\\1(remoteDataSource: sl(),/" \\\
  "$DI"\
\
# 8. Clean stray user__selection tags\
echo "Cleaning stray selection tags..."\
grep -Rl "<user__selection>" lib | xargs sed -i '' "s/<user__selection>//g; s/<\\/user__selection>//g"\
\
echo "\uc0\u9989  Automated patch applied. Now run:\\n   flutter clean && flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs && flutter run"}