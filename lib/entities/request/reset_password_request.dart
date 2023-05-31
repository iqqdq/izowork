class ResetPasswordRequest {
  final String email;

  ResetPasswordRequest(this.email);

  Map<String, dynamic> toJson() => {"email": email};
}
