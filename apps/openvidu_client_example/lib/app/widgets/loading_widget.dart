
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        color: Colors.black54,
        child: const Center(
          child: SpinKitFadingCircle(color: Colors.white),
        ),
      ),
    );
  }
}
