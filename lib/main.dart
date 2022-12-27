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
      redirectUrl = Uri.parse('com.example.web3authPoc://openlogin');
    } else {
      throw Exception('Unsupported platform');
    }

    await Web3AuthFlutter.init(
      Web3AuthOptions(
        clientId: 'BPl7okxKe-j4U6dzaDJE8DtWSAUz6IQ1WDGugfEqO3hz1Dp72x4bpBA0dHY1p6kOHQNil72zUxvlWH-kqnMHd5I',
        network: Network.testnet,
        redirectUrl: redirectUrl,
      ),
    );

    devtools.log('Finished initializing...');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Hello World!'),
      ),
    );
  }
}
