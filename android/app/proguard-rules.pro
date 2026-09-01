# App-specific R8 rules.
# Flutter Gradle 插件已经注入：
#   - proguard-android-optimize.txt（含 native / Parcelable CREATOR 等默认规则）
#   - flutter_proguard_rules.pro（仅保留 FlutterPlugin 实现，且允许缩减与混淆）
# 不要再用 `-keep class ** { *; }` 盖掉上述规则，否则 Play 的优化/混淆/缩减率会掉到约 40%。

# 可选依赖：Flutter embedding 可能引用 Play Core，本应用未打包该库
-dontwarn com.google.android.play.core.tasks.**
-dontwarn com.google.android.play.core.**

# 录音插件：JNI 入口由默认的 native-method keep 保留；不要 keep 整个包
-dontwarn com.llfbandit.record.**

# Play Vitals / 崩溃还原：保留行号，类名仍可混淆
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
