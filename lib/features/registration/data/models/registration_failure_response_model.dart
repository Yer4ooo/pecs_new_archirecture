class RegistrationErrorResponse {
  final Map<String, List<String>> fieldErrors;
  final String? generalDetail;

  RegistrationErrorResponse({
    required this.fieldErrors,
    this.generalDetail,
  });

  factory RegistrationErrorResponse.fromJson(Map<String, dynamic> json) {
    // Handle "detail" only case
    if (json.containsKey('detail')) {
      return RegistrationErrorResponse(
        fieldErrors: {},
        generalDetail: json['detail'],
      );
    }
    final Map<String, List<String>> errors = {};
    json.forEach((key, value) {
      if (value is List) {
        errors[key] = List<String>.from(value);
      }
    });

    return RegistrationErrorResponse(
      fieldErrors: errors,
    );
  }
}
