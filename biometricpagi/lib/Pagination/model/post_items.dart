import 'package:flutter/material.dart';

class PostItem extends StatelessWidget {
  final String description;
  final String name;
  final String language;
  final int watchers_count;
  final int open_issues;

  PostItem(
    this.description,
    this.name,
    this.language,
    this.watchers_count,
    this.open_issues,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Icon(
                  Icons.book,
                  size: 50,
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 17),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 90,
                        child: Text(
                          description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w400),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '<...>',
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                          Text(language.toString()),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.bug_report),
                          Text(open_issues.toString()),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(Icons.supervisor_account_sharp),
                          Text(watchers_count.toString()),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
