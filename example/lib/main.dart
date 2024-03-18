import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_fincode/flutter_fincode.dart';
import 'package:flutter_fincode_example/loading_button.dart';

const String customerId = 'c_Ux3mjHkYROq44oNZyS-3aA';
const String orderId = 'o_bVAeocUHTZSHXNHWAYqxzg';
const String accessId = 'a_Ettwoxt6SxKAfSoI6FeIEQ';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  String? _cardId;

  final List<Map<String, dynamic>> cardList = [];
  final FlutterFincode _flutterFincodePlugin = FlutterFincode();

  @override
  void initState() {
    super.initState();
    initData();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initData() async {
    dynamic cardListInfo;
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterFincodePlugin.getPlatformVersion() ??
          'Unknown platform version';
      cardListInfo =
          await _flutterFincodePlugin.cardInfoList(customerId);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (cardListInfo != null && cardListInfo is Map) {
      final List<dynamic> cards = cardListInfo['data'];
      for (final dynamic card in cards) {
        cardList.add(card.cast<String, dynamic>());
      }
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  Future<void> getCardList() async {
    dynamic cardListInfo;
    try {
      cardListInfo = await _flutterFincodePlugin.cardInfoList(customerId);
    } on PlatformException {
      cardListInfo = null;
    }
    cardList.clear();
    if (cardListInfo != null && cardListInfo is Map) {
      final List<dynamic> cards = cardListInfo['data'];
      for (final dynamic card in cards) {
        cardList.add(card.cast<String, dynamic>());
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Fincode example'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Card List: ',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Visibility(
                  visible: cardList.isEmpty,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No card found',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.outline),
                    ),
                  ),
                ),
                for (final Map<String, dynamic> card in cardList)
                  Card(
                    elevation: 0.5,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      title: Text('${card['brand']}  ${card['cardNo']}'),
                      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      children: [
                        Text('Card ID: ${card['id']}'),
                        Text('Expire: ${card['expire']}'),
                        Text('Holder Name: ${card['holderName']}'),
                        const SizedBox(height: 10),
                        TextButton.icon(
                          label: const Text('Copy Card ID'),
                          icon: const Icon(Icons.paste_outlined),
                          onPressed: () async {
                            setState(() {
                              _cardId = card['id'];
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(top: 16, bottom: 8),
                  child: Text(
                    'Add Card:',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                CardInfoForm(onAdded: getCardList),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Payment:',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                PaymentWidget(cardId: _cardId),
                Text('Running on: $_platformVersion\n'),
                const SizedBox(height: 80),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final dynamic response =
                  await _flutterFincodePlugin.showPaymentSheet();
              if (!mounted) return;
              showAlert(context, response);
            },
            tooltip: 'Make Payment',
            child: const Icon(Icons.shopping_bag),
          )),
    );
  }
}

class CardInfoForm extends StatefulWidget {
  const CardInfoForm({super.key, this.onAdded});

  final VoidCallback? onAdded;

  @override
  State<CardInfoForm> createState() => _CardInfoFormState();
}

class _CardInfoFormState extends State<CardInfoForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _securityCodeController = TextEditingController();

  final bool canEdit = true;

  final GlobalKey _formKey = GlobalKey<FormState>();

  final FlutterFincode _flutterFincodePlugin = FlutterFincode();

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _securityCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            decoration: _inputDecoration(labelText: 'Cardholder Name'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the cardholder name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cardNumberController,
            decoration: _inputDecoration(labelText: 'Card Number'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
            validator: (value) {
              if (value == null || value.isEmpty || value.length != 16) {
                return 'Please enter a valid card number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _expiryDateController,
                  decoration:
                      _inputDecoration(labelText: 'Expiry Date (YY/MM)'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('') ||
                        value.length != 4) {
                      return 'Please enter a valid expiry date';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _securityCodeController,
                  decoration: _inputDecoration(labelText: 'Security Code'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Please enter a valid code';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            width: double.infinity,
            height: 48,
            child: LoadingButton(
              onPressed: () async {
                FocusScope.of(context).unfocus();
                final FormState formState = _formKey.currentState as FormState;
                if (!formState.validate()) return;
                // Implement submission logic
                if (kDebugMode) {
                  print("Submitting card info...");
                  print("Name: ${_nameController.text}");
                  print("Card Number: ${_cardNumberController.text}");
                  print("Expiry Date: ${_expiryDateController.text}");
                  print("Security Code: ${_securityCodeController.text}");
                }
                Map<String, String> cardInfo = {
                  'customerId': customerId,
                  'holderName': _nameController.text,
                  'cardNo': _cardNumberController.text,
                  'expire': _expiryDateController.text,
                  'securityCode': _securityCodeController.text,
                };
                final dynamic response =
                    await _flutterFincodePlugin.registerCard(cardInfo);
                final bool success = response['status'] == 'success';
                if (success) {
                  _nameController.clear();
                  _cardNumberController.clear();
                  _expiryDateController.clear();
                  _securityCodeController.clear();
                  widget.onAdded?.call();
                }
                if (!mounted) return;
                showAlert(context, response);
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({required String labelText}) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(fontSize: 14, color: colorScheme.outline),
      filled: true,
      fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.surfaceVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.all(16),
    );
  }
}

class PaymentWidget extends StatelessWidget {
  const PaymentWidget({super.key, this.cardId});

  final String? cardId;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Text('payType: Card'),
        const Text('id: $orderId'),
        const Text('accessId: $accessId'),
        const Text('customerId: $customerId'),
        Text('CardId: ${cardId ?? 'None'}'),
        const Text('method: 1'),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          width: double.infinity,
          height: 48,
          child: LoadingButton(
            onPressed: () async {
              final FlutterFincode flutterFincodePlugin = FlutterFincode();
              FocusScope.of(context).unfocus();
              // Implement submission logic
              Map<String, String> paymentInfo = {
                'payType': 'Card',
                'id': orderId,
                'accessId': accessId,
                'customerId': customerId,
                'cardId': cardId ?? '',
                'method': '1',
              };
              final dynamic response = await flutterFincodePlugin.payment(paymentInfo);
              showAlert(context, response);
            },
            child: const Text('Pay'),
          ),
        ),
      ],
    );
  }
}

void showAlert(BuildContext context, dynamic response) {
  final bool success = response['status'] == 'success';
  final String message;
  if (success) {
    message = 'Execution successful!\n ID: ${response['id']}';
  } else {
    message = 'code: ${response['code']}\nmessage: ${response['message']}';
  }
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(success ? 'Success' : 'Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}