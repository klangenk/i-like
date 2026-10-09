package com.ilike.i_like

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.media.MediaMetadata
import android.media.session.MediaSessionManager
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "com.ilike.i_like/shortcuts"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialShortcut" -> {
                        result.success(
                            if (intent?.getBooleanExtra("quick_add", false) == true) "quick_add" else null
                        )
                    }
                    "getNowPlaying" -> {
                        val enabled = NotificationManagerCompat
                            .getEnabledListenerPackages(this)
                            .contains(packageName)
                        if (!enabled) {
                            result.success(mapOf("error" to "permission_denied"))
                            return@setMethodCallHandler
                        }
                        val msm = getSystemService(Context.MEDIA_SESSION_SERVICE)
                                as MediaSessionManager
                        val cn = ComponentName(this, NowPlayingService::class.java)
                        val sessions = msm.getActiveSessions(cn)
                        val streamingPackages = setOf(
                            "com.netflix.mediaclient",
                            "com.amazon.avod.thirdpartyclient",
                            "com.google.android.youtube",
                            "com.disney.disneyplus",
                            "com.hbo.hbonow"
                        )
                        val session = sessions.firstOrNull { it.packageName in streamingPackages }
                            ?: sessions.firstOrNull()
                        val meta = session?.metadata
                        val title = meta?.getString(MediaMetadata.METADATA_KEY_TITLE)
                            ?: meta?.getString(MediaMetadata.METADATA_KEY_DISPLAY_TITLE)
                        result.success(
                            if (title != null) mapOf("title" to title) else mapOf("error" to "nothing_playing")
                        )
                    }
                    "openNotificationSettings" -> {
                        startActivity(Intent(Settings.ACTION_NOTIFICATION_LISTENER_SETTINGS))
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (intent.getBooleanExtra("quick_add", false)) {
            flutterEngine?.dartExecutor?.binaryMessenger?.let {
                MethodChannel(it, channel).invokeMethod("onQuickAdd", null)
            }
        }
    }
}
