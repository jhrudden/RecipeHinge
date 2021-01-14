import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// blank page with loading animation in center
class LoadingPage extends StatelessWidget {
  const LoadingPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      color: Colors.transparent,
      child: Center(
        child: SpinKitDoubleBounce(
          color: Colors.blueGrey,
          size: 100,
        ),
      ),
    ));
  }
}
