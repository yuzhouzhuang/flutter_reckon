import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutterApp/theme.dart';

class SelectChip extends StatefulWidget {
  final String eventId;
  final String itemId;
  final String userId;

  const SelectChip({Key key, this.eventId, this.itemId, this.userId})
      : super(key: key);

  @override
  _SelectChipState createState() => _SelectChipState();
}

class _SelectChipState extends State<SelectChip> {
  int tag = 1;
  String title = 'loading';
  String itemValue = '£0.00';
//  List<String> tags = [];

  List<String> options = [
    'food',
    'alcohol',
    'dessert',
  ];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: Firestore.instance
          .collection('Events')
          .document(widget.eventId)
          .collection('Menu')
          .document(widget.itemId)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          tag = snapshot.data['itemType'];
          title = snapshot.data['itemName'];
          itemValue = '£' + snapshot.data['itemValue'].toString();
          if (!itemValue.contains('.')) {
            itemValue += '.0';
          }
          return Card(
            elevation: 2,
            margin: EdgeInsets.all(5),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(15, 13, 15, 17),
                  color: MyColors.primaryColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: TextFormField(
//                          maxLength: 60,
                          initialValue: title,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          onFieldSubmitted: (text) async {
                            title = text;
                            await Firestore.instance
                                .collection('Events')
                                .document(widget.eventId)
                                .collection('Menu')
                                .document(widget.itemId)
                                .updateData({'itemName': text});
                          },
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
//                          maxLength: 60,
                          initialValue: itemValue,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          onFieldSubmitted: (text) async {
                            itemValue = text;
                            await Firestore.instance
                                .collection('Events')
                                .document(widget.eventId)
                                .collection('Menu')
                                .document(widget.itemId)
                                .updateData({
                              'itemValue': double.parse(text.substring(1))
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                ChipsChoice<int>.single(
                  //TODO
                  value: tag,
                  options: ChipsChoiceOption.listFrom<int, String>(
                    source: options,
                    value: (i, v) => i,
                    label: (i, v) => v,
                  ),
                  onChanged: (val) async {
                    setState(() {
                      tag = val;
                    });

                    await Firestore.instance
                        .collection('Events')
                        .document(widget.eventId)
                        .collection('Menu')
                        .document(widget.itemId)
                        .updateData({'itemType': tag});
                  },
                ),
              ],
            ),
          );
        }
        return Card(
          elevation: 2,
          margin: EdgeInsets.all(5),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(15),
                height: 70,
                color: MyColors.primaryColor,
                child: Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Text(
                          title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          itemValue,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ChipsChoice<int>.single(
                //TODO
                value: tag,
                options: ChipsChoiceOption.listFrom<int, String>(
                  source: options,
                  value: (i, v) => i,
                  label: (i, v) => v,
                ),
                onChanged: (val) => setState(() async {
                  tag = val;
                  await Firestore.instance
                      .collection('Events')
                      .document(widget.eventId)
                      .collection('Menu')
                      .document(widget.itemId)
                      .updateData({'itemType': tag});
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Content extends StatelessWidget {
  final String title;
  final Widget child;

  Content({
    Key key,
    @required this.title,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.all(5),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            color: MyColors.primaryColor,
            child: Text(
              title,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
