import 'package:flutter/material.dart';
import 'package:safe_women/contacts/database_helper.dart';

class EditNumber extends StatefulWidget {
  final id;

  EditNumber({this.id});

  static Future<void> show(BuildContext context, {int id}) async {
    await Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => EditNumber(
          id: id,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditNumberState createState() => _EditNumberState();
}

class _EditNumberState extends State<EditNumber> {
  final _formKey = GlobalKey<FormState>();
  int updateNumber;
  int number;
  String updateName;
  String name;
  bool submitEnabled = false;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _update() async {
    if (_validateAndSaveForm()) {
      try {
        int updateId = await DatabaseHelper.instance.update({
          DatabaseHelper.columnId: widget.id,
          DatabaseHelper.columnName: '$updateNumber',
          DatabaseHelper.column2Name: '$updateName',
        });
        print(updateId);
        Navigator.popAndPushNamed(context, '/numberScreen');
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
          iconTheme: IconThemeData(color: Colors.black54),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          toolbarHeight: 100.0,
          title: Text(
            'Edit Number',
            style: TextStyle(color: Colors.black54, fontSize: 30),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(

                        blurRadius: 17,
                        offset: Offset(5, 5),
                        color: Colors.white,
                      ),
                      BoxShadow(

                        blurRadius: 20,
                        offset: Offset(10.5, 10.5),
                        color: Color(0xff43a047),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Column(
                          children: [
                            Theme(
                              data: Theme.of(context).copyWith(primaryColor: Color(0xff43a047)),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                onChanged: (Contactname) {
                                  name = Contactname;
                                  _updateState();
                                },
                                decoration: new InputDecoration(
                                  icon: Icon(Icons.contacts),
                                  labelText: "Name",
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  // fillColor: Colors.green
                                ),
                                onSaved: (value) {
                                  updateName = value;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Theme(
                              data: Theme.of(context).copyWith(primaryColor: Color(0xff43a047)),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                onChanged: (phoneNumber) {
                                  number = int.tryParse(phoneNumber);
                                  _updateState();
                                },
                                decoration: new InputDecoration(
                                  icon: Icon(Icons.perm_phone_msg),
                                  labelText: "Phone Number",
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  // fillColor: Colors.green
                                ),
                                onSaved: (value) {
                                  updateNumber = int.tryParse(value);
                                },
                              ),
                            ),

                            SizedBox(height: 20,),
                            OutlineButton(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Update',style: TextStyle(fontSize: 18,color: submitEnabled ? Color(0xff43a047): Colors.greenAccent[500],),),
                              ),
                              borderSide: BorderSide(color: Color(0xff43a047)),
                              highlightColor: Colors.green,
                              color: submitEnabled ? Color(0xff43a047): Colors.greenAccent[500],
                              onPressed: submitEnabled ? _update : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                  ),
                ),
                SizedBox(height: 40,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateState() {
    setState(() {
      if (number.toString().length == 10 && name != null) {
        submitEnabled = true;
      } else {
        submitEnabled = false;
      }
    });
  }
}
