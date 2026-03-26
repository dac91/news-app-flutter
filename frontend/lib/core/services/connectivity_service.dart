import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract interface for connectivity checking.
///
/// Consumers depend on this abstraction so the concrete
/// [ConnectivityService] (which wraps [Connectivity]) can be
/// swapped in tests without importing provider packages.
abstract class ConnectivityServiceBase {
  /// Returns `true` when the device has an active internet connection.
  Future<bool> get isConnected;

  /// Stream that emits whenever the connectivity state changes.
  Stream<bool> get onConnectivityChanged;
}

/// Thin wrapper around [Connectivity] to simplify testing and
/// provide a single source of truth for network state.
class ConnectivityService implements ConnectivityServiceBase {
  final Connectivity _connectivity;

  ConnectivityService({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(
      (result) => result != ConnectivityResult.none,
    );
  }
}
