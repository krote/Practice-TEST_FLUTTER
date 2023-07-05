import 'package:flutter/material.dart';

class WavePointer extends CustomPainter{
    WavePointer(this.wave_src, this.color, this.constraints);

    final _heightOffset = 0.25;
    BoxConstraints constraints;
    List<double> wave_src;
//    List<Offset> points;
    Color color;

//    Size size;

    // Set max val possible in stream, dependeing on the config
    final absMax = 30;
    
    @override
    void paint(Canvas canvas, Size size){
        // 色、太さ、塗りつぶしの有無などを指定
        final paint = Paint()
        ..color = color
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

        // 得られたデータをオフセットのリストに変換する
        List<Offset> points = toPoints(wave_src);

        // addPolygon で path をつくり drawPath でグラフを表現する
        final path = Path()..addPolygon(points, false);
        canvas.drawPath(path, paint);
    }

    @override
    bool shouldRepaint(CustomPainter oldPainting) => true;

    // 得られたデータを等間隔に並べていく
    List<Offset> toPoints(List<double> src){
        final points = <Offset>[];
        for(var i = 0; i< (src.length/2); i++){
            points.add(
                Offset(
                    i / (src.length / 2) * constraints.maxWidth,
                    project(src[i], absMax, constraints.maxHeight),
                ),
            );
        }
        return points;
    }

    double project(double val, int max, double height){
        final waveHeight = (val/max) * _heightOffset * height;
        return waveHeight + _heightOffset * height;
    }
}