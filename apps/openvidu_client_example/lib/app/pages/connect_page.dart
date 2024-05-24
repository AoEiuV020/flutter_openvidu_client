import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'room_page.dart';
import '../utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/session.dart';
import '../widgets/text_field.dart';

class ConnectPage extends StatefulWidget {
  const ConnectPage({super.key});

  @override
  State<ConnectPage> createState() => _ConnectPageState();
}

class _ConnectPageState extends State<ConnectPage> {
  final bool _busy = false;

  final TextEditingController _textSessionController = TextEditingController();
  final TextEditingController _textUserNameController = TextEditingController();
  final TextEditingController _textUrlController = TextEditingController();
  final TextEditingController _textSecretController = TextEditingController();
  final TextEditingController _textPortController = TextEditingController();
  final TextEditingController _textIceServersController =
      TextEditingController();

  final Dio _dio = Dio();

  Future<void> _readPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _textUrlController.text =
        prefs.getString('textUrl') ?? _textUrlController.text;
    _textSecretController.text =
        prefs.getString('textSecret') ?? _textSecretController.text;
    _textPortController.text =
        prefs.getString('textPort') ?? _textPortController.text;
    _textIceServersController.text =
        prefs.getString('textIceServers') ?? _textIceServersController.text;
    logger.i('Loaded user inputs value.');
  }

  Future<void> _writePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('textUrl', _textUrlController.text);
    await prefs.setString('textSecret', _textSecretController.text);
    await prefs.setString('textPort', _textPortController.text);
    await prefs.setString('textIceServers', _textIceServersController.text);
    logger.i('Saved user inputs values.');
  }

  _connect(BuildContext ctx) async {
    String path = '${_textUrlController.text}:${_textPortController.text}';
    if (!path.startsWith('http://') || !path.startsWith('https://')) {
      path = 'https://${_textUrlController.text}:${_textPortController.text}';
    }
    _dio.options.baseUrl = '$path/openvidu/api';
    _dio.options.headers['content-Type'] = 'application/json';
    _dio.options.headers["authorization"] =
        'Basic ${base64Encode(utf8.encode('OPENVIDUAPP:${_textSecretController.text}'))}';

    final nav = Navigator.of(ctx);

    try {
      var response = await _dio.post(
        '/sessions',
        data: {
          "mediaMode": "ROUTED",
          "recordingMode": "MANUAL",
          "customSessionId": _textSessionController.text,
          "forcedVideoCodec": "VP8",
          "allowTranscoding": false
        },
      );
      final statusCode = response.statusCode ?? 400;
      if (statusCode >= 200 && statusCode < 300) {
        var response2 = await _dio.post(
          '/sessions/${_textSessionController.text}/connection',
          data: {
            "type": "WEBRTC",
            "data": "My Server Data",
            "record": true,
            "role": "PUBLISHER",
          },
        );
        final statusCode2 = response2.statusCode ?? 400;
        if (statusCode2 >= 200 && statusCode2 < 300) {
          logger.i(response2.data);
          final connection = Session.fromJson(response2.data);
          await nav.push(
            MaterialPageRoute(
                builder: (_) => RoomPage(
                      room: connection,
                      userName: _textUserNameController.text,
                      serverUrl: path,
                      secret: _textSecretController.text,
                    )),
          );
        }
      }
    } catch (e) {
      logger.e(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _textSessionController.text = 'Session${Random().nextInt(1000)}';
    _textUserNameController.text = 'Participante${Random().nextInt(1000)}';
    _textUrlController.text = 'demos.openvidu.io';
    _textSecretController.text = 'MY_SECRET';
    _textPortController.text = '443';
    _textIceServersController.text = 'stun.l.google.com:19302';
    _readPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: OVTextField(
                    label: 'Room name',
                    ctrl: _textSessionController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: OVTextField(
                    label: 'Username',
                    ctrl: _textUserNameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: OVTextField(
                    label: 'Server Url',
                    ctrl: _textUrlController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: OVTextField(
                    label: 'Secret',
                    ctrl: _textSecretController,
                  ),
                ),
                ElevatedButton(
                  onPressed: _busy ? null : () => _connect(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_busy)
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      const Text('CONNECT'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
