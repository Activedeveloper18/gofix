import 'package:flutter/material.dart';
import 'network_status_service.dart';
import 'network_aware_widget.dart';
import 'package:provider/provider.dart';

class networkTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Network Aware App"),
      ),
      body: StreamProvider<NetworkStatus>(
        create: (context) =>
        NetworkStatusService().networkStatusController.stream,

        initialData: NetworkStatus.Online,
        child: NetworkAwareWidget(
          onlineChild: Container(
            child: Center(
              child: Text(
                "I am online",
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          offlineChild: Container(
            child: Center(
              child: Text(
                "No internet connection!",
                style: TextStyle(
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
