import 'dart:async';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:safe_women/model/user_location_model.dart';
import 'package:safe_women/screen/platform_exception_alert_dialog.dart';

class LocationService {
  UserLocation currentLocation;

  Future<UserLocation> getLocation() async {
    try {
      var position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentLocation = UserLocation(longitude: position.longitude,lattitude: position.latitude);
    } on PlatformException catch(e) {
      throw(e);
    }
    return currentLocation;
  }

  Future<bool> checkLocation() async{
    return await Geolocator().isLocationServiceEnabled();
  }

}
