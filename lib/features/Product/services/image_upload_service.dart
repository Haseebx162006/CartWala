import 'dart:convert';
import 'dart:io';
import 'package:cartwala/GlobalVariables.dart';
import 'package:cartwala/features/Auth/services/api_helper.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ImageUploadService {
  final String baseUrl = kBaseUrl;

  Future<String?> uploadImage(File file) async {
    final uri = Uri.parse('$baseUrl/api/uploads/image');
    final headers = await authHeaders();

    final request = http.MultipartRequest('POST', uri);
    request.headers.addAll(headers);

    final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';
    final parts = mimeType.split('/');

    final multipartFile = await http.MultipartFile.fromPath(
      'image',
      file.path,
      contentType: MediaType(parts[0], parts[1]),
    );

    request.files.add(multipartFile);

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['url'];
    }
    return null;
  }
}
