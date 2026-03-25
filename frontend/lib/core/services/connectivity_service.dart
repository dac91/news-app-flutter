import 'package:connectivity_plus/connectivity_plus.dart';

/// Thin wrapper around [Connectivity] to simplify testing and
/// provide a single source of truth for network state.
class ConnectivityService {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  /// Returns `true` when the device has an active internet connection
  /// (Wi-Fi, mobile data, ethernet). Returns `false` for none.
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Stream that emits whenever the connectivity state changes.
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (result) => result != ConnectivityResult.none,
    );
  }
}
