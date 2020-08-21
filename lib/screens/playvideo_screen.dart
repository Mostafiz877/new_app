import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class PlayvideoScreen extends StatefulWidget {
  //this is for git checking
  static const routeName = '/playvideo';

  @override
  _PlayvideoScreenState createState() => _PlayvideoScreenState();
}

class _PlayvideoScreenState extends State<PlayvideoScreen> {
  bool isInternetConnetion = true;
  @override
  void initState() {
    checkINternet();

    super.initState();
  }

  void checkINternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isInternetConnetion = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        isInternetConnetion = false;
      });
    }
  }

  bool isLoading = true;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    var islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final indexAndvideolist =
        ModalRoute.of(context).settings.arguments as List<dynamic>;
    final index = indexAndvideolist[0];
    final videoList = indexAndvideolist[1];
    final videoTitle = videoList[index]['title'];
    final videoLink = videoList[index]['link'];

    var deviceWidth = islandscape
        ? MediaQuery.of(context).size.width * 0.83
        : MediaQuery.of(context).size.width * 1;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              islandscape ? Size.fromHeight(35.0) : Size.fromHeight(50.0),
          // here the desired height
          child: AppBar(
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.skip_previous,
                    color: (index - 1) >= 0 ? Colors.white : Colors.blueGrey),
                onPressed: (index - 1) >= 0
                    ? () {
                        Navigator.of(context).pushReplacementNamed(
                            PlayvideoScreen.routeName,
                            arguments: [
                              index - 1,
                              videoList,
                            ]);
                        // do something
                      }
                    : null,
              ),
              IconButton(
                icon: Icon(
                  Icons.skip_next,
                  color: (index + 1) < videoList.length
                      ? Colors.white
                      : Colors.blueGrey,
                ),
                onPressed: index + 1 < videoList.length
                    ? () {
                        Navigator.of(context).pushReplacementNamed(
                            PlayvideoScreen.routeName,
                            arguments: [
                              index + 1,
                              videoList,
                            ]);

                        // do something
                      }
                    : null,
              ),
              IconButton(
                icon: Icon(
                  Icons.list,
                  color: Colors.white,
                ),
                onPressed: () {
                  listInModal(context, videoList, index);

                  // do something
                },
              ),
            ],
            title: Text(
              videoTitle,
              style: TextStyle(fontSize: 13.0),
            ),
          )),
      body: isInternetConnetion
          ? Center(
              child: Container(
                width: deviceWidth,
                child: Stack(
                  children: <Widget>[
                    WebView(
                      key: _key,
                      onPageFinished: (finish) {
                        setState(() {
                          isLoading = false;
                        });
                      },
                      initialUrl: Uri.dataFromString(
                              '<html><body>$videoLink</body></html>',
                              mimeType: 'text/html')
                          .toString(),
                      javascriptMode: JavascriptMode.unrestricted,
                    ),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : Stack(),
                  ],
                ),
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("No internet connection!"),
                  SizedBox(height: 20.0),
                  FlatButton(
                    color: Colors.black87,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Back to playlist",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  void listInModal(context, var videoList, int outsideIndex) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return ListView.builder(
            itemBuilder: (cxt, index) {
              return Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      enabled: true,
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacementNamed(
                            PlayvideoScreen.routeName,
                            arguments: [
                              index,
                              videoList,
                            ]);
                      },
                      leading: index == outsideIndex
                          ? Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                            )
                          : Icon(
                              Icons.ondemand_video,
                              color: Colors.transparent,
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
          );
        });
  }
}
