import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:outlook/config.dart';
import 'package:outlook/responsive.dart';
import 'package:outlook/screens/Welcome/home.dart';
import 'package:outlook/screens/Welcome/welcome_screen.dart';
import 'package:outlook/screens/auth/login.dart';
import 'package:outlook/screens/auth/navscreen.dart';
import 'package:outlook/screens/main/main_screen.dart';
import 'package:outlook/web_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Stripe.publishableKey = '$STRIPE_KEY';
  await Stripe.instance.applySettings();

  SharedPreferences preferences = await SharedPreferences.getInstance();
  var email = preferences.getString('email');
  var role = preferences.getString('role');
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/welcome': (context) => HomePage(),
    },
    debugShowCheckedModeBanner: false,
    theme: ThemeData(),
    home: kIsWeb
        ? HomePage()
        : email == null
            ? HomePage()
            : NavScreen(email: email, role: role),
  ));
  WebView.platform = WebWebViewPlatform();

  // runApp(const MaterialApp(home: WebViewExample()));

}


// class WebStripePay extends StatefulWidget {
//   const WebStripePay({Key? key}) : super(key: key);
//
//   @override
//   _WebStripePayState createState() => _WebStripePayState();
// }
//
// class _WebStripePayState extends State<WebStripePay> {
//   CardFieldInputDetails? _card;
//   Map<String, dynamic>? paymentIntentData;
//   bool _saveCard = true;
//
//   final controller = CardFormEditController();
//
//   @override
//   void initState() {
//     controller.addListener(update);
//     super.initState();
//   }
//
//   void update() => setState(() {});
//   @override
//   void dispose() {
//     controller.removeListener(update);
//     controller.dispose();
//     super.dispose();
//   }
//     @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(30),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             CardFormField(
//               controller: controller,
//             ),
//             ElevatedButton(
//                 onPressed: () async {
//                   try{
//                     await Stripe.instance.confirmPayment(
//                       paymentIntentData!['client_secret'],
//                       PaymentMethodParams.card(
//                         paymentMethodData: PaymentMethodData(
//                           billingDetails: BillingDetails(
//                               email: "sagheerrajper@gmail.com", phone: "03040206774",name: "sagheer"),
//                           shippingDetails: ShippingDetails(address: Address(city: 'karachi',country: 'pk',line1: 'k1',line2: 'k2',postalCode: '563',state: 'pak'), phone: "03040206774",name: "sagheer"),
//
//                         ),
//                         options: PaymentMethodOptions(
//                           setupFutureUsage: _saveCard == true
//                               ? PaymentIntentsFutureUsage.OffSession
//                               : null,
//                         ),
//                       ),
//                     );
//                   }
//                   on StripeException catch (e) {
//                     print('Exception/DISPLAYPAYMENTSHEET==> $e');
//                     showDialog(
//                         context: context,
//                         builder: (_) => AlertDialog(
//                           content: Text("Cancelled "),
//                         ));
//                   } catch (e) {
//                     print('$e');
//                   }
//                 },
//               child: Text('Pay'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

