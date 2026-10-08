import 'package:flutter/material.dart';
import 'network_status_manager.dart';

class NoNetworkWidget extends StatefulWidget {
  const NoNetworkWidget({super.key});

  @override
  State<NoNetworkWidget> createState() => _NoNetworkWidgetState();
}

class _NoNetworkWidgetState extends State<NoNetworkWidget> with StateMixin {
  late final INetworkChangeManager _networkChange;
  NetworkResult? _networkResult;
  bool _showBackOnline = false;

  @override
  void initState() {
    super.initState();
    _networkChange = NetworkChangeManager();

    waitForScreen(() {
      _networkChange.handleNetworkChange((result) {
        _updateView(result);
      });
    });
  }

  Future<void> fetchFirstResult() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final result = await _networkChange.checkNetworkFirstTime();
      _updateView(result);
    });
  }

  void _updateView(NetworkResult result) {
    if (result == NetworkResult.on && _networkResult == NetworkResult.off) {
      // Trigger "Back online" state
      setState(() {
        _showBackOnline = true;
      });

      // Hide "Back online" after a delay
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showBackOnline = false;
          });
        }
      });
    }

    setState(() {
      _networkResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: .min,
      children: [
        // "No internet" label
        AnimatedCrossFade(
          firstChild: Container(
            height: kToolbarHeight * 0.4,
            width: size.width,
            color: Colors.red,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'No Internet',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          secondChild: const SizedBox(),
          crossFadeState: _networkResult == NetworkResult.off
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(seconds: 1),
        ),
        // "Back online" label
        if (_showBackOnline)
          Container(
            height: kToolbarHeight * 0.4,
            width: size.width,
            color: Colors.green,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Back online",
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}

mixin StateMixin<T extends StatefulWidget> on State<T> {
  void waitForScreen(VoidCallback onComplete) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onComplete.call();
    });
  }
}
