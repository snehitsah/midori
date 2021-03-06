//     This file is part of Midori.

//     Midori is free software: you can redistribute it and/or modify
//     it under the terms of the GNU General Public License as published by
//     the Free Software Foundation, either version 3 of the License, or
//     (at your option) any later version.

//     Midori is distributed in the hope that it will be useful,
//     but WITHOUT ANY WARRANTY; without even the implied warranty of
//     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//     GNU General Public License for more details.

//     You should have received a copy of the GNU General Public License
//     along with Midori.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

import 'package:midori/screens/license_screen.dart';
import 'package:midori/screens/donate_screen.dart';

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class AboutScreen extends StatelessWidget {
  static const routeName = '/about_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        title: Text('About'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Card(
              elevation: 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(
                      'DEVELOPED BY',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    subtitle: Text(
                      'Snehit Sah',
                      style: TextStyle(fontSize: 26, color: Colors.green),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: const Text('VIEW GITHUB PROFILE'),
                        onPressed: () {
                          launchURL('https://github.com/flyingcakes85');
                        },
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2, primary: Colors.green),
                    child: Text('VIEW SOURCE CODE',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () =>
                        launchURL('https://github.com/flyingcakes85/midori'),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2, primary: Colors.green[400]),
                    child: Text('VIEW LICENSE',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () =>
                        Navigator.pushNamed(context, LicenseScreen.routeName),
                  ),
                )
              ],
            ),
            SizedBox(height: 12),
            Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                "I am a CS student learning how to code. Most of my work is released as open source, and I do not add advertising in my software.\n\nIf you like my work, please consider donating.",
                style: TextStyle(fontSize: 16),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 4,
                primary: Colors.green,
              ),
              onPressed: () => Get.to(DonateScreen()),
              child: Padding(
                padding: EdgeInsets.all(2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_outline),
                    SizedBox(width: 6),
                    Text("DONATE")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
