package com.vollebregt.mobile_lazy_pot

import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.net.wifi.WifiNetworkSpecifier
import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val WIFIMETHODCHANNEL = "com.lazypot/wifi_service_method"
    private val WIFIEVENTCHANNEL = "com.lazypot/wifi_service_event"
    private lateinit var connectivityManager: ConnectivityManager
    private lateinit var wifiReaderCallback: WifiReader

    @RequiresApi(Build.VERSION_CODES.Q)
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        wifiReaderCallback = WifiReader(connectivityManager)

        startEventChannel(flutterEngine.dartExecutor.binaryMessenger)
        startMethodChannels(flutterEngine.dartExecutor.binaryMessenger)
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    fun startMethodChannels(messenger: BinaryMessenger) {
        MethodChannel(messenger, WIFIMETHODCHANNEL).setMethodCallHandler {
                call, result ->
            when (call.method) {
                "connect" -> {
                    connectToLazyPotWifi()
                    result.success(true)
                }
                "disconnect" -> {
                    disconnectFromLazyPotWifi()
                    result.success(true)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    // method not called inspite of calling from configureFlutterEngine
    fun startEventChannel(messenger: BinaryMessenger) {
        val eventChannel = EventChannel(messenger, WIFIEVENTCHANNEL);
        eventChannel.setStreamHandler(wifiReaderCallback)
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    fun connectToLazyPotWifi() {
        val wifiNetworkSpecifier = WifiNetworkSpecifier.Builder()
            .setSsid("LazypotWifi")
            .build()

        val networkRequest = NetworkRequest.Builder()
            .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
            .setNetworkSpecifier(wifiNetworkSpecifier)
            .build()

        connectivityManager.requestNetwork(networkRequest, wifiReaderCallback)
    }

    @RequiresApi(Build.VERSION_CODES.Q)
    fun disconnectFromLazyPotWifi() {
        connectivityManager.bindProcessToNetwork(null)
        connectivityManager.unregisterNetworkCallback(wifiReaderCallback)

    }
}
