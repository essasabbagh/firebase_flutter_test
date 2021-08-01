import 'package:flutter/material.dart';

class ShapeAnimation extends StatefulWidget {
  @override
  _ShapeAnimationState createState() => _ShapeAnimationState();
}

class _ShapeAnimationState extends State<ShapeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  double pos = 0;

  double posTop = 0;
  double posLeft = 0;
  late Animation<double> animationTop;
  late Animation<double> animationLeft;
  double maxTop = 0;
  double maxLeft = 0;
  final int ballSize = 100;

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    animationLeft = Tween<double>(begin: 0, end: 200).animate(controller);
    animationTop = Tween<double>(begin: 0, end: 400).animate(controller)
      ..addListener(() => moveBall());

    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );

    animation..addListener(() => moveBall());
    super.initState();
  }

  void moveBall() {
    setState(() {
      posTop = animation.value * maxTop;
      posLeft = animation.value * maxLeft;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation Controller'),
        actions: [
          IconButton(
            onPressed: () {
              controller.reset();
              controller.forward();
            },
            icon: Icon(Icons.run_circle),
          )
        ],
      ),
      body: SafeArea(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          maxLeft = constraints.maxWidth - ballSize;
          maxTop = constraints.maxHeight - ballSize;
          return Stack(children: [
            Positioned(left: posLeft, top: posTop, child: Ball()),

            // AnimatedBuilder(
            //     animation: controller,
            //     child: Positioned(left: posLeft, top: posTop, child: Ball()),
            //     builder: (BuildContext context, Widget child) {
            //       moveBall();
            //       return Positioned(left: posLeft, top: posTop, child: Ball());
            //     })
          ]);
        },
      )),
    );
  }
}

class Ball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
    );
  }
}
