import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:petroflow/api/api_config.dart';

class ApiService {
  Future<dynamic> getData(String endpoint) async {
    final url = Uri.parse("$apiBaseUrl/$endpoint");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // Can be Map or List
      } else {
        throw Exception(
            "GET failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("GET error: $e");
    }
  }

  Future<Map<String, dynamic>> postData(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$apiBaseUrl/$endpoint");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "POST failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("POST error: $e");
    }
  }

  Future<Map<String, dynamic>> updateData(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$apiBaseUrl/$endpoint");

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "PUT failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("PUT error: $e");
    }
  }

  Future<Map<String, dynamic>> deleteData(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$apiBaseUrl/$endpoint");

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "DELETE failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("DELETE error: $e");
    }
  }

  /// Fetch a list of items from an endpoint and map them to a models
  Future<List<T>> fetchList<T>(
      String endpoint, T Function(Map<String, dynamic>) fromJson) async {
    try {
      final response = await getData(endpoint);

      if (response is List) {
        return response.cast<Map<String, dynamic>>().map(fromJson).toList();
      } else {
        throw Exception("Unexpected response format: ${response.runtimeType}");
      }
    } catch (e) {
      throw Exception("Error fetching data from $endpoint: $e");
    }
  }

  /// **Post a list of items to an endpoint**
  Future<Map<String, dynamic>> postList<T>(String endpoint, List<T> data,
      Map<String, dynamic> Function(T) toJson) async {
    final url = Uri.parse("$apiBaseUrl/$endpoint");

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data.map(toJson).toList()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "POST List failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("POST List error: $e");
    }
  }

  /// **Update a list of items using PUT**
  Future<Map<String, dynamic>> putList<T>(String endpoint, List<T> data,
      Map<String, dynamic> Function(T) toJson) async {
    final url = Uri.parse("$apiBaseUrl/$endpoint");

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data.map(toJson).toList()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "PUT List failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("PUT List error: $e");
    }
  }

  /// **Delete a list of items**
  Future<Map<String, dynamic>> deleteList<T>(String endpoint, List<T> data,
      Map<String, dynamic> Function(T) toJson) async {
    final url = Uri.parse("$apiBaseUrl/$endpoint");

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data.map(toJson).toList()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "DELETE List failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("DELETE List error: $e");
    }
  }

  /// **PATCH Request - Partially update a resource**
  Future<Map<String, dynamic>> patchData(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse("$apiBaseUrl/$endpoint");

    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "PATCH failed: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      throw Exception("PATCH error: $e");
    }
  }

  /// **OPTIONS Request - Check allowed HTTP methods**
  Future<Map<String, dynamic>> optionsData(String endpoint) async {
    final url = Uri.parse("$apiBaseUrl/$endpoint");

    try {
      final response = await http.Request('OPTIONS', url).send();
      if (response.statusCode == 200) {
        return {
          "allowed_methods": response.headers['allow'],
          "headers": response.headers,
        };
      } else {
        throw Exception("OPTIONS failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("OPTIONS error: $e");
    }
  }

  /// **HEAD Request - Get headers without fetching data**
  Future<Map<String, dynamic>> headData(String endpoint) async {
    final url = Uri.parse("$apiBaseUrl/$endpoint");

    try {
      final response = await http.head(url);
      if (response.statusCode == 200) {
        return response.headers;
      } else {
        throw Exception("HEAD failed: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("HEAD error: $e");
    }
  }

  Future<Map<String, dynamic>> sendOtp(String email) async {
    return postData('email/send-otp', {"to": email});
  }

  Future<Map<String, dynamic>> resetPassword(
      String email, String newPassword) async {
    return postData('users/reset-password', {
      "email": email,
      "newPassword": newPassword,
    });
  }
}
