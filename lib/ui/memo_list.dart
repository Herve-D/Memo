import 'package:flutter/material.dart';
import 'package:memo/model/memo.dart';
import 'package:memo/ui/memo_edit.dart';
import 'package:memo/util/dbHelper.dart';

getCategorieIcon(String cat) {
  if (cat == categories[0]) {
    return Icons.directions_run;
  } else if (cat == categories[1]) {
    return Icons.directions_walk;
  }
}

class MemoList extends StatefulWidget {
  @override
  _MemoListState createState() => _MemoListState();
}

class _MemoListState extends State<MemoList> {
  int navIndex = 0;
  List<Widget> navBodies;
  List<BottomNavigationBarItem> navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.note),
      title: Text('Tout'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.directions_run),
      title: Text('Important'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.directions_walk),
      title: Text('Tranquille'),
    )
  ];
  String appTitle = 'HD Inc.',
      screenTitle = 'Mémos',
      tipFab = 'Ajouter un mémo',
      tipPopup = 'Options',
      popItemEdit = ' Modifier',
      popItemDelete = ' Détruire',
      dialTitle = 'Olala !',
      dialContent = "Anéantissement du mémo, d'accord ?!",
      dialNo = 'Oh non pitié...',
      dialYes = 'Avec plaisir !',
      emptyList = 'May the Force be with you';

  void onTapped(int index) {
    setState(() {
      navIndex = index;
    });
  }

  refresh() async {
    navBodies = [
      bodyList(DbHelper.db.getAllMemo()),
      bodyList(DbHelper.db.getMemoByCat(categories[0])),
      bodyList(DbHelper.db.getMemoByCat(categories[1]))
    ];
  }

  createMemo() {
    Navigator.push(
            context, MaterialPageRoute(builder: (context) => MemoEdit(false)))
        .then((value) => setState(() {
              refresh();
            }));
  }

  viewMemo(Memo memo) {
    Navigator.pushNamed(context, '/memoView', arguments: memo)
        .then((value) => setState(() {
              refresh();
            }));
  }

  editMemo(Memo memo) {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => MemoEdit(true, memo: memo)))
        .then((value) => setState(() {
              refresh();
            }));
  }

  deleteMemo(Memo memo) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0)),
            title: Center(
              child: Text(dialTitle),
            ),
            content: SingleChildScrollView(
              child: Text(dialContent),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text(dialNo),
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      DbHelper.db.suppMemo(memo.idMemo);
                      refresh();
                    });
                  },
                  child: Text(dialYes))
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    navBodies = [
      bodyList(DbHelper.db.getAllMemo()),
      bodyList(DbHelper.db.getMemoByCat(categories[0])),
      bodyList(DbHelper.db.getMemoByCat(categories[1]))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.all(2.0),
          child: Center(
            child: Text(
              appTitle,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                    offset: Offset(5.0, 5.0),
                    blurRadius: 3.0,
                    color: Colors.green,
                  )
                ],
              ),
            ),
          ),
        ),
        title: Text(screenTitle),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigo),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: navBodies[navIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.indigo,
        tooltip: tipFab,
        child: Icon(Icons.note_add),
        onPressed: createMemo,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTapped,
        currentIndex: navIndex,
        items: navItems,
        unselectedItemColor: Colors.indigo,
      ),
    );
  }

  PopupMenuItem popUpItem({int value, IconData icon, String text}) {
    return PopupMenuItem(
      value: value,
      height: 35,
      child: RichText(
        text: TextSpan(
          children: [
            WidgetSpan(
              child: Icon(icon, size: 20.0),
            ),
            TextSpan(
              text: text,
              style: TextStyle(fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }

  Widget bodyList(Future memoList) {
    return FutureBuilder<List<Memo>>(
      future: memoList,
      builder: (context, snapshot) {
        return snapshot.hasData && snapshot.data.isNotEmpty
            ? GridView.builder(
                padding: EdgeInsets.all(2.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  Memo memo = snapshot.data[index];
                  return Card(
                    shadowColor: Colors.green,
                    margin: EdgeInsets.all(10.0),
                    elevation: 8.0,
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(getCategorieIcon(memo.categorie),
                                  size: 20.0),
                              PopupMenuButton(
                                tooltip: tipPopup,
                                child: IconButton(
                                    icon: Icon(Icons.more_vert),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                    onPressed: null),
                                elevation: 20.0,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(color: Colors.green),
                                    borderRadius: BorderRadius.circular(20.0)),
                                itemBuilder: (context) => [
                                  popUpItem(
                                      value: 1,
                                      icon: Icons.edit,
                                      text: popItemEdit),
                                  popUpItem(
                                      value: 2,
                                      icon: Icons.delete_sweep,
                                      text: popItemDelete)
                                ],
                                onSelected: (dynamic value) {
                                  if (value == 1)
                                    editMemo(memo);
                                  else if (value == 2) deleteMemo(memo);
                                },
                              ),
                            ],
                          ),
                          Container(
                            child: RaisedButton(
                                color: Colors.indigo,
                                onPressed: () {
                                  viewMemo(memo);
                                },
                                child: Text(memo.name)),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              memo.idMemo.toString(),
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 10.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })
            : Center(
                child: Text(emptyList),
              );
      },
    );
  }
}
