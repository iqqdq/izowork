// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';

// class PaymentService {
//   /// We want singelton object of ``PaymentService`` so create private constructor
//   ///
//   /// Use PaymentService as ``PaymentService.instance``
//   PaymentService._internal();

//   static final PaymentService instance = PaymentService._internal();

//   /// To listen the status of connection between app and the billing server
//   StreamSubscription<ConnectionResult>? _connectionSubscription;

//   /// To listen the status of the purchase made inside or outside of the app (App Store / Play Store)
//   ///
//   /// If status is not error then app will be notied by this stream
//   StreamSubscription<PurchasedItem>? _purchaseUpdatedSubscription;

//   /// To listen the errors of the purchase
//   StreamSubscription<PurchaseResult>? _purchaseErrorSubscription;

//   /// List of product ids you want to fetch
//   final List<String> _productIds = Platform.isIOS
//       ? [
//           'specialist_monthly_sub',
//           'specialist_yearly_sub',
//           'professional_monthly_sub',
//           'professional_yearly_sub'
//         ]
//       : [];

//   /// All available products will be store in this list
//   List<IAPItem>? _products;

//   /// All past purchases will be store in this list
//   List<PurchasedItem>? _pastPurchases;

//   /// view of the app will subscribe to this to get notified
//   /// when premium status of the user changes
//   ObserverList<Function> _proStatusChangedListeners =
//       new ObserverList<Function>();

//   /// view of the app will subscribe to this to get errors of the purchase
//   ObserverList<Function(String)> _errorListeners =
//       new ObserverList<Function(String)>();

//   /// logged in user's premium status
//   bool _isProUser = false;

//   bool get isProUser => _isProUser;

//   /// Call this method at the startup of you app to initialize connection
//   /// with billing server and get all the necessary data
//   void initConnection() async {
//     await FlutterInappPurchase.instance.initialize();

//     _connectionSubscription =
//         FlutterInappPurchase.connectionUpdated.listen((connected) {
//       print('connected: $connected');
//     });

//     _purchaseUpdatedSubscription = FlutterInappPurchase.purchaseUpdated
//         .listen(_handlePurchaseUpdate) as StreamSubscription<PurchasedItem>?;

//     _purchaseErrorSubscription = FlutterInappPurchase.purchaseError
//         .listen(_handlePurchaseError) as StreamSubscription<PurchaseResult>?;

//     _getItems();
//     _getPastPurchases();
//   }

//   /// call when user close the app
//   void dispose() {
//     _connectionSubscription?.cancel();
//     _purchaseErrorSubscription?.cancel();
//     _purchaseUpdatedSubscription?.cancel();
//     FlutterInappPurchase.instance.finalize();
//   }

//   // MARK: -
//   // MARK: - SUBSCRIPTION PURCHASE

//   Future _handlePurchaseUpdateIOS(PurchasedItem purchasedItem) async {
//     switch (purchasedItem.transactionStateIOS) {
//       case TransactionState.deferred:
//         // Edit: This was a bug that was pointed out here : https://github.com/dooboolab/flutter_inapp_purchase/issues/234
//         // FlutterInappPurchase.instance.finishTransaction(purchasedItem);
//         break;
//       case TransactionState.failed:
//         _callErrorListeners("Transaction Failed");
//         FlutterInappPurchase.instance.finishTransaction(purchasedItem);
//         break;
//       case TransactionState.purchased:
//         await _verifyAndFinishTransaction(purchasedItem);
//         break;
//       case TransactionState.purchasing:
//         break;
//       case TransactionState.restored:
//         FlutterInappPurchase.instance.finishTransaction(purchasedItem);
//         break;
//       default:
//     }
//   }

//   void _handlePurchaseError(PurchaseResult? purchaseError) {
//     _callErrorListeners(purchaseError?.message ?? 'purchase error');
//   }

//   /// Called when new updates arrives at ``purchaseUpdated`` stream
//   void _handlePurchaseUpdate(PurchasedItem? productItem) async {
//     if (Platform.isAndroid) {
//       await _handlePurchaseUpdateAndroid(productItem!);
//     } else {
//       await _handlePurchaseUpdateIOS(productItem!);
//     }
//   }

//   /// three purchase state https://developer.android.com/reference/com/android/billingclient/api/Purchase.PurchaseState
//   /// 0 : UNSPECIFIED_STATE
//   /// 1 : PURCHASED
//   /// 2 : PENDING
//   Future _handlePurchaseUpdateAndroid(PurchasedItem purchasedItem) async {
//     switch (purchasedItem.purchaseStateAndroid) {
//       case PurchaseState.purchased:
//         if (!purchasedItem.isAcknowledgedAndroid!) {
//           await _verifyAndFinishTransaction(purchasedItem);
//         }
//         break;
//       default:
//         _callErrorListeners("Something went wrong");
//     }
//   }

//   /// Call this method when status of purchase is success
//   /// Call API of your back end to verify the reciept
//   /// back end has to call billing server's API to verify the purchase token
//   _verifyAndFinishTransaction(PurchasedItem purchasedItem) async {
//     FlutterInappPurchase.instance.finishTransaction(purchasedItem);
//     _isProUser = true;
//     // save in sharedPreference here
//     _callProStatusChangedListeners();
//   }

//   Future<List<IAPItem>?> get products async {
//     if (_products == null) {
//       await _getItems();
//     }
//     return _products;
//   }

//   Future _getItems() async {
//     List<IAPItem> items =
//         await FlutterInappPurchase.instance.getSubscriptions(_productIds);
//     _products = [];

//     for (var item in items) {
//       this._products?.add(item);
//     }

//     print(items);
//     print(this._products);
//     print(items);
//   }

//   void _getPastPurchases() async {
//     List<PurchasedItem> purchasedItems = await FlutterInappPurchase.instance
//         .getAvailablePurchases() as List<PurchasedItem>;

//     for (var purchasedItem in purchasedItems) {
//       // bool isValid = false;

//       if (Platform.isAndroid) {
//         Map map = json.decode(purchasedItem.transactionReceipt!);
//         // if your app missed finishTransaction due to network or crash issue
//         // finish transactins
//         if (!map['acknowledged']) {
//           // isValid = await _verifyPurchase(purchasedItem);
//           // if (isValid) {
//           FlutterInappPurchase.instance.finishTransaction(purchasedItem);
//           _isProUser = true;
//           _callProStatusChangedListeners();
//           // }
//         } else {
//           _isProUser = true;
//           _callProStatusChangedListeners();
//         }
//       }
//     }

//     _pastPurchases = [];
//     _pastPurchases?.addAll(purchasedItems);
//   }

//   // MARK: -
//   // MARK: - LISTENERS

//   /// Call this method to notify all the subsctibers of _proStatusChangedListeners
//   void _callProStatusChangedListeners() {
//     _proStatusChangedListeners.forEach((Function callback) {
//       callback();
//     });
//   }

//   /// Call this method to notify all the subsctibers of _errorListeners
//   void _callErrorListeners(String error) {
//     _errorListeners.forEach((Function callback) {
//       callback(error);
//     });
//   }
// }
