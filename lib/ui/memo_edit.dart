import 'package:flutter/material.dart';
import 'package:memo/model/memo.dart';
import 'package:memo/util/dbHelper.dart';

const List categories = ['Important', 'Tranquille'];

class MemoEdit extends StatefulWidget {
  final bool edit;
  final Memo memo;

  MemoEdit(this.edit, {this.memo}) : assert(edit == true || memo == null);

  @override
  _MemoEditState createState() => _MemoEditState();
}

class _MemoEditState extends State<MemoEdit> {
  TextEditingController nameCtl = TextEditingController();
  TextEditingController detailCtl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String categorie,
      pageChange = 'Modifier',
      pageNew = 'Ajouter',
      fieldTitle = 'Titre *',
      fieldCat = 'Catégorie *',
      fieldObj = 'Quoi donc ?',
      tipSave = 'Sauvegarder',
      dialTitle = 'Olala',
      dialContent1 = 'Donnez au moins un nom...',
      dialContent2 = 'Définissez une catégorie...',
      dialOk = 'Je vais essayer !';

  @override
  void initState() {
    super.initState();
    if (widget.edit == true) {
      nameCtl.text = widget.memo.name;
      detailCtl.text = widget.memo.detail;
      categorie = widget.memo.categorie;
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameCtl.dispose();
    detailCtl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.edit ? pageChange : pageNew),
        centerTitle: true,
      ),
      body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textField(
                      textControl: nameCtl,
                      icon: Icons.title,
                      label: fieldTitle,
                      maxLength: 30),
                  DropdownButton(
                    value: categorie,
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.indigo,
                    ),
                    hint: Text(
                      fieldCat,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                    underline: Container(
                      color: Colors.indigo,
                      height: 1.0,
                    ),
                    items: categories
                        .map((categorie) => DropdownMenuItem(
                            value: categorie, child: Text(categorie)))
                        .toList(),
                    onChanged: (value) => {
                      setState(() {
                        categorie = value;
                      })
                    },
                  ),
                  textField(
                      textControl: detailCtl,
                      icon: Icons.text_fields,
                      label: fieldObj,
                      maxline: null,
                      minLine: 20)
                ],
              ),
            ),
          )),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.indigo,
        tooltip: tipSave,
        child: Icon(Icons.check),
        onPressed: () async {
          saveMemo();
        },
      ),
    );
  }

  textField(
      {TextEditingController textControl,
      IconData icon,
      String label,
      int maxLength,
      int maxline,
      int minLine}) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: textControl,
        maxLength: maxLength,
        maxLines: maxline,
        minLines: minLine,
        decoration: InputDecoration(
          icon: Icon(
            icon,
            color: Colors.indigo,
          ),
          labelText: label,
          labelStyle: TextStyle(fontStyle: FontStyle.italic),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.indigo),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  dialog(String content) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.0),
          ),
          title: Center(
            child: Text(dialTitle),
          ),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text(dialOk),
            )
          ],
        );
      },
    );
  }

  saveMemo() async {
    if (nameCtl.text.isEmpty) {
      dialog(dialContent1);
    } else if (categorie == null) {
      dialog(dialContent2);
    } else {
      if (widget.edit) {
        Memo newMemo = new Memo(
          idMemo: widget.memo.idMemo,
          name: nameCtl.text,
          detail: detailCtl.text,
          categorie: categorie,
          dateCreate: widget.memo.dateCreate,
          dateUpdate: DateTime.now(),
        );
        await DbHelper.db.updateMemo(newMemo);
        Navigator.pop(context, newMemo);
      } else {
        await DbHelper.db.addMemo(
          new Memo(
            name: nameCtl.text,
            detail: detailCtl.text,
            categorie: categorie,
            dateCreate: DateTime.now(),
            dateUpdate: DateTime.now(),
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}
