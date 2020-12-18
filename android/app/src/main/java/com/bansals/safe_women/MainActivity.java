package com.bansals.safe_women;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.telephony.SmsManager;
import android.util.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Address;
import android.location.Geocoder;
import android.location.Location;
import android.location.LocationManager;
import android.os.Bundle;

import java.util.List;
import java.util.Locale;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "sendSms";
    private static final String CHANNEL1 = "location";
    private static final String CHANNEL2 = "sendSos";

    Location gps_loc;
    Location network_loc;
    Location final_loc;
    double longitude;
    double latitude;
    String s;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (checkSelfPermission(
                    Manifest.permission.ACCESS_FINE_LOCATION) +
                    checkSelfPermission(
                   Manifest.permission.SEND_SMS)
                    != PackageManager.PERMISSION_GRANTED) {
                if (shouldShowRequestPermissionRationale(
                        Manifest.permission.ACCESS_FINE_LOCATION) || shouldShowRequestPermissionRationale(
                        Manifest.permission.SEND_SMS)) {
                } else {
                    requestPermissions(
                            new String[]{Manifest.permission.ACCESS_FINE_LOCATION,
                                    Manifest.permission.SEND_SMS},
                            0);
                }
            }
        }
       GeneratedPluginRegistrant.registerWith(this);
        new MethodChannel(getFlutterView(), CHANNEL2).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("sendsos")) {
                            String num = call.argument("phone");
                            String msg = call.argument("msg");
                            sendSMS(num, msg, result);
                        } else {
                            result.notImplemented();
                        }
                    }
                });
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("send")) {
                            String num = call.argument("phone");
                            String msg = call.argument("msg");
                            sendSMS(num, msg, result);
                        } else {
                            result.notImplemented();
                        }
                    }
                });
        new MethodChannel(getFlutterView(), CHANNEL1).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        if (call.method.equals("location")) {
                            LocationManager locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
                            try {

                                gps_loc = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
                                network_loc = locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER);

                            } catch (Exception e) {
                                e.printStackTrace();
                                result.error("Err", "Did not get location", "");
                            }

                            if (gps_loc != null) {
                                final_loc = gps_loc;
                                latitude = final_loc.getLatitude();
                                longitude = final_loc.getLongitude();
                                s=String.valueOf(latitude);
                                result.success(s);
                            }
                            else if (network_loc != null) {
                                final_loc = network_loc;
                                latitude = final_loc.getLatitude();
                                longitude = final_loc.getLongitude();
                                s=String.valueOf(latitude);
                                result.success(s);
                            }
                            else {
                                latitude = 0.0;
                                longitude = 0.0;
                            }

                        }
                        else {
                            result.notImplemented();
                        }
                    }
                });
    }

    private void sendSMS(String phoneNo, String msg, MethodChannel.Result result) {
        try {
//            msg = "https://www.google.com/maps/search/?api=1&query="+latitude+","+longitude;
            SmsManager smsManager = SmsManager.getDefault();
            smsManager.sendTextMessage(phoneNo, null, msg, null, null);
            result.success("SMS Sent");
        } catch (Exception ex) {
            ex.printStackTrace();
            result.error("Err", "Sms Not Sent", "");
        }
    }

    private void sendSOS(String phoneNo, String msg, MethodChannel.Result result) {
        try {
//            msg = "I am I TROUBLE HELP ME" +"    "+
//                    "https://www.google.com/maps/search/?api=1&query="+latitude+","+longitude;
            SmsManager smsManager = SmsManager.getDefault();
            smsManager.sendTextMessage(phoneNo, null, msg, null, null);
            result.success("SMS Sent");
        } catch (Exception ex) {
            ex.printStackTrace();
            result.error("Err", "Sms Not Sent", "");
        }
    }


    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case 0: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                    // permission was granted, yay! Do the
                    // contacts-related task you need to do.

                } else {

                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                }
                return;
            }

            // other 'case' lines to check for other
            // permissions this app might request.
        }
    }
}