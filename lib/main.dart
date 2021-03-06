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
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:midori/home_view.dart';
import 'package:midori/screens/quiz_screen.dart';
import 'package:midori/screens/result_screen.dart';
import 'package:midori/screens/about_screen.dart';
import 'package:midori/screens/license_screen.dart';
import 'package:midori/consts.dart';

void main() async {
  await GetStorage.init();
  runApp(Midori());
}

class Midori extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final bool isDarkThemeEnabled =
        (GetStorage().read("isDarkModeEnabled") ?? true);

    return GetMaterialApp(
      title: 'Midori',
      theme: isDarkThemeEnabled ? Consts.darkTheme : Consts.lightTheme,
      home: HomeView(),
      debugShowCheckedModeBanner: false,
      routes: {
        QuizScreen.routeName: (context) => QuizScreen(),
        ResultScreen.routeName: (context) => ResultScreen(),
        AboutScreen.routeName: (context) => AboutScreen(),
        LicenseScreen.routeName: (context) => LicenseScreen(),
      },
    );
  }
}
