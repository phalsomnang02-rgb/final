


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

class UserService {
  static const String _baseUrl = 'https://fakestoreapi.com/users';

  // ទទួល Users ទាំងអស់
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        return userModelFromJson(response.body);
      } else {
        throw Exception('Failed to load users. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // ទទួល User តាម ID
  Future<UserModel> getUserById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$id'));

      if (response.statusCode == 200) {
        return UserModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load user. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}