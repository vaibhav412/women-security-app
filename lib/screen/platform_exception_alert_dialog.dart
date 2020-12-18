
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:safe_women/screen/platform_alert_dialog.dart';

class PlatformExceptionAlertDialog extends PlatformAlertDialog {
  PlatformExceptionAlertDialog({
    @required String title,
    @required PlatformException exception,
    @required VoidCallback onPressed,
  }) : super(
    title: title,
    content: exception.code,
    defaultActionText: 'OK',
    onPressed: onPressed
  );
}
