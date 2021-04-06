import 'package:memo/util/dbHelper.dart';

class Memo {
  int idMemo;
  String name;
  String detail;
  String categorie;
  DateTime dateCreate;
  DateTime dateUpdate;

  Memo(
      {this.idMemo,
      this.name,
      this.detail,
      this.categorie,
      this.dateCreate,
      this.dateUpdate});

  factory Memo.fromMap(Map<String, dynamic> data) => new Memo(
        idMemo: data[DbHelper.db.colId],
        name: data[DbHelper.db.colName],
        detail: data[DbHelper.db.colDetail],
        categorie: data[DbHelper.db.colCategorie],
        dateCreate: DateTime.tryParse(data[DbHelper.db.colDateCreate]),
        dateUpdate: DateTime.tryParse(data[DbHelper.db.colDateUpdate]),
      );

  Map<String, dynamic> toMap() => {
        DbHelper.db.colId: idMemo,
        DbHelper.db.colName: name,
        DbHelper.db.colDetail: detail,
        DbHelper.db.colCategorie: categorie,
        DbHelper.db.colDateCreate: dateCreate.toString(),
        DbHelper.db.colDateUpdate: dateUpdate.toString(),
      };
}
