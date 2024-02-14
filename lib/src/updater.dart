import 'dart:convert';

import 'package:http/http.dart';
import 'package:neptun_plus_flutter/constants/urls.dart' as urls;
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Future<String?> checkForUpdate() async {
  Uri url = Uri.parse(urls.githubLatestRelease);
  Response response = await http.get(url);
  Map<dynamic, dynamic> responseData = jsonDecode(response.body);
  
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String localVersionNumber = packageInfo.version;
  String latestVersionNumber = responseData['tag_name'].toString().substring(1); //remove 'v' from version number
  List<String> localVersionNumberSplit = localVersionNumber.split('.');
  List<String> latestVersionNumberSplit = latestVersionNumber.split('.');
  for (var i = 0; i < localVersionNumberSplit.length; i++) {
    if (int.parse(latestVersionNumberSplit[i]) > int.parse(localVersionNumberSplit[i])) {
      return responseData['body'];
    }
  }
  return null;
}


Future<bool> downloadUpdate() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String localVersionNumber = packageInfo.version;
  Uri downloadUrl = Uri.parse('${urls.downloadUpdateUrl}v$localVersionNumber/app-arm64-v8a-release.apk');
  launchUrl(downloadUrl);
  return true;
}

Future<String> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}