import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:eagle_cargo/main.dart' as app;

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group("end-to-end-test", () {
    testWidgets('login test', (tester) async {
      app.main(isTestMode: true);
      await Future.delayed(Duration(seconds: 20));
      await binding.convertFlutterSurfaceToImage();
      await tester.pumpAndSettle();
      final Finder phone = find.byType(TextField);
      await binding.takeScreenshot('01_login_page');
      await tester.enterText(phone, '10000000');
      await Future.delayed(Duration(seconds: 5));
      final Finder loginBtn = find.byType(ElevatedButton).first;
      await tester.tap(loginBtn);
      await Future.delayed(Duration(seconds: 10));
      //OTP
      await tester.pumpAndSettle();
      await binding.takeScreenshot('02_otp_page');
      final Finder otp1 = find.byKey(ValueKey('otp_field_0'));
      final Finder otp2 = find.byKey(ValueKey('otp_field_1'));
      final Finder otp3 = find.byKey(ValueKey('otp_field_2'));
      final Finder otp4 = find.byKey(ValueKey('otp_field_3'));
      await tester.enterText(otp1, '1');
      await tester.enterText(otp2, '0');
      await tester.enterText(otp3, '1');
      await tester.enterText(otp4, '0');
      final Finder otpBtn = find.byKey(Key('otp_btn'));
      await tester.tap(otpBtn);
      await Future.delayed(Duration(seconds: 10));
      //Home page
      await tester.pumpAndSettle();
      await binding.takeScreenshot('03_home_page');
      //End
      await Future.delayed(Duration(seconds: 30));
    });
    

  });
}
