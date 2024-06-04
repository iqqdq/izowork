import 'package:url_launcher/url_launcher.dart';

class WebViewHelper {
  void open(String url) async {
    if (await canLaunchUrl(Uri.parse(url.replaceAll(' ', '')))) {
      launchUrl(Uri.parse(url.replaceAll(' ', '')));
    } else if (await canLaunchUrl(
        Uri.parse('https://' + url.replaceAll(' ', '')))) {
      launchUrl(Uri.parse('https://' + url.replaceAll(' ', '')));
    }
  }
}
