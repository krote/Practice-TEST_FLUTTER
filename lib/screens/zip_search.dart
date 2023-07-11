import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class ZipSearchPage extends StatefulWidget {
  const ZipSearchPage({Key? key}) : super(key: key);

  @override
  State<ZipSearchPage> createState() => _ZipSearchPageState();
}

class _ZipSearchPageState extends State<ZipSearchPage> {
  final zipCodeController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('郵便番号から住所補完'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: '郵便番号',
                ),
                maxLength: 7,
                onChanged: (value) async {
                  if (value.length != 7) {
                    return;
                  }
                  final address = await zipCodeToAddress(value);

                  if (address == null) {
                    return;
                  }
                  addressController.text = address;
                },
                controller: zipCodeController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: '住所',
                ),
                controller: addressController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> zipCodeToAddress(String zipCode) async {
  if (zipCode.length != 7) {
    return null;
  }
  final response = await get(
    Uri.parse('https://zipcloud.ibsnet.co.jp/api/search?zipcode=$zipCode'),
  );

  if (response.statusCode != 200) {
    return null;
  }

  final result = jsonDecode(response.body);
  if (result['results'] == null) {
    return null;
  }
  final addressMap = (result['results'] as List).first;
  final address =
      '${addressMap['address1']} ${addressMap['address2']} ${addressMap['address3']}';
  return address;
}
