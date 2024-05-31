import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tendon_loader/api/api_response.dart';
import 'package:tendon_loader/api/network_status.dart';

@immutable
mixin ApiClient {
  static const _host = String.fromEnvironment('API_HOST');
  static const _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  static Future<ApiResponse> get<T>(final String path) async {
    if (!NetworkStatus.isConnected) {
      return const ApiResponse(
        hasError: true,
        error: Failure(message: '[ApiClient:GET]: No Connection'),
      );
    }
    try {
      final response = await http.get(
        Uri.http(_host, path),
        headers: _headers,
      );
      return switch (response.statusCode) {
        200 => ApiResponse(
            hasData: true,
            data: Payload(content: jsonDecode(response.body)),
          ),
        404 => const ApiResponse(
            hasError: true,
            error: Failure(message: '[ApiClient:GET]: Resource Not Found'),
          ),
        _ => const ApiResponse(
            hasError: true,
            error: Failure(message: '[ApiClient:GET]: Something went wrong'),
          ),
      };
    } on HttpException {
      throw const HttpException('[ApiClient:GET]: HTTP Request Error');
    }
  }

  static Future<ApiResponse> post(
    final String path,
    final Map<String, dynamic> data,
  ) async {
    if (!NetworkStatus.isConnected) {
      return const ApiResponse(
        hasError: true,
        error: Failure(message: '[ApiClient:POST]: No Connection'),
      );
    }
    try {
      final response = await http.post(
        Uri.http(_host, path),
        headers: _headers,
        body: jsonEncode(data),
      );
      return switch (response.statusCode) {
        201 => const ApiResponse(
            hasData: true,
            data: Payload(content: '[ApiClient:POST]: Content Created'),
          ),
        _ => const ApiResponse(
            hasError: true,
            error: Failure(message: '[ApiClient:POST]: Something went wrong'),
          ),
      };
    } on HttpException {
      throw const HttpException('[ApiClient:POST]: HTTP Request Error');
    }
  }

  static Future<ApiResponse> put(
    final String path,
    final Map<String, dynamic> data,
  ) async {
    if (!NetworkStatus.isConnected) {
      return const ApiResponse(
        hasError: true,
        error: Failure(message: '[ApiClient:PUT]: No Connection'),
      );
    }
    try {
      final response = await http.put(
        Uri.http(_host, path),
        headers: _headers,
        body: jsonEncode(data),
      );
      return switch (response.statusCode) {
        204 => const ApiResponse(
            hasData: true,
            data: Payload(content: '[ApiClient:PUT]: No Content'),
          ),
        400 => const ApiResponse(
            hasError: true,
            error: Failure(message: '[ApiClient:PUT]: Bad Request'),
          ),
        _ => const ApiResponse(
            hasError: true,
            error: Failure(message: '[ApiClient:PUT]: Something went wrong'),
          ),
      };
    } on HttpException {
      throw const HttpException('[ApiClient:PUT]: HTTP Request Error');
    }
  }

  static Future<ApiResponse> delete(final String path) async {
    throw UnimplementedError('[ApiClient]: delete() not implemented.');
    // if (!Network.isConnected) {
    //   return const ApiResponse(
    //     hasError: true,
    //     error: Failure(message: '[ApiClient:DELETE]: No Connection'),
    //   );
    // }
    // try {
    //   final response = await http.delete(
    //     Uri.http(_host, path),
    //     headers: _headers,
    //   );
    //   return switch (response.statusCode) {
    //     204 => const ApiResponse(
    //         hasData: true,
    //         data: Payload(data: '[ApiClient:DELETE]: No Content'),
    //       ),
    //     400 => const ApiResponse(
    //         hasError: true,
    //         error: Failure(message: '[ApiClient:DELETE]: Bad request'),
    //       ),
    //     _ => const ApiResponse(
    //         hasError: true,
    //         error: Failure(message: '[ApiClient:DELETE]: Something went wrong'),
    //       ),
    //   };
    // } on HttpException {
    //   throw const HttpException('[ApiClient:DELETE]: HTTP Request Error');
    // }
  }
}
