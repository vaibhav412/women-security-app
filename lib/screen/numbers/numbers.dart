import 'dart:async';

import 'package:flutter/material.dart';
import 'package:safe_women/common/neu_hamburger_button.dart';
import 'package:safe_women/contacts/database_helper.dart';
import 'package:safe_women/screen/numbers/add_number.dart';
import 'package:safe_women/screen/numbers/numbers_tile.dart';
import 'package:safe_women/screen/platform_alert_dialog.dart';

import '../../contacts/database_helper.dart';
import 'numbers_tile.dart';
import 'numbers_tile.dart';

class NumbersPage extends StatefulWidget {
  @override
  _NumbersPageState createState() => _NumbersPageState();
}

class _NumbersPageState extends State<NumbersPage> {
  int phoneNumberCount;

  // Future<void> getNumbers() async {
  //   for (int i = 0; i < widget.numbers.length; i++) {
  //     final number = NumbersTile(
  //       phoneNumber: widget.numbers[i]['phonenumber'],
  //       i: i + 1,
  //     );
  //     numbers.add(number);
  //   }
  // }
  Future<int> getData() async {
    List<Map<String, dynamic>> queryRows =
        await DatabaseHelper.instance.queryAll();
    return queryRows.length;
  }

  // AppBar(
  // toolbarHeight: 100,
  // title: Text(
  // 'Women Security',
  // style: TextStyle(color: Colors.black54,fontSize: 30),
  // ),
  // backgroundColor: Color.fromRGBO(215, 229, 243, 1),
  // elevation: 0.0,
  // actions: [
  // NeuHamburgerButton(),
  // ],
  // ),

  @override
  Widget build(BuildContext context) {
    print('HI I am Printed');
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
          iconTheme: IconThemeData(color: Colors.black54),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 100.0,
          title: Text(
            'Numbers',
            style: TextStyle(color: Colors.black54, fontSize: 30),
          ),
          actions: [
            NeuHamburgerButton(
              child: Icon(
                Icons.add,
              ),
              onPressed: () async {
                int length = await getData();
                if (length >= 4) {
                  await PlatformAlertDialog(
                    title: 'Failed',
                    content: 'Maximum added number reached',
                    defaultActionText: 'OK',
                    onPressed: () => Navigator.of(context).pop(false),
                  ).show(context);
                } else {
                  AddNumber.show(context);
                }
              },
            ),
            // IconButton(
            //   icon: Icon(Icons.add),
            //   onPressed: ()async {
            //     int length = await getData();
            //     if(length >= 4){
            //      await PlatformAlertDialog(
            //        title: 'Failed',
            //        content: 'Maximum added number reached',
            //        defaultActionText: 'OK',
            //        onPressed: () => Navigator.of(context).pop(false),
            //      ).show(context);
            //     }else{
            //     AddNumber.show(context);
            //     }
            //   },
            // ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xffffffff),
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  offset: Offset(-10,-10),
                  color: Color(0xffffffff),
                ),
                BoxShadow(
                  blurRadius: 20,
                  offset: Offset(10, 10),
                  color: Colors.teal,
                )
              ],
            ),
            child: FutureBuilder(
             future: DatabaseHelper.instance.getSQL(),
             builder:
                 (BuildContext context, AsyncSnapshot snapshot) {
               print(snapshot.data);
               if (snapshot.data == null) {
                 return Container(
                     child: Center(child: Text("Loading...")));
               } else {
                 return ListView.builder(
                   itemCount: snapshot.data.length,
                   itemBuilder: (BuildContext context, int index) {
                     return NumbersTile(
                       id: snapshot.data[index].id,
                       name: snapshot.data[index].name,
                       phoneNumber: snapshot.data[index].phoneNumber,
                     );
                   },
                 );
               }
             },
                          ),
          ),
        ),
      ),
    );
  }
}
// ListView(
// children: numbers,
