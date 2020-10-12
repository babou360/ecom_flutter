

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecom/pages/upload.dart';
import 'package:ecom/pages/upload1.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String users= """ query{
  products{
    id
    imageUrl
    description
    title
    price
  }
} """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed:(){
         Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Upload(
              // builder: (context) => PickImage(
                )));
        }),
      appBar: AppBar(
        centerTitle: true,
        title: Text("This is GraphQl"),
      ),
      body: Query(options: QueryOptions(
        documentNode: gql(users),
      ), builder: (QueryResult result, {VoidCallback refetch,FetchMore fetchMore})
      {
        if(result.hasException){
         return Text(result.exception.toString());
        }
        if(result.loading){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          itemCount: result.data['products'].length,
          // itemCount: 4,
          itemBuilder: (BuildContext context,int index){
            final posts = result.data['products'][index];
            return Column(
             children: [
                Container(
                   color: Colors.grey,
                   child: Column(
                     children: [
                       Container(
                        width: MediaQuery.of(context).size.width,
                         height: 200,
                        child: Image.network(posts['imageUrl'],width: 300,height: 300,),
                        // child: Icon(Icons.image,size: 200,),
                      ),
                      Text(posts['description']),
                      // Text(posts['title']),
                      // Text(posts['price']),
                      // Text(posts['id'].toString()),
                      // Text(posts['imageUrl']),
                      // Text(result.data['products'].length.toString()),
                     ],
                   ),
                 ),
               Divider()
             ], 
            );
          // return ListTile(
          //   leading: Text(result.data['posts'][index]['des'].toString()),
          //   title: Text(result.data['users'][index]['email']),
          //   subtitle: Text(result.data['users'][index]['password']),
          // );
        });
      })
    );
  }
}