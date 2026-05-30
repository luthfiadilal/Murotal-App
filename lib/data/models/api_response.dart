class ApiResponse<T> {
  final int code;
  final String status;
  final T data;

  ApiResponse({
    required this.code,
    required this.status,
    required this.data,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse<T>(
      code: json['code'] as int,
      status: json['status'] as String,
      data: fromJsonT(json['data']),
    );
  }
}
