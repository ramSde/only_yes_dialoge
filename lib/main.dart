import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glassmorphism Demo',
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: const Text('Glassmorphism Demo'),
        ),
        body: Center(
          child: AnimatedGlassmorphicDialog(
            title: 'Confirm',
            buttonRadius: 20,
            buttonWidth: 100,
            buttonHeight: 50,
            borderRadius: 20,
            blur: 10,
            borderWidth: 2,
            borderGradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedGlassmorphicDialog extends StatefulWidget {
  final String title;
  final double borderRadius;
  final double borderWidth;
  final double blur;
  final LinearGradient borderGradient;
  final double buttonRadius;
  final double buttonWidth;
  final double buttonHeight;

  const AnimatedGlassmorphicDialog({
    required this.title,
    required this.borderRadius,
    required this.borderWidth,
    required this.blur,
    required this.borderGradient,
    required this.buttonRadius,
    required this.buttonWidth,
    required this.buttonHeight,
  });

  @override
  _AnimatedGlassmorphicDialogState createState() =>
      _AnimatedGlassmorphicDialogState();
}

class _AnimatedGlassmorphicDialogState
    extends State<AnimatedGlassmorphicDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _buttonsEnabled = true;
  bool _swapButtons = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleYes() {
    if (_buttonsEnabled) {
      setState(() {
        _buttonsEnabled = false;
      });
      print('Yes');
    }
  }

  void _handleNo() {
    if (_buttonsEnabled) {
      setState(() {
        _swapButtons = !_swapButtons;
      });
      print('No');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        elevation: 0,
        backgroundColor: Colors.blue.withOpacity(0.4),
        child: GlassmorphicContainer(
          borderRadius: 20,
          borderWidth: 10,
          height: 250,
          width: 300,
          blur: 10,
          borderGradient: LinearGradient(colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.1)
          ]),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GlassmorphicContainer(
                  width: widget.buttonWidth * 2,
                  height: widget.buttonHeight,
                  borderRadius: widget.borderRadius,
                  blur: widget.blur,
                  borderWidth: widget.borderWidth,
                  borderGradient: widget.borderGradient,
                  child: Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: widget.buttonWidth * 2 + 20,
                  height: widget.buttonHeight,
                  child: Stack(
                    children: [
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        left: _swapButtons ? widget.buttonWidth + 20 : 0,
                        top: 0,
                        child: GestureDetector(
                          onTap: _buttonsEnabled ? _handleNo : null,
                          child: GlassmorphicContainer(
                            width: widget.buttonWidth,
                            height: widget.buttonHeight,
                            borderRadius: widget.buttonRadius,
                            blur: widget.blur,
                            borderWidth: widget.borderWidth,
                            borderGradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.5),
                                Colors.red.withOpacity(0.1),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'No',
                                style: TextStyle(
                                  color: _buttonsEnabled
                                      ? Colors.white
                                      : Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        duration: Duration(milliseconds: 500),
                        left: _swapButtons ? 0 : widget.buttonWidth + 20,
                        top: 0,
                        child: GestureDetector(
                          onTap: _buttonsEnabled ? _handleYes : null,
                          child: GlassmorphicContainer(
                            width: widget.buttonWidth,
                            height: widget.buttonHeight,
                            borderRadius: widget.buttonRadius,
                            blur: widget.blur,
                            borderWidth: widget.borderWidth,
                            borderGradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.5),
                                Colors.blue.withOpacity(0.1),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                'Yes',
                                style: TextStyle(
                                  color: _buttonsEnabled
                                      ? Colors.white
                                      : Colors.grey,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            (_animation.value - 1) * MediaQuery.of(context).size.height / 2,
          ),
          child: child,
        );
      },
    );
  }
}

class GlassmorphicContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final double borderWidth;
  final double blur;
  final LinearGradient borderGradient;
  final Widget? child;

  const GlassmorphicContainer({
    required this.width,
    required this.height,
    required this.borderRadius,
    required this.borderWidth,
    required this.blur,
    required this.borderGradient,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                width: borderWidth,
                color: Colors.white.withOpacity(0.2),
              ),
              gradient: borderGradient,
            ),
          ),
          if (child != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: child!,
            ),
        ],
      ),
    );
  }
}
