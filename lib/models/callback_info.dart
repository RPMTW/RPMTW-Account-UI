class CallbackInfo {
  static CallbackInfo? _instance;
  static CallbackInfo? get instance => _instance;

  final String originalUrl;
  final String serviceName;

  const CallbackInfo({
    required this.originalUrl,
    required this.serviceName,
  });

  Uri get uri => Uri.parse(originalUrl);

  Uri getAuthUri(String token) {
    return uri.replace(
        queryParameters: Map.from(uri.queryParameters)..['access_token'] = token);
  }

  void save() {
    _instance = this;
  }

  factory CallbackInfo.fromUrl(String url) {
    final uri = Uri.parse(url);
    final serviceName = uri.queryParameters["service_name"] ?? uri.host;

    return CallbackInfo(
      originalUrl: uri.toString(),
      serviceName: serviceName,
    );
  }
}
