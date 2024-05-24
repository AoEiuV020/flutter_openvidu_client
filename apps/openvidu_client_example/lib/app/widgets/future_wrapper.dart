import 'package:flutter/material.dart';

import 'loading_widget.dart';

class FutureWrapper extends StatelessWidget {
  final Future future;
  final Widget Function(BuildContext context) builder;

  const FutureWrapper({
    Key? key,
    required this.future,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            color: Colors.white,
            child: const LoadingWidget(),
          );
        } else {
          return builder(context);
        }
      },
    );
  }
}
