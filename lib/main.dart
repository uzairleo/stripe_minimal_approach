import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

void main() {
  Stripe.publishableKey =
      'pk_test_51JUetkCNE4qNqI02AfE5RmLueStv50CAMfn2ydIgFTgauMGeSGd9OKIkQa1sRH6o57S3VrR9sEq9YsO3uDxlNuci00AW1qdDne';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter payment demo  Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, dynamic>? paymentIntentData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text("Payments"),
          onPressed: () async {
            print('Payment is pressed ');
            await makePayment();
            print("function executed das khaira");
          },
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      // final url = Uri.parse(
      //     'https://us-central1-carsub-renting-app-b96c6.cloudfunctions.net/stripePayments');

      // final response = await http.get(url, headers: {
      //   'Content-Type': 'application/json',
      // });

      // final response = await http.post(
      //   url,
      //   headers: {
      //     'Content-Type': 'application/json',
      //   },
      //   body: json.encode({
      //     'amount': 45,
      //   }),
      // );

      paymentIntentData =
          await createPaymentIntent('80', 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntentData!['client_secret'],
              applePay: true,
              googlePay: true,
              style: ThemeMode.dark,
              merchantCountryCode: 'US',
              merchantDisplayName: 'ANNIE'));
      // setState(() {});

      ///
      ///now finally display payment sheeet
      ///
      displayPaymentSheet();
    } catch (e, s) {
      print('@@Exception==========>$e, $s');
    }
  }

  displayPaymentSheet() async {
    print(
        "Display payment sheet started=====>${paymentIntentData!['client_secret']}");
    try {
      await Stripe.instance.presentPaymentSheet(
          parameters: PresentPaymentSheetParameters(
        clientSecret: paymentIntentData!['client_secret'],
        confirmPayment: true,
      ));
      setState(() {
        paymentIntentData = null;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("paid successfully")));
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization':
                'Bearer sk_test_51JUetkCNE4qNqI02q1mJ8cOIDzdTBoacSD4jx1E2MV1vG6SfRFRJI6NzaenRnePI9CMchKAz6HeCshBMrJB09Wvk00ru4fcGIU',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount) * 100);
    return a.toString();
  }
}
