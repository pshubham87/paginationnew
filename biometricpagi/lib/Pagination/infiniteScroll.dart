import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:path_provider/path_provider.dart';
import 'model/data_model.dart';
import 'model/post_items.dart';
import 'model/post_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class InfiniteScrollPaginatorDemo extends StatefulWidget {
  @override
  _InfiniteScrollPaginatorDemoState createState() =>
      _InfiniteScrollPaginatorDemoState();
}

class _InfiniteScrollPaginatorDemoState
    extends State<InfiniteScrollPaginatorDemo> {
  final _numberOfPostsPerRequest = 15;
  final PagingController<int, Post> _pagingController =
      PagingController(firstPageKey: 0);

  bool _error = false;
  List<DataModel> data = [];
  bool hasInternet = true;
  bool connectionModeOn = true;
  late StreamSubscription subscription;
  late StreamSubscription internetSubscription;

  @override
  void initState() {
    getData();
    checkConnection();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  checkConnection() {
    internetSubscription = InternetConnectionChecker().onStatusChange.listen(
      (status) {
        final hasInternet = status == InternetConnectionStatus.connected;
        setState(() {
          this.hasInternet = hasInternet;
          print(hasInternet ? 'has internet conection' : 'no internet');
        });
      },
    );
    subscription =
        Connectivity().onConnectivityChanged.listen((connectivityResult) {
      setState(() {
        if (connectivityResult == ConnectivityResult.mobile) {
          print('mobile data avilable');
          connectionModeOn = true;
        } else if (connectivityResult == ConnectivityResult.wifi) {
          print('wifi available');
          connectionModeOn = true;
        } else {
          print('mobile data and wifi off');
          connectionModeOn = false;
        }
      });
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final response = await get(Uri.parse(
          "https://api.github.com/users/JakeWharton/repos?page=$pageKey&per_page=15"));

      List responseList = json.decode(response.body);
      // await putdata(responseList);
      List<Post> postList = responseList
          .map((data) => Post(
                data['description'] ?? " ",
                data['name'] ?? " ",
                data['language'] ?? " ",
                data['watchers_count'] ?? " ",
                data['open_issues'] ?? " ",
              ))
          .toList();
      clearData();
      for (int i = 0; i < postList.length; i++) {
        addDataItem(
            userId: 1,
            id: 11,
            title: postList[i].description,
            body: postList[i].description);
      }

      final isLastPage = postList.length < _numberOfPostsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(postList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(postList, nextPageKey);
      }
    } catch (e) {
      print('$e');
    }
  }

  Future<void> getData() async {
    Box<DataModel> dataBox = await Hive.openBox<DataModel>('data');
    setState(() {
      data = dataBox.values.toList().cast<DataModel>();
    });
  }

  Future addDataItem({
    required int userId,
    required int id,
    required String title,
    required String body,
  }) async {
    final dataItem = DataModel()
      ..userId = userId
      ..id = id
      ..title = title
      ..body = body;

    var dataBox = await Hive.openBox<DataModel>('data');
    setState(() {
      dataBox.add(dataItem);
      data = dataBox.values.toList().cast<DataModel>();
    });
  }

  void clearData() async {
    Box<DataModel> dataBox = await Hive.openBox<DataModel>('data');
    dataBox.clear();
    getData();
  }

  Widget errorDialog({required double size}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An error occurred when fetching the posts.',
            style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget showOfflineData() {
    return ListView.builder(
      itemCount: data.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            title: Text(data[index].title),
            subtitle: Text(data[index].body),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "jake's Git",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
        ),
      ),
      body: hasInternet && connectionModeOn
          ? RefreshIndicator(
              onRefresh: () => Future.sync(() => _pagingController.refresh()),
              child: Scrollbar(
                thickness: 7,
                child: PagedListView<int, Post>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<Post>(
                      itemBuilder: (context, item, index) {
                    if (index == PostItem) {
                      if (_error) {
                        return Center(
                            child: data.isEmpty
                                ? errorDialog(size: 15)
                                : showOfflineData());
                      } else {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        ));
                      }
                    }
                    return PostItem(
                      item.description,
                      item.name,
                      item.language,
                      item.watchers_count,
                      item.open_issues,
                    );
                  }),
                ),
              ),
            )
          : showOfflineData(),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
