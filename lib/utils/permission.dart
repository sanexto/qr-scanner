import 'package:permission_handler/permission_handler.dart';

Future<void> checkPermissions(List<Permission> permissions) async{

  for(Permission permission in permissions){

    if(await permission.isUndetermined || await permission.isDenied){

      await permission.request();

    }

  }

}
