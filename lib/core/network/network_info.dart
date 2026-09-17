import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Network Information Interface
/// Provides network connectivity status
abstract class NetworkInfo {
  /// Checks if device is connected to internet
  Future<bool> get isConnected;

  /// Stream of connectivity changes
  Stream<InternetStatus> get onStatusChange;
}

/// Implementation of NetworkInfo using internet_connection_checker
class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasInternetAccess;

  @override
  Stream<InternetStatus> get onStatusChange => connectionChecker.onStatusChange;
}
