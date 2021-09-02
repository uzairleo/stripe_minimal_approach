// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:stripe_testing/stripe-config.dart';
// import 'package:stripe_testing/stripe-transaction-response.dart';



// class StripeService {
//   static String apiBase = 'https://api.stripe.com/v1';
//   static String paymentApiUrl =
//       '${StripeService.apiBase}https://api.stripe.com/v1/payment_intents';
//   static String secret = clientSecret;
//   static Map<String, String> headers = {
//     'Authorization': 'Bearer ${StripeService.secret}',
//     'Content-Type': 'application/x-www-form-urlencoded'
//   };
//   static init() async {
//     Stripe.publishableKey = stripePublishableKey;
//   Stripe.merchantIdentifier = 'MerchantIdentifier';
//   Stripe.urlScheme = 'flutterstripe';
//   await Stripe.instance.applySettings();
//   }

//    Future<StripeTransactionResponse> payWithPaymentSheet(
//       {String? amount, String? currency, BuildContext? context}) async {
//     try {
//       // var paymentMethod = await StripePayment.paymentRequestWithCardForm(
//       //     CardFormPaymentRequest());
//       var paymentIntent =
//           createPaymentIntent(amount!, currency!);
//       print("intent: ${paymentIntent['client_secret']}");
//       var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
//           clientSecret: paymentIntent!['client_secret'],
//           paymentMethodId: paymentMethod.id));
//       if (response.status == 'succeeded') {
//         AppUtils.paymentTrxId = response.paymentIntentId;

//         return new StripeTransactionResponse(
//             message: 'Transaction successful', success: true);
//       } else {
//         return new StripeTransactionResponse(
//             message: 'Transaction failed', success: false);
//       }
//     } on PlatformException catch (err) {
//       return StripeService.getPlatformExceptionErrorResult(err);
//     } catch (err) {
//       return new StripeTransactionResponse(
//           message: 'Transaction failed: ${err.toString()}', success: false);
//     }
//   }

//   static getPlatformExceptionErrorResult(err) {
//     String message = 'Something went wrong';
//     if (err.code == 'cancelled') {
//       message = 'Transaction cancelled';
//     }

//     return new StripeTransactionResponse(message: message, success: false);
//   }

//    Future<Map<String, dynamic>?> createPaymentIntent(
//       String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//         'payment_method_types[]': 'card'
//       };
//       // print(body);
//       // print(StripeService.headers);
//       // print(StripeService.paymentApiUrl);
//       var response = await http.post(Uri.parse(StripeService.paymentApiUrl),
//           body: body, headers: StripeService.headers);
//       return jsonDecode(response.body);
//     } catch (err) {
//       print('err charging user: ${err.toString()}');
//     }
//   }
// }
