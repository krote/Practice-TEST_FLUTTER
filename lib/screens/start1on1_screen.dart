import 'package:flutter/material.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';

class Start1on1Screen extends StatefulWidget{
    Start1on1Screen({Key? key}) : super(key:key);

     @override
    State<Start1on1Screen> createState() => _Start1on1Screen();
   
}

class _Start1on1Screen extends State<Start1on1Screen>{
    final _localVideoRenderer = RTCVideoRenderer();

    void initRenderers() async {
        debugPrint('initialize localVideo Renderer***********');
        await _localVideoRenderer.initialize();
    }

    @override
    void initState(){
        initRenderers();
        _getUserMedia();
        super.initState();
    }

    @override
    void dispose() async {
        await _localVideoRenderer.dispose();
        super.dispose();
    }

    _getUserMedia() async {
        final Map<String, dynamic> mediaConstraints = {
            'audio': true,
            'video': {
                'facingMode': 'user',
            }
        };

        debugPrint('get user Media ***********');
        MediaStream stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
        _localVideoRenderer.srcObject = stream;
        return stream;
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: Text('widget.title'),
            ),
            body: Stack(
                children: [
                    Positioned(
                        top: 0.0,
                        right: 0.0,
                        left: 0.0,
                        bottom: 0.0,
                        child: RTCVideoView(_localVideoRenderer)
                    )
                ],
            ),
        );
    }
}