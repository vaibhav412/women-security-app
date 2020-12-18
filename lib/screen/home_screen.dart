import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_shake_plugin/flutter_shake_plugin.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:safe_women/common/neu_hamburger_button.dart';
import 'package:safe_women/common/sos_button.dart';
import 'package:safe_women/contacts/database_helper.dart';
import 'package:safe_women/model/user_location_model.dart';
import 'package:safe_women/screen/intro_screen.dart';
import 'package:safe_women/screen/platform_alert_dialog.dart';
import 'package:safe_women/screen/platform_exception_alert_dialog.dart';
import 'package:safe_women/services/location_service.dart';
import 'package:sms_maintained/sms.dart';
import 'package:toast/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'platform_alert_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const platform = const MethodChannel('sendSms');
  static const platform1 = const MethodChannel('location');
  static const platform2 = const MethodChannel('sendSos');
  int number;
  Timer timer;
  UserLocation userLocation;
  int phoneNumber1;
  int updateNumber;

  FlutterShakePlugin _shakePlugin;

  List<int> _dropDownItems = [5, 10, 15, 20, 25, 30];

  int _selectedItem = 5;

  final _formKey = GlobalKey<FormState>();

  bool toogleValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _shakePlugin = FlutterShakePlugin(
        onPhoneShaken: () {
          print('Shaking Phone Working');
          sendsosAlert();
        },
        shakeThresholdGravity: 30)
      ..startListening();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer?.cancel();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        int i = await DatabaseHelper.instance
            .insert({DatabaseHelper.columnName: '$phoneNumber1'});
        print(i);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> _update() async {
    if (_validateAndSaveForm()) {
      try {
        int updateId = await DatabaseHelper.instance.update({
          DatabaseHelper.columnId: 1,
          DatabaseHelper.columnName: '$updateNumber',
        });
      } catch (e) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'icons/2.png',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          toolbarHeight: 100,
          title: Text(
            'Women Security',
            style: TextStyle(color: Colors.black54, fontSize: 30),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: [
            NeuHamburgerButton(
              child: Icon(
                Icons.settings,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/numberScreen');
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  LayoutBuilder(
                    builder: (context, constraint) => Container(
                      height: 250,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xfff7f7f7),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 36,
                            color: toogleValue
                                ? Colors.greenAccent[200].withOpacity(1)
                                : Colors.redAccent[100].withOpacity(1),
                            offset: Offset(12, 12),
                          ),
                          BoxShadow(
                            blurRadius: 36,
                            color: Color(0xffffffff),
                            offset: Offset(-12, -12),
                          ),
                        ],
                        gradient: LinearGradient(
                          stops: [0, 1],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xffdedede), Color(0xffffffff)],
                        ),
                      ),

                      // height: 250,
                      // decoration: BoxDecoration(
                      //   color: Color.fromRGBO(227, 237, 247, 1),
                      //   shape: BoxShape.circle,
                      //   boxShadow: [
                      //     BoxShadow(
                      //       spreadRadius: -10,
                      //       blurRadius: 17,
                      //       offset: Offset(5, 5),
                      //       color: Colors.white,
                      //     ),
                      //     BoxShadow(
                      //       spreadRadius: -2,
                      //       blurRadius: 10,
                      //       offset: Offset(10.5, 10.5),
                      //       color: Color.fromRGBO(193, 214, 233, 1),
                      //     )
                      //   ],
                      // ),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 35,
                              ),
                              Align(
                                child: Text(
                                  toogleValue ? 'Tap to stop' : 'Tap to start',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: toogleValue
                                        ? Colors.green[900].withOpacity(1)
                                        : Colors.red[500].withOpacity(1),
                                  ),
                                ),
                              ),
                              Align(
                                  child: Text(
                                'Location Stream ',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: toogleValue
                                      ? Colors.green[900].withOpacity(1)
                                      : Colors.red[500].withOpacity(1),
                                ),
                              )),
                            ],
                          ),
                          Center(
                            child: InkWell(
                              onTap: () => toggleButton(context),
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 1000),
                                height: 60.0,
                                width: 200.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: toogleValue
                                      ? Colors.greenAccent[100]
                                      : Colors.redAccent[100].withOpacity(0.5),
                                ),
                                child: Stack(
                                  children: [
                                    AnimatedPositioned(
                                      duration: Duration(milliseconds: 1000),
                                      curve: Curves.easeIn,
                                      top: 3.0,
                                      left: toogleValue ? 130.0 : 0.0,
                                      right: toogleValue ? 0.0 : 130.0,
                                      child: AnimatedSwitcher(
                                        duration: Duration(milliseconds: 1000),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          return RotationTransition(
                                            child: child,
                                            turns: animation,
                                          );
                                        },
                                        child: toogleValue
                                            ? Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                                size: 55.0,
                                                key: UniqueKey(),
                                              )
                                            : Icon(Icons.remove_circle_outline,
                                                color: Colors.red,
                                                size: 55.0,
                                                key: UniqueKey()),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                DropdownButton(
                                  value: _selectedItem,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedItem = value;
                                    });
                                  },
                                  items: _dropDownItems.map((int value) {
                                    return DropdownMenuItem<int>(
                                      child: Text('$value min'),
                                      value: value,
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  NeuStartButton(
                    onPressed: () async {
                      await sendsosAlert();
                    },
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset('icons/girl.png', scale: 4),
            ),
          ],
        ),
      ),
    );
  }

  Future<List> getData() async {
    List<Map<String, dynamic>> queryRows =
        await DatabaseHelper.instance.queryAll();
    return queryRows;
  }

  toggleButton(BuildContext context) {
    setState(() {
      toogleValue = !toogleValue;
      print(toogleValue);
      if (toogleValue) {
        startMessage(context);
      } else {
        timer?.cancel();
      }
    });
  }

  sendsosAlert() async {
    LocationService locationService = new LocationService();
    if (await locationService.checkLocation()) {
      try {
        userLocation = await locationService.getLocation();
        print(userLocation.lattitude);
        List<MyCategoryFinal> data = await DatabaseHelper.instance.getSQL();
        print(data.length);
        if (data.length != 0) {
          for (int i = 0; i < data.length; i++) {
            print('sendSOSALERT');
            sendsosSMS('${data[i].phoneNumber}',
                "HelpMe ${userLocation.lattitude} and ${userLocation.longitude}");
          }
        } else {
          await PlatformAlertDialog(
              title: 'Failed',
              content: 'Aleast One Number is required',
              defaultActionText: 'OK',
              onPressed: () {
                Navigator.of(context).pop(false);
                setState(() {
                  toogleValue = false;
                });
              }).show(context);
        }
      } on PlatformException catch (e) {
        if (e.code == 'ERROR_ALREADY_REQUESTING_PERMISSIONS') {
          PlatformAlertDialog(
              title: 'Locaion Acess Failed',
              content: 'Permission denied- please enable it from app settings',
              defaultActionText: 'OK',
              onPressed: () {
                Navigator.of(context).pop(true);
                setState(() {
                  toogleValue = false;
                });
              }).show(context);
        } else {
          PlatformExceptionAlertDialog(
            title: 'Failed',
            exception: e,
            onPressed: () {
              Navigator.of(context).pop(true);
              setState(() {
                toogleValue = false;
              });
            },
          ).show(context);
        }
      }
    } else {
      PlatformAlertDialog(
        title: 'Failed',
        content: 'Location Service Disabled',
        defaultActionText: 'OK',
        onPressed: () {
          Navigator.of(context).pop(true);
          setState(() {
            toogleValue = false;
          });
        },
      ).show(context);
    }
  }

  void sendsosSMS(String phoneNumber, String msgText) async {
    print('sos');
    if (await Permission.phone.status.isUndetermined) {
      PlatformAlertDialog(
          title: 'Phone Call Acess Failed',
          content: 'Permission denied- please enable it from app settings',
          defaultActionText: 'OK',
          onPressed: () {
            Navigator.of(context).pop(true);
          }).show(context);
    } else {
      SmsMessage msg = new SmsMessage(phoneNumber, msgText);
      final SmsSender sender = new SmsSender();
      msg.onStateChanged.listen((state) {
        if (state == SmsMessageState.Sending) {
          return Toast.show('Sending Alert...', context,
              duration: 1, backgroundColor: Colors.blue, backgroundRadius: 5);
        } else if (state == SmsMessageState.Sent) {
          return Toast.show('Alert Sent Successfully!', context,
              duration: 3, backgroundColor: Colors.green, backgroundRadius: 5);
        } else if (state == SmsMessageState.Fail) {
          return Toast.show(
              'Failure! Check your credits & Network Signals!', context,
              duration: 5, backgroundColor: Colors.red, backgroundRadius: 5);
        } else {
          return Toast.show('Failed to send SMS. Try Again!', context,
              duration: 5, backgroundColor: Colors.red, backgroundRadius: 5);
        }
      });
      try {
        sender.sendSms(msg);
      } catch (e) {
        print(e.toString());
      }
    }
  }

  Future<void> startMessage(BuildContext context) async {
    timer = Timer.periodic(Duration(seconds: _selectedItem), (Timer t) async {
      await userData(context);
    });
  }

  Future<void> userData(BuildContext context) async {
    var location = Provider.of<LocationService>(context, listen: false);
    if (await location.checkLocation()) {
      try {
        print('hello');
        userLocation = await location.getLocation();
        print(userLocation.lattitude);
        await sendSms();
      } on PlatformException catch (e) {
        timer?.cancel();
        if (e.code == 'ERROR_ALREADY_REQUESTING_PERMISSIONS') {
          PlatformAlertDialog(
              title: 'Locaion Acess Failed',
              content: 'Permission denied- please enable it from app settings',
              defaultActionText: 'OK',
              onPressed: () {
                Navigator.of(context).pop(true);
                setState(() {
                  toogleValue = false;
                });
              }).show(context);
        } else {
          PlatformExceptionAlertDialog(
            title: 'Failed',
            exception: e,
            onPressed: () {
              Navigator.of(context).pop(true);
              setState(() {
                toogleValue = false;
              });
            },
          ).show(context);
        }
      }
    } else {
      timer?.cancel();
      PlatformAlertDialog(
        title: 'Failed',
        content: 'Location Service Disabled',
        defaultActionText: 'OK',
        onPressed: () {
          Navigator.of(context).pop(true);
          setState(() {
            toogleValue = false;
          });
        },
      ).show(context);
    }
  }

  Future<void> sendSms() async {
    List<MyCategoryFinal> data = await DatabaseHelper.instance.getSQL();
    print(data.length);
    if (data.length != 0) {
      for (int i = 0; i < data.length; i++) {
        print("SendSMS");
        try {
          final String result =
              await platform.invokeMethod('send', <String, dynamic>{
            "phone": "+91" + "${data[i].phoneNumber}",
            "msg":
                "Hello! Vasu ${userLocation.lattitude} , longitude = ${userLocation.longitude}"
          }); //Replace a 'X' with 10 digit phone number
          print(result);
        } on PlatformException catch (e) {
          timer?.cancel();
          if (e.code == 'Err') {
            PlatformAlertDialog(
              title: 'SMS Failed',
              content: 'Permission denied- please enable it from app settings',
              defaultActionText: 'OK',
              onPressed: () {
                Navigator.of(context).pop(true);
                setState(() {
                  toogleValue = false;
                });
              },
            ).show(context);
          } else {
            PlatformExceptionAlertDialog(
              title: 'SMS Failed',
              exception: e,
              onPressed: () {
                Navigator.of(context).pop(true);
                setState(() {
                  toogleValue = false;
                });
              },
            ).show(context);
          }
        }
      }
    } else {
      timer?.cancel();
      await PlatformAlertDialog(
          title: 'Failed',
          content: 'Aleast One Number is required',
          defaultActionText: 'OK',
          onPressed: () {
            Navigator.of(context).pop(false);
            setState(() {
              toogleValue = false;
            });
          }).show(context);
    }
  }

  Future<void> sendSOS() async {
    List<MyCategoryFinal> data = await DatabaseHelper.instance.getSQL();
    print(data.length);
    if (data.length != 0) {
      for (int i = 0; i < data.length; i++) {
        print("SendSMS");
        try {
          final String result =
              await platform2.invokeMethod('sendsos', <String, dynamic>{
            "phone": "+91" + "${data[i].phoneNumber}",
            "msg":
                "THis is SOS SIgnal ${userLocation.lattitude} , longitude = ${userLocation.longitude}"
          }); //Replace a 'X' with 10 digit phone number
          print(result);
        } on PlatformException catch (e) {
          timer?.cancel();
          if (e.code == 'Err') {
            PlatformAlertDialog(
              title: 'SMS Failed',
              content: 'Permission denied- please enable it from app settings',
              defaultActionText: 'OK',
              onPressed: () {
                Navigator.of(context).pop(true);
                setState(() {
                  toogleValue = false;
                });
              },
            ).show(context);
          } else {
            PlatformExceptionAlertDialog(
              title: 'SMS Failed',
              exception: e,
              onPressed: () {
                Navigator.of(context).pop(true);
                setState(() {
                  toogleValue = false;
                });
              },
            ).show(context);
          }
        }
      }
    } else {
      timer?.cancel();
      await PlatformAlertDialog(
          title: 'Failed',
          content: 'Aleast One Number is required',
          defaultActionText: 'OK',
          onPressed: () {
            Navigator.of(context).pop(false);
            setState(() {
              toogleValue = false;
            });
          }).show(context);
    }
  }

// Future<void> location() async {
//   print("location");
//   try {
//     final String result = await platform1.invokeMethod(
//       'location',
//     ); //Replace a 'X' with 10 digit phone number
//     print(result);
//   } on PlatformException catch (e) {
//     print(e.toString());
//   }
// }
}
