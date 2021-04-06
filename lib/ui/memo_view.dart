import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:memo/model/memo.dart';
import 'package:memo/ui/memo_edit.dart';
import 'package:memo/ui/memo_list.dart';

class MemoView extends StatefulWidget {
  final Memo memo;

  MemoView({Key key, this.memo}) : super(key: key);

  @override
  _MemoViewState createState() => _MemoViewState();
}

class _MemoViewState extends State<MemoView> {
  Memo memo;
  DateFormat formatter;
  String pageTitle = 'Mémo',
      dateCreate = 'Créé : ',
      dateUpdate = 'Modifié : ',
      tipEdit = 'Modifier';

  update(Memo newMemo) => setState(() {
        memo = newMemo;
      });

  edit() async {
    var newMemo = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoEdit(
          true,
          memo: memo,
        ),
      ),
    );
    newMemo ??= newMemo = memo;
    update(newMemo);
  }

  @override
  void initState() {
    super.initState();
    memo = widget.memo;
    initializeDateFormatting();
    formatter = new DateFormat.MMMd('fr_FR').add_Hm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$pageTitle ${memo.idMemo.toString()}'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: tipEdit,
            icon: Icon(Icons.edit),
            onPressed: () {
              edit();
            },
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  dateCreate + formatter.format(memo.dateCreate),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Text(
                  dateUpdate + formatter.format(memo.dateUpdate),
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10.0),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.indigo),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(getCategorieIcon(memo.categorie)),
                  Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.indigo, width: 2.0),
                        bottom: BorderSide(color: Colors.indigo, width: 2.0),
                      ),
                    ),
                    child: SelectableText(
                      memo.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: SelectableText(
                  memo.detail,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
