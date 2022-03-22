package vegas.caleb.flutter_ble_test

import io.flutter.embedding.android.FlutterActivity
import android.Manifest
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import android.content.ContextWrapper
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
    private val CHANNEL = "b1.wegnerworks.com/requestBTPermissions"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            // Note: this method is invoked on the main thread.
            if (call.method == "requestBTPermissions") {
                _requestBTPermissions()
            } else {
                result.notImplemented()
            }
        }
    }

    private fun _requestBTPermissions() {
        val ctx = ContextWrapper(getApplicationContext())
        val REQUEST_BT_PERMISSIONS = 1452
        if (
                ContextCompat.checkSelfPermission(ctx, Manifest.permission.ACCESS_COARSE_LOCATION) !== PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(ctx, Manifest.permission.BLUETOOTH) !== PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(ctx, Manifest.permission.BLUETOOTH_SCAN) !== PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(ctx, Manifest.permission.BLUETOOTH_ADMIN) !== PackageManager.PERMISSION_GRANTED
                || ContextCompat.checkSelfPermission(ctx, Manifest.permission.BLUETOOTH_CONNECT) !== PackageManager.PERMISSION_GRANTED
        ) {
            ActivityCompat.requestPermissions(
                    this,
                    arrayOf<String>(
                            Manifest.permission.ACCESS_COARSE_LOCATION,
                            Manifest.permission.BLUETOOTH,
                            Manifest.permission.BLUETOOTH_SCAN,
                            Manifest.permission.BLUETOOTH_ADMIN,
                            Manifest.permission.BLUETOOTH_CONNECT
                    ),
                    REQUEST_BT_PERMISSIONS
            )
        }
    }
}
