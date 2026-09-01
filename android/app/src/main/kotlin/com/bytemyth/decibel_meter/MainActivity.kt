package com.bytemyth.decibel_meter

import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // Android 15+ 默认无边框；此调用让更低版本也启用，并满足 Play 的静态检查。
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
    }
}
