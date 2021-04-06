import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:memo/ui/memo_list.dart';
import 'package:memo/ui/memo_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: MaterialApp(
        title: 'Mémo',
        theme: ThemeData.dark(),
        initialRoute: '/accueil',
        routes: {
          '/accueil': (context) => MemoList(),
          '/memoView': (context) =>
              MemoView(memo: ModalRoute.of(context).settings.arguments),
        },
      ),
    );
  }
}
