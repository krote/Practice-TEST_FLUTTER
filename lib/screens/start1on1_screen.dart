import 'package:flutter/material.dart';

import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'dart:convert';
import 'package:sdp_transform/sdp_transform.dart';


class Start1on1Screen extends StatefulWidget{
    Start1on1Screen({Key? key}) : super(key:key);

     @override
    State<Start1on1Screen> createState() => _Start1on1Screen();
   
}

class _Start1on1Screen extends State<Start1on1Screen>{
    final _localVideoRenderer = RTCVideoRenderer();
    final _remoteVideoRenderer = RTCVideoRenderer();

    final sdpController = TextEditingController();
    final offerController = TextEditingController();
    final answerController = TextEditingController();
    final candidateController = TextEditingController();
    bool _offer = false;

    RTCPeerConnection? _peerConnection;
    MediaStream? _localStream;

    void initRenderers() async {
        await _localVideoRenderer.initialize();
        await _remoteVideoRenderer.initialize();
    }

    @override
    void initState(){
        initRenderers();
        _createPeerConnection().then((pc){
            _peerConnection = pc;
        });
//        _getUserMedia();
        super.initState();
    }

    @override
    void dispose() async {
        await _localVideoRenderer.dispose();
        sdpController.dispose();
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

    _createPeerConnection() async {
        Map<String, dynamic> configuration = {
            "iceServers": [
                {"url": "stun:stun.2talk.com:3478"}
            ]
        };

        final Map<String, dynamic> offerSdpConstraints = {
            "mandatory": {
                "OfferToReceiveAudio" : true,
                "OfferToReceiveVideo" : true,
            },
            "optional": [],
        };

        _localStream = await _getUserMedia();

        RTCPeerConnection pc = await createPeerConnection(configuration, offerSdpConstraints);
        pc.addStream(_localStream!);

        pc.onIceCandidate = (e) {
            if(e.candidate != null){
                print(json.encode({
                    'candidate': e.candidate.toString(),
                    'sdpMid': e.sdpMid.toString(),
                    'sdpMlineIndex': e.sdpMLineIndex,
                }));
            }
        };

        pc.onIceConnectionState = (e){
            print(e);
        };

        pc.onAddStream = (stream){
            print('addStream:' + stream.id);
            _remoteVideoRenderer.srcObject = stream;
        };
        return pc;
    }

    void _createOffer() async {
        RTCSessionDescription description = await _peerConnection!.createOffer({'offerToReceiveVideo': 1});
        var session = parse(description.sdp.toString());
        print("offer start *****");
        print(json.encode(session));
        print("offer end *****");
        _offer = true;
        offerController.text = json.encode(session);

        _peerConnection!.setLocalDescription(description);
    }

    void _createAnswer() async {
        RTCSessionDescription description = await _peerConnection!.createAnswer({'offerToReceiveVideo': 1});

        var session = parse(description.sdp.toString());
        print("answer start *****");
        print(json.encode(session));
        print("answer end *****");
        answerController.text = json.encode(session);

        _peerConnection!.setLocalDescription(description);
    }

    void _setRemoteDescription() async {
        String jsonString = sdpController.text;
        dynamic session = await jsonDecode(jsonString);

        String sdp = write(session, null);

        RTCSessionDescription description = new RTCSessionDescription(sdp, _offer ? 'answer':'offer');
        print(description.toMap());
        candidateController.text = description.toMap();

        await _peerConnection!.setRemoteDescription(description);
    }

    void _addCandidate() async {
        String jsonString = candidateController.text;
        print("sdpController:" + jsonString);
        dynamic session = await jsonDecode(jsonString);
        print(session['candidate']);
//        print("sdpMid:" + session['sdpMid']);
//        print("sdpMlineInex:" + session['sdpMlineIndex']);
        dynamic candidate = new RTCIceCandidate(
            session['candidate'], session['sdpMid'], session['sdpMlineIndex']
        );
        await _peerConnection!.addCandidate(candidate);
    }

    @override
    Widget build(BuildContext context){
        return Scaffold(
            appBar: AppBar(
                title: Text('widget.title'),
            ),
            body: Column(
                children: [
                    Row(
                        children:[
                            Expanded(
                                child: Text("local"),
                            ),
                            Expanded(
                                child: Text("Remote"),
                            ),
                        ],
                    ),
                    videoRenderers(),
                    Row(
                        children:[
                            Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                    children: [
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.5,
                                            child: TextField(
                                                controller: offerController,
                                                keyboardType: TextInputType.multiline,
                                                maxLines: 4,
                                                maxLength: TextField.noMaxLength,
                                                decoration : InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'OfferText'
                                                )
                                            ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.5,
                                            child: TextField(
                                                controller: answerController,
                                                keyboardType: TextInputType.multiline,
                                                maxLines: 4,
                                                maxLength: TextField.noMaxLength,
                                                decoration : InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'AnswerText'
                                                )
                                            ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context).size.width * 0.5,
                                            child: TextField(
                                                controller: candidateController,
                                                keyboardType: TextInputType.multiline,
                                                maxLines: 4,
                                                maxLength: TextField.noMaxLength,
                                                decoration : InputDecoration(
                                                    border: OutlineInputBorder(),
                                                    labelText: 'CandidateText'
                                                )
                                            ),
                                        ),
                                    ],
                                ),
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    ElevatedButton(
                                        onPressed: _createOffer,
                                        child: const Text("Offer"),
                                    ),
                                    const SizedBox(
                                        height: 10,
                                    ),
                                    ElevatedButton(
                                        onPressed: _createAnswer,
                                        child: const Text("Answer"),
                                    ),
                                    const SizedBox(
                                        height:10,
                                    ),
                                    ElevatedButton(
                                        onPressed: _setRemoteDescription,
                                        child: const Text("Set Remote Description"),
                                    ),
                                    const SizedBox(
                                        height: 10,
                                    ),
                                    ElevatedButton(
                                        onPressed: _addCandidate,
                                        child: const Text("Set Candidate"),
                                    ),
                                ],
                            ),
                        ],
                    ),
                ],
            ),
        );
    }

    SizedBox videoRenderers() => SizedBox(
        height: 210,
        child: Row(
            children: [
                Flexible(
                    child:Container(
                        key: Key('local'),
                        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        decoration: BoxDecoration(color: Colors.black),
                        child: RTCVideoView(_localVideoRenderer),
                    ),
                ),
                Flexible(
                    child: Container(
                        key: Key('remote'),
                        margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                        decoration: BoxDecoration(color: Colors.black),
                        child: RTCVideoView(_remoteVideoRenderer),
                    ),
                ),
            ]
        ),
    );
}