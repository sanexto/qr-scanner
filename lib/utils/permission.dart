import 'package:permission_handler/permission_handler.dart' as permission_handler;

class Permission{

  static Future<void> checkPermissions(List<permission_handler.Permission> permissions) async{

    for(permission_handler.Permission permission in permissions){

      if(await permission.isUndetermined || await permission.isDenied){

        await permission.request();

      }

    }

  }

}
