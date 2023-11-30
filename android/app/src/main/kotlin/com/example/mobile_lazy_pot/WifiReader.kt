package com.vollebregt.mobile_lazy_pot

import android.net.ConnectivityManager
import android.net.Network
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.EventChannel

class WifiReader(val connectivityManager: ConnectivityManager): EventChannel.StreamHandler, ConnectivityManager.NetworkCallback(){
    private var wifiEventSink: EventChannel.EventSink? = null
    private val runOnUiThread: Handler = Handler(Looper.getMainLooper())

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        wifiEventSink = events
    }

    override fun onCancel(arguments: Any?) {
        wifiEventSink = null
        runOnUiThread.post { wifiEventSink!!.success(false)}
    }

    @RequiresApi(Build.VERSION_CODES.N)
    override fun onAvailable(network: Network) {
        super.onAvailable(network)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            // To make sure that requests don't go over mobile data
            connectivityManager.bindProcessToNetwork(network)
            runOnUiThread.post { wifiEventSink!!.success(true)}
        } else {
            //connectivityManager.setProcessDefaultNetwork(network)
        }
    }

    override fun onUnavailable() {
        super.onUnavailable()
        runOnUiThread.post { wifiEventSink!!.success(false)}
    }

    @RequiresApi(Build.VERSION_CODES.M)
    override fun onLost(network: Network) {
        super.onLost(network)
        // This is to stop the looping request for OnePlus & Xiaomi models
        runOnUiThread.post { wifiEventSink!!.success(false)}
        connectivityManager.bindProcessToNetwork(null)
        connectivityManager.unregisterNetworkCallback(this)
        // Here you can have a fallback option to show a 'Please connect manually' page with an Intent to the Wifi settings
    }

}