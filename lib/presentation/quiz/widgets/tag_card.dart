import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tags/flutter_tags.dart';

import '../../../bloc/quiz/quiz_bloc.dart';

class TagCard extends StatefulWidget {
  final List<String> _tags;
  TagCard({Key key, @required List<String> tags})
      : assert(tags != null),
        _tags = tags,
        super(key: key);

  @override
  _TagCardState createState() => _TagCardState();
}

class _TagCardState extends State<TagCard> {
  final List<String> _selectedTags = [];

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.white70, Colors.grey[200]]),
            borderRadius: BorderRadius.circular(20),
            color: Colors.white),
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Saved Tags',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: EdgeInsets.all(16),
                child: Tags(
                  itemCount: widget._tags.length,
                  itemBuilder: (index) {
                    final tag = widget._tags[index];

                    return ItemTags(
                      index: index,
                      title: tag,
                      activeColor: Colors.green[200],
                      onPressed: (i) {
                        if (i.active) {
                          _selectedTags.remove(i.title);
                        } else {
                          _selectedTags.add(i.title);
                        }
                      },
                    );
                  },
                )),
            Padding(
                padding: EdgeInsets.all(20),
                child: ButtonTheme(
                    minWidth: 200,
                    height: 50,
                    child: OutlineButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Text(
                        'Remove Selected',
                        style: TextStyle(fontSize: 16),
                      ),
                      onPressed: () {
                        BlocProvider.of<QuizBloc>(context)
                            .add(RemoveTags(toRemove: _selectedTags));
                      },
                    ))),
            ButtonTheme(
                minWidth: 200,
                height: 50,
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100))),
                  child: Text(
                    'Save Tags',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    BlocProvider.of<QuizBloc>(context).add(SaveTags());
                    Navigator.pop(context);
                  },
                ))
          ],
        ),
      ),
    );
  }
}
