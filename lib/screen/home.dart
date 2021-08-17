import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:thread_app/data/comment_service.dart';
import 'package:thread_app/model/comment.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  JsonEncoder encoder = new JsonEncoder.withIndent('  ');

  List _commentListMap = [];
  Map<String, dynamic> map = {};
  bool _isLoading = true;
  Future<void> setupPage() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final res = await CommentService.getAllCommentRaw();
      _commentListMap = res.data;
      setState(() {
        _isLoading = false;
      });
    } catch (e, st) {
      print(e);
      print(st);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setupPage();
  }

  List<Widget> resolveComments(List dataList) {
    List<Widget> widgetList = [];

    for (var i = 0; i < dataList.length; i++) {
      var comment = dataList[i];
      widgetList.add(Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Text("${comment["text"].toString()} ${comment["date"].toString()}"),
      ));

      if (comment["children"] != null)
        widgetList.add(Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...resolveComments(comment["children"]),
            ],
          ),
        ));
    }

    return widgetList;
  }

  List buidTree(List arry) {
    var roots = [], children = {};

    // find the top level nodes and hash the children based on parent
    for (var i = 0, len = arry.length; i < len; ++i) {
      var item = arry[i];
      String? p = item["parentId"];
      if (p == null) {
        roots.add({...item as Map});
      } else {
        children[p] = children[p] ?? [];
        children[p].add({...item as Map});
      }
    }

    // function to recursively build the tree
    void findChildren(parent) {
      if (children[parent["id"]] != null) {
        parent["children"] = children[parent["id"]];
        for (var i = 0, len = parent["children"].length; i < len; ++i) {
          findChildren(parent["children"][i]);
        }
      }
    }

    // enumerate through to handle the case where there are multiple roots
    for (var i = 0, len = roots.length; i < len; ++i) {
      findChildren(roots[i]);
    }

    return roots;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        title: Text('Chat App'),
        actions: [
          InkWell(
            onTap: setupPage,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Icon(Icons.refresh_rounded),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: setupPage,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: _isLoading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...resolveComments(buidTree(_commentListMap)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
