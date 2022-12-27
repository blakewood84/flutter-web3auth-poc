import 'dart:collection';
import 'dart:io';
import 'dart:developer' as devtools;

import 'package:flutter/material.dart';
import 'package:web3auth_flutter/enums.dart';
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/web3auth_flutter.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web3Auth POC',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    devtools.log('Initializing web3auth...');
    late final Uri redirectUrl;

    if (Platform.isAndroid) {
      redirectUrl = Uri.parse('w3a://com.example.web3authPoc/auth');
    } else if (Platform.isIOS) {
      devtools.log('Platform is iOS');
      redirectUrl = Uri.parse('com.example.web3authPoc://openlogin');
    } else {
      throw Exception('Unsupported platform');
    }

    final loginConfig = HashMap<String, LoginConfigItem>();
    loginConfig['facebook'] = LoginConfigItem(
      verifier: 'rewired.poc-facebook',
      typeOfLogin: TypeOfLogin.facebook,
      name: '____',
    );

    await Web3AuthFlutter.init(
      Web3AuthOptions(
        clientId: '____',
        network: Network.testnet,
        redirectUrl: redirectUrl,
        loginConfig: loginConfig,
      ),
    );

    devtools.log('Finished initializing...');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // Create an Elevated Button with Text Login Facebook
          ElevatedButton(
            onPressed: () async {
              try {
                final response = await Web3AuthFlutter.login(
                  LoginParams(
                    loginProvider: Provider.facebook,
                    redirectUrl: Uri.parse(
                      'com.example.web3authPoc://openlogin',
                    ),
                  ),
                );
                devtools.log('Response: $response');
              } on Exception catch (error) {
                devtools.log('Error: $error');
              }
            },
            child: const Text('Login Facebook'),
          ),
        ],
      ),
    );
  }
}
