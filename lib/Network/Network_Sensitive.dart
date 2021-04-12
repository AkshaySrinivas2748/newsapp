import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'connectivity_status.dart';

class NetworkSensitive extends StatelessWidget {
  final Widget child;
  final double opacity;

  NetworkSensitive({
    this.child,
    this.opacity = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    // Get our connection status from the provider
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    if ((connectionStatus == ConnectivityStatus.WiFi) ||
        (connectionStatus == ConnectivityStatus.Cellular)) {
      return child;
    } else {
      return Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: child,
          ),
          Material(
            type: MaterialType.transparency,
            child: Container(
              alignment: Alignment.center,
              child: Container(
                width: 300,
                child: Text(
                  'No Internet\n Connect to wifi or cellular Data',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.normal,
                      fontSize: 18),
                ),
              ),
            ),
          )
        ],
      );
    }
  }
}
