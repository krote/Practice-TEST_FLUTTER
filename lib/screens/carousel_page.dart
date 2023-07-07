import 'package:flutter/material.dart';

class CarouselPage extends StatefulWidget {
  const CarouselPage({
    Key? key,
    required this.pages,
    this.indicatorColor,
    this.indicatorAlignment,
  }) : super(key: key);
  final List<Widget> pages;
  final Color? indicatorColor;
  final Alignment? indicatorAlignment;

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  int currentIndex = 0;

  @override
  Widge build(BuildContext context) {
    final pages = widget.pages;
    final pageLength = pages.length;
    final color =
        widget.indicatorColor ?? Theme.of(context).colorScheme.primary;
    return Stack(
      alignment: Alignment.center,
      children: [
        PageView(
          onPageChanged: (value) {
            setState((){
              currentIndex = value;
            });
          },
          children: widget.pages,
        ),
        Align(
          alignment: widget.indicatorAlignment ?? const Alignment(0, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pageLength, 
              (index)  {
                return Container(
                  margin: const EdgeInsets.all(4),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: index == currentIndex ? color : null,
                    shape: BoxShape.circle,
                    border: Border.all(color: color),
                  ),
                  )
              },
            ),
          ),
        )

      ],
    )
  }
}
