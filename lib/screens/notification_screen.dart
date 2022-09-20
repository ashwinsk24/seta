import 'package:flutter/material.dart';
import 'package:seta/utils/colors.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  _updatelink1() async {
    const url = 'https://ktu.edu.in/';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  _updatelink1_() async {
    const url = 'https://app.ktu.edu.in/login.htm';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  _updatelink2() async {
    const url = 'https://sset.linways.com/';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  _updatelink3() async {
    const url = 'https://www.keralanotes.com/p/ktu-study-materials.html';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  _updatelink4() async {
    const url = 'https://discord.gg/T8GKg3RJTU';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Text('Favourites'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: IconButton(
              icon: const Icon(Icons.school_rounded),
              onPressed: () => _updatelink1(),
            ),
            title: TextButton(
              onPressed: () => _updatelink1(),
              child: Row(
                children: <Widget>[
                  Text(
                    'KTU Site',
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: IconButton(
              icon: const Icon(Icons.login_rounded),
              onPressed: () => _updatelink1_(),
            ),
            title: TextButton(
              onPressed: () => _updatelink1_(),
              child: Row(
                children: <Widget>[
                  Text(
                    'KTU Student login',
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: IconButton(
              icon: const Icon(Icons.my_library_books_rounded),
              onPressed: () => _updatelink2(),
            ),
            title: TextButton(
              onPressed: () => _updatelink2(),
              child: Row(
                children: <Widget>[
                  Text(
                    'SSET Lineways',
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: IconButton(
              icon: const Icon(Icons.menu_book_rounded),
              onPressed: () => _updatelink3(),
            ),
            title: TextButton(
              onPressed: () => _updatelink3(),
              child: Row(
                children: <Widget>[
                  Text(
                    'Study Resources',
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: IconButton(
              icon: const Icon(Icons.explore),
              onPressed: () => _updatelink4(),
            ),
            title: TextButton(
              onPressed: () => _updatelink4(),
              child: Row(
                children: <Widget>[
                  Text(
                    'Join Community',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
