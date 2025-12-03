import 'dart:async';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:footbookcamp/utils/no_internet_widget.dart';

class ConnectionStatusWidget extends StatefulWidget {
  const ConnectionStatusWidget({Key? key}) : super(key: key);

  @override
  _ConnectionStatusWidgetState createState() =>
      _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  late StreamSubscription<InternetConnectionStatus> _subscription;
  bool _isLoading = true; 
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();    
    _subscription = InternetConnectionChecker.createInstance().onStatusChange.listen(
      (status) {        
        setState(() {
          _isLoading = false; 
          _isConnected = status == InternetConnectionStatus.connected;
        });
      },
    );
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {   
    if (_isLoading) {
      return const SizedBox();
    }
   
    return _isConnected
        ? const SizedBox()
        : const NoInternetWidget(); 
  }
}
