import '../../modules/login/login_screen.dart';
import '../network/local/cach_helper.dart';
import 'components.dart';

void signOut(context){
  CashHelper.clearData(key: 'token').then((value) {
    navigateAndDelete(context, LoginScreen());
  });
}

String? TOKEN;