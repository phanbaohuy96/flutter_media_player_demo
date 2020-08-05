import 'package:flutter/material.dart';
import 'package:poc_media_player/presentation/route/route_list.dart';
import 'package:poc_media_player/presentation/theme/theme_button.dart';

import '../../../envs.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '''${Config.appConfig.appName} - ${Config.appConfig.envName}'''),
      ),
      body: Align(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ThemeButton.primary(
              context: context,
              title: 'Audio',
              onPressed: () {
                Navigator.pushNamed(context, RouteList.audioPlayer);
              },
            ),
            const SizedBox(height: 10),
            ThemeButton.primary(
              context: context,
              title: 'Video',
              onPressed: () {
                Navigator.pushNamed(context, RouteList.videoPlayer);
              },
            )
          ],
        ),
      ),
    );
  }
}
