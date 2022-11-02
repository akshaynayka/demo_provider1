import 'package:in_app_update/in_app_update.dart';

Future? updateCheck() async {
  // final deviceData = await PackageInfo.fromPlatform();
  final updatedata = await InAppUpdate.checkForUpdate();
// InAppUpdate.
  // print('Data : ${updatedata.updateAvailability}');
//' Data : 2 ' will be printed if device have lower verion then play store version
//' Data : 1 ' will be printed if device have same or higher verion then play store version
  if (updatedata.updateAvailability == 2) {
    await InAppUpdate.startFlexibleUpdate();
    await InAppUpdate.completeFlexibleUpdate();
  }
  // final temp = await InAppUpdate.performImmediateUpdate().then((value) {
  //   if (value.index == 1) {
  //     SystemNavigator.pop();
  //   }
  // });
//  temp.
  // return null;
}
