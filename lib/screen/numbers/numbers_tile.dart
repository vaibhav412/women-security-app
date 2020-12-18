import 'package:flutter/material.dart';
import 'package:safe_women/screen/numbers/edit_number.dart';
import 'package:safe_women/screen/platform_alert_dialog.dart';

import '../../contacts/database_helper.dart';

class NumbersTile extends StatelessWidget {
  NumbersTile({this.phoneNumber, this.id,this.name});

  final phoneNumber;
  final id;
  final name;

  Future<void> deleteNumber(BuildContext context,int id) async{
    int rowEffected = await DatabaseHelper.instance.delete(id);
    print(rowEffected);
    // Navigator.of(context).pushNamedAndRemoveUntil('/numberScreen',ModalRoute.withName('/numberScreen'));
    Navigator.of(context).pop();
    Navigator.of(context).pushReplacementNamed('/numberScreen');
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20
                  ),
                ),
                SizedBox(
                  height: 3.0,
                ),
                Text('+91$phoneNumber',style: TextStyle(color: Colors.black54,fontSize: 12),),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.delete,color: Color.fromRGBO(252, 91, 57, 1),),
                onPressed: () async{
                  await PlatformAlertDialog(
                      title: 'Delete',
                      content: 'Are you Sure you Want to Delete Number',
                      defaultActionText: 'YES',
                    cancelActionText: 'NO',
                    onPressed: () => deleteNumber(context,id),
                  ).show(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.edit,color: Color.fromRGBO(123, 201, 82, 1),),
                onPressed: () {
                  EditNumber.show(context, id: id);
                },
              ),
            ],
          ),
        ),
        Divider(
          height: 4,
        ),
      ],
    );
  }
}
