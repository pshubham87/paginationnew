// import 'dart:convert';
// import 'package:biometricpagi/Pagination/model/data_model.dart';
// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:http/http.dart';
// import 'package:path_provider/path_provider.dart';
// import 'Pagination/model/post_items.dart';
// import 'Pagination/model/post_model.dart';
// // import 'package:pagination_task/post_items.dart';
// // import 'package:pagination_task/post_model.dart';

// class ScrollControllerDemo extends StatefulWidget {
//   @override
//   _ScrollControllerDemoState createState() => _ScrollControllerDemoState();
// }

// class _ScrollControllerDemoState extends State<ScrollControllerDemo> {
//   List<Post> _posts = [];
//   List<DataModel> data = [];
//   bool loading = false;

//   late bool _isLastPage;
//   late int _pageNumber;
//   late bool _error;
//   late bool _loading;
//   late int _numberOfPostsPerRequest;

//   late ScrollController _scrollController;

//   @override
//   void initState() {
//     super.initState();
//     _pageNumber = 0;
//     _posts = [];
//     _isLastPage = false;
//     _loading = true;
//     _error = false;
//     _numberOfPostsPerRequest = 10;
//     _scrollController = ScrollController();
//     getAllData();
//     getData();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _scrollController.dispose();
//   }

//    getAllData() async {
//     try {
//       final response = await get(Uri.parse(
//           "https://jsonplaceholder.typicode.com/posts?_page=$_pageNumber&_limit=$_numberOfPostsPerRequest"));
//       List responseList = json.decode(response.body);

//       List<Post> postList = responseList
//           .map((data) => Post(
//                 userId: data['userId'] ?? " ",
//                 id: data['id'] ?? " ",
//                 title: data['title'] ?? " ",
//                 body: data['body'] ?? " ",
//               ))
//           .toList();
     
//       setState(() {
//         _isLastPage = postList.length < _numberOfPostsPerRequest;
//         _loading = false;
//         _pageNumber = _pageNumber + 1;
//         _posts.addAll(postList);
//         clearData();
//         for (int i = 0; i < _posts.length; i++) {
//           addDataItem(
//               userId: _posts[i].userId,
//               id: _posts[i].id,
//               title: _posts[i].title,
//               body: _posts[i].body);
//         }
//       });
//     } catch (e) {
//       print("error --> $e");
//       setState(() {
//         _loading = false;
//         _error = true;
//       });
//     }

//     return Future.value(true);
//   }

//   Future<void> getData() async {
//     Box<DataModel> dataBox = await Hive.openBox<DataModel>('data');
//     setState(() {
//       data = dataBox.values.toList().cast<DataModel>();
//     });
//   }

//   Future addDataItem({
//     required int userId,
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     final dataItem = DataModel()
//       ..userId = userId
//       ..id = id
//       ..title = title
//       ..body = body;

//     var dataBox = await Hive.openBox<DataModel>('data');
//     setState(() {
//       dataBox.add(dataItem);
//       data = dataBox.values.toList().cast<DataModel>();
//     });
//   }

//   void clearData() async {
//     Box<DataModel> dataBox = await Hive.openBox<DataModel>('data');
//     dataBox.clear();
//     getData();
//   }

//   Widget errorDialog({required double size}) {
//     return SizedBox(
//       height: 180,
//       width: 200,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'An error occurred when fetching the posts.',
//             style: TextStyle(
//                 fontSize: size,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.black),
//           ),
//           const SizedBox(
//             height: 10,
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _loading = true;
//                   _error = false;
//                   getAllData();
//                 });
//               },
//               child: const Text(
//                 "Retry",
//                 style: TextStyle(fontSize: 20, color: Colors.purpleAccent),
//               )),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     _scrollController.addListener(() {
//       // nextPageTrigger will have a value equivalent to 80% of the list size.
//       var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

//       if (_scrollController.position.pixels > nextPageTrigger) {
//         _loading = true;
//         getAllData();
//       }
//     });

//     return Scaffold(
//       body: SafeArea(
//         child: Center(
//           child: FutureBuilder(
//             future: getAllData(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 if (snapshot.hasError) {
//                   return errorDialog(size: 15);
//                 } else if (snapshot.hasData) {
//                   return Column(
//                     children: [
//                       Expanded(
//                           child: ListView.builder(
//                         itemCount: _posts.length,
//                         itemBuilder: (context, index) {
//                           return Card(
//                               elevation: 4,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(15)),
//                               child: ListTile(
//                                 title: Text(_posts[index].title),
//                                 subtitle: Text(_posts[index].body),
//                               ));
//                         },
//                       ))
//                     ],
//                   );
//                 }
//               }
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             },

//             // ListView.builder(
//             //   itemCount: data.length,
//             //   padding: const EdgeInsets.all(8),
//             //   itemBuilder: (context, index) {
//             //     return Card(
//             //       elevation: 4,
//             //       shape: RoundedRectangleBorder(
//             //           borderRadius: BorderRadius.circular(15)),
//             //       child: ListTile(
//             //         title: Text(data[index].title),
//             //         subtitle: Text(data[index].body),
//             //       ),
//             //     );
//             //   },
//             // ),
//           ),
//         ),
//       ),
//     );
//   }
// }
