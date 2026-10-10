# google_mlkit_text_recognition references the optional Chinese, Devanagari,
# Japanese and Korean recognizers. The app only bundles the Latin model, so
# tell R8 these classes are intentionally absent.
-dontwarn com.google.mlkit.vision.text.chinese.**
-dontwarn com.google.mlkit.vision.text.devanagari.**
-dontwarn com.google.mlkit.vision.text.japanese.**
-dontwarn com.google.mlkit.vision.text.korean.**
