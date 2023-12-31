import 'dart:async';
import 'dart:math';

import 'package:fftea/fftea.dart';
import 'package:flutter/material.dart';
import 'package:audio_streamer/audio_streamer.dart';
//import 'package:dart_numerics/dart_numerics.dart';
import 'package:flutter/services.dart';

class AnalysisModel extends ChangeNotifier {
    final _streamer = AudioStreamer();
    final _windowLength = pow(2, 15).toInt();
    bool isRecording = false;
    List<double> audio = List<double>.filled(pow(2, 15).toInt(), 0);
    List<double> spectrum = List<double>.filled(pow(2,15) ~/ 2, 0);

    void onAudio(List<double> buffer){
        // fft は 2の累乗しか受け付けないため0埋めする
        for(var i = 0; i < buffer.length; i++){
            audio[i] = buffer[i];
        }
/*
        // 窓掛け処理を行う
        final window = Window(WindowType.HAMMING);
        final windowed = window.apply(audio);

        // フーリエ変換
//        final fft = FFT(_windowLength).Transform(windowed);
        final fft_0 = FFT(_windowLength);
        final fft = fft_0.realFft(windowed);
        for(var i = 0; i < _windowLength / 2; i++){
            // パワースペクトルを dB 単位に変換
            final tmpPower = (fft[i] * fft[i].conjugate).real / _windowLength;
            spectrum[i] = - (10 * log10(tmpPower)); // canvasが下方向に正のため反転している
        }
*/
        notifyListeners();
    }
    
    void handleError(PlatformException error){
        isRecording = false;
        print(error.message);
        print(error.details);
    }

    Future<void> start() async{
        try{
            await _streamer.start(onAudio, handleError);
            isRecording = true;
        }catch(error){
            print(error);
        }
        notifyListeners();
    }

    Future<void> stop() async{
        final stopped = await _streamer.stop();
        isRecording = stopped;
        notifyListeners();
    }
}