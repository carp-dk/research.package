package dk.carp.research_package_example

import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity rather than FlutterActivity: Health Connect asks for
// permissions through an AndroidX activity result contract, which needs a
// FragmentActivity host on Android 14 and later.
class MainActivity : FlutterFragmentActivity()
