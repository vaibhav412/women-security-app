import 'package:flutter/material.dart';
import 'package:safe_women/contacts/database_helper.dart';

class AddNumber extends StatefulWidget {
  static void show(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(
        builder: (context) => AddNumber(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddNumberState createState() => _AddNumberState();
}

class _AddNumberState extends State<AddNumber> {
  final _formKey = GlobalKey<FormState>();
  int addNumber;
  String addName;
  int phonenumber;
  String Contactname;
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
        int i = await DatabaseHelper.instance.insert({
          DatabaseHelper.columnName: '$addNumber',
          DatabaseHelper.column2Name: '$addName'
        });
        print(i);
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
            'Add Number',
            style: TextStyle(color: Colors.black54, fontSize: 30),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(-10,-10),
                        color: Colors.white,
                      ),
                      BoxShadow(
                        blurRadius: 20,
                        offset: Offset(10, 10),
                        color: Colors.orange[200],
                      )

                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Theme(
                                  data: Theme.of(context)
                                      .copyWith(primaryColor: Colors.orange[900]),
                                  child: TextFormField(
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
                                    onChanged: (name) {
                                      Contactname = name;
                                      _updateState();
                                    },
                                    onSaved: (value) {
                                      addName = value;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Theme(
                                  data: Theme.of(context)
                                      .copyWith(primaryColor: Colors.orange[900]),
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
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
                                    maxLength: 10,
                                    onChanged: (phoneNumber) {
                                      phonenumber = int.tryParse(phoneNumber);
                                      _updateState();
                                    },
                                    onSaved: (value) {
                                      addNumber = int.tryParse(value);
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                OutlineButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:  submitEnabled ? Colors.orange[900] : Colors.black54,
                                      ),
                                    ),
                                  ),
                                  borderSide: BorderSide(color: Colors.orange[900]),
                                  highlightColor: Colors.orange[900],
                                  color: submitEnabled ? Colors.orange[900] : Colors.greenAccent,
                                  onPressed: submitEnabled ? _update : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
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
      if (phonenumber.toString().length == 10 && Contactname != null) {
        submitEnabled = true;
      } else {
        submitEnabled = false;
      }
    });
  }
}



