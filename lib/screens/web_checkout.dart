import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_stripe_web/flutter_stripe_web.dart';

import '../components/custom_dialog.dart';

class WebStripePay extends StatefulWidget {
  String? selectedTime;
  var date,instanceUser,name,docid;
  WebStripePay( {Key? key,this.selectedTime, this.date, this.instanceUser,this.name,this.docid}) : super(key: key);

  @override
  _WebStripePayState createState() => _WebStripePayState();
}

class _WebStripePayState extends State<WebStripePay> {
  CardFieldInputDetails? _card;
  Map<String, dynamic>? paymentIntentData;
  bool _saveCard = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/images/stripe.jpg'),
                fit: BoxFit.fitHeight,
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.dstATop),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width>480?MediaQuery.of(context).size.width * 0.3:MediaQuery.of(context).size.width * 0.75,
            child: CardField(
              onCardChanged: (card) {
                setState(() {
                  _card = card;
                });
              },
            ),
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () async {
              try{
                await Stripe.instance.confirmPayment(
                  paymentIntentData!['client_secret'],
                  PaymentMethodParams.card(
                    paymentMethodData: PaymentMethodData(
                      billingDetails: BillingDetails(
                          email: "sagheerrajper@gmail.com", phone: "03040206774",name: "sagheer"),
                      shippingDetails: ShippingDetails(address: Address(city: 'karachi',country: 'pk',line1: 'k1',line2: 'k2',postalCode: '563',state: 'pak'), phone: "03040206774",name: "sagheer"),

                    ),
                    options: PaymentMethodOptions(
                      setupFutureUsage: _saveCard == true
                          ? PaymentIntentsFutureUsage.OffSession
                          : null,
                    ),
                  ),
                ).then((value) async => {
                  await FirebaseFirestore.instance
                      .collection("appointments")
                      .doc()
                      .set({
                    "docname": widget.name,
                    "docid": widget.docid,
                    "patientid": widget.instanceUser,
                    "time": widget.selectedTime,
                    "date": widget.date,
                    "status": 'pending'
                  }).then((_) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                        Text('Appointment Booked Successfully!')));
                  }),
                  //orderPlaceApi(paymentIntentData!['id'].toString())
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("paid successfully"),backgroundColor: Colors.black12,)),

                  paymentIntentData = null
                });

              }
              on StripeException catch (e) {
                print('Exception/DISPLAYPAYMENTSHEET==> $e');
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      content: Text("Cancelled "),
                    ));
              } catch (e) {
                print('exception$e');
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CustomDialog(
                      title: 'Error!',
                      subtitle: 'Unexpected Value returned',
                      primaryAction: () {
                        Navigator.pop(context);
                      },
                      primaryActionText: 'Okay',
                    );
                  },);
              }
            },
            child: Text('Pay'),
          )
        ],
      ),
    );
  }
}
