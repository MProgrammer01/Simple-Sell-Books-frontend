class ClsApiResponse<T> {
  final int statusCode;
  final T? data;

  ClsApiResponse({
    required this.statusCode,
    this.data,
  });
}