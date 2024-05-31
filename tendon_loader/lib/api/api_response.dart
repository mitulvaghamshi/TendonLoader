import 'package:flutter/material.dart';

@immutable
final class ApiResponse {
  const ApiResponse({
    this.hasError = false,
    this.hasData = false,
    this.error,
    this.data,
  });

  final bool hasError;
  final bool hasData;
  final Failure? error;
  final Payload? data;
}

@immutable
final class Payload {
  const Payload({required this.content});

  final dynamic content;
}

@immutable
final class Failure {
  const Failure({required this.message});

  final String message;
}
