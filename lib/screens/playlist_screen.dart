import 'package:flutter/material.dart';
import './playvideo_screen.dart';

class PlaylistScreen extends StatelessWidget {
  static const routeName = '/playlist';

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context).settings.arguments as List<dynamic>;

    var videoList = arguments[0];
    final titleinfo = arguments[1];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          titleinfo,
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: ListView.builder(
          itemBuilder: (cxt, index) {
            return Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(PlayvideoScreen.routeName, arguments: [
                        index,
                        videoList,
                      ]);
                    },
                    leading: Icon(
                      Icons.play_circle_filled,
                      color: Colors.black87,
                    ),
                    title: Text(
                      videoList[index]['title'],
                      style: TextStyle(color: Colors.black87),
                    ),
                    trailing: Text(
                      videoList[index]['duration'],
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: videoList.length,
        ),
      ),
    );
  }
}
