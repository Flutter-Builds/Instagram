import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram/widgets/storywidget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Instagram',
      theme: ThemeData.light().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: Colors.grey[900],
        ),
        appBarTheme: AppBarTheme(color: Colors.grey[900]),
        popupMenuTheme: PopupMenuThemeData(color: Colors.black),
        dialogBackgroundColor: Colors.black,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

PageController _controller = PageController(
  initialPage: 0,
);

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _controller,
      children: [
        Feed(),
        Messages(),
      ],
    );
  }
}

class Feed extends StatefulWidget {
  Feed({Key key}) : super(key: key);
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () => _controller.animateTo(
              MediaQuery.of(context).size.width,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            ),
          )
        ],
      ),
      body: Center(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.12,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 20,
                  itemBuilder: (context, index) {
                    if (index == 0)
                      return ProfileStory();
                    else
                      return OtherStories();
                  }),
            ),
            Divider(
              color: Colors.grey,
              thickness: 0.2,
            )
          ],
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => Messages(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

int accountCount = 1;

class Messages extends StatefulWidget {
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => _controller.animateTo(
            0.0,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          ),
        ),
        title: Row(
          children: [
            Text('username'),
            IconButton(
              icon: Icon(Icons.arrow_drop_down),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  context: context,
                  builder: (context) {
                    return Wrap(
                      children: [
                        Container(height: 15.0),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.all(10.0),
                            height: 4,
                            width: 40,
                          ),
                        ),
                        ListView.builder(
                          padding: EdgeInsets.all(10.0),
                          shrinkWrap: true,
                          itemCount: accountCount + 1,
                          itemBuilder: (context, index) {
                            if (index == accountCount)
                              return ListTile(
                                contentPadding: EdgeInsets.all(10.0),
                                leading: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 30.0,
                                    child: Icon(
                                      Icons.add,
                                      size: 30.0,
                                    ),
                                  ),
                                ),
                                title: Text('Add Account'),
                              );
                            else
                              return ListTile(
                                contentPadding: EdgeInsets.all(10.0),
                                leading: Icon(
                                  Icons.account_circle,
                                  size: 60.0,
                                ),
                                title: Text('account1'),
                                trailing: Icon(Icons.remove_circle_outline),
                              );
                          },
                        )
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.videocam), onPressed: null),
          IconButton(icon: Icon(Icons.note_add), onPressed: null),
        ],
      ),
    );
  }
}

class OtherStories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue,
          ),
          shape: BoxShape.circle,
        ),
        child: StoryWidget(),
      ),
    );
  }
}

class ProfileStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Center(
        child: Stack(
          children: [
            StoryWidget(),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.blue[300],
                  radius: 9.0,
                  child: Icon(
                    Icons.add,
                    size: 15.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
