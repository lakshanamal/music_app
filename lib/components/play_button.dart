import 'package:flutter/material.dart';
import 'dart:math' show pi;

class PlayButton extends StatefulWidget {
  final Icon playIcon;
  final initialIsPlaying;
  final VoidCallback onPressed;

  PlayButton({
    @required this.onPressed,
    this.playIcon,
    this.initialIsPlaying,
  }) : assert(onPressed != null);

  @override
  _PlayButtonState createState() => _PlayButtonState();
}

class _PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  static const _kToggleDuration = Duration(milliseconds: 300);
  static const _kRotationDuration = Duration(seconds: 5);

  // rotation and scale animations
  AnimationController _rotationController;
  AnimationController _scaleController;
  double _rotation = 0;
  double _scale = 0.6;

  bool get _showWaves => !_scaleController.isDismissed;

  void _updateRotation() => _rotation = _rotationController.value * 2 * pi;
  void _updateScale() => _scale = (_scaleController.value * 0.2) + 0.85;

  bool isPlay = true;
  @override
  void initState() {
    isPlay = widget.initialIsPlaying;
    _rotationController =
        AnimationController(vsync: this, duration: _kRotationDuration)
          ..addListener(() => setState(_updateRotation))
          ..repeat();

    _scaleController =
        AnimationController(vsync: this, duration: _kToggleDuration)
          ..addListener(() => setState(_updateScale));

    super.initState();
  }

  void _onToggle() {
    // if (isPlay) {
    if (_scaleController.isCompleted) {
      _scaleController.reverse();
    } else {
      _scaleController.forward();
    }
    // }
    widget.onPressed();
  }

  Widget _buildIcon() {
    return SizedBox(
      child: IconButton(
        icon: widget.playIcon,
        color: Colors.white,
        onPressed: _onToggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 28, minHeight: 28),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_showWaves) ...[
            Blob(color: Color(0xffff9252), scale: _scale, rotation: _rotation),
            Blob(
                color: Color(0xffff7626),
                scale: _scale,
                rotation: _rotation - 10),
            Blob(
                color: Color(0xffff5e00),
                scale: _scale,
                rotation: _rotation - 15),
            Blob(
                color: Color(0xffff9900),
                scale: _scale,
                rotation: _rotation - 20),
          ],
          Container(
            constraints: BoxConstraints.expand(),
            child: AnimatedSwitcher(
              child: _buildIcon(),
              duration: _kToggleDuration,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }
}

class Blob extends StatelessWidget {
  final double rotation;
  final double scale;
  final Color color;

  const Blob({this.color, this.rotation = 0, this.scale = 1});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Transform.rotate(
        angle: rotation,
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(150),
              topRight: Radius.circular(230),
              bottomLeft: Radius.circular(220),
              bottomRight: Radius.circular(180),
            ),
          ),
        ),
      ),
    );
  }
}
