// import 'dart:html';

import 'package:ecom/grapgql/queryMutation.dart';
import 'package:ecom/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../main.dart';

class Upload1 extends StatefulWidget {
  @override
  _Upload1State createState() => _Upload1State();
}

class _Upload1State extends State<Upload1> {
  TextEditingController imageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  QueryMutation addMutation = QueryMutation();
  String imageUrl;
  String description;
  String title;
  String price;
  bool isLoading=false;

    Future<Null> submit() async {
    setState(() {
      isLoading = true;
    });
    GraphQLClient _client = graphQLConfiguration.clientToQuery();
    QueryResult result= await _client.mutate(
      MutationOptions(
        documentNode: gql(
          addMutation.createProduct(
            imageUrl,
            description,
            title,
            price

            )
        )
      )
    );
    if(!result.hasException){
      if(result.data != null){
        // print("There is Data");
        print(result.data?.data?.toString());
        // print(result.data['login']['token']);
      }else{
        print("There is No data");
      }
      setState(() {
        isLoading=false;
        imageController.clear();
        descriptionController.clear();
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
    }
  }
  String register = '''
 mutation{
  createPost(imageUrl:"www.google.com",description:"This is My first post"){
    id
    description
  }
} ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Upload Page"),
        ),
        body:Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                        decoration: InputDecoration(hintText: "imageUrl"),
                        controller: imageController,
                        onChanged: (input) => imageUrl = input),
                        TextField(
                        decoration: InputDecoration(hintText: "description"),
                        controller: descriptionController,
                        onChanged: (input) => description = input),
                        TextField(
                        decoration: InputDecoration(hintText: "title"),
                        controller: titleController,
                        onChanged: (input) => title = input),
                    TextField(
                        decoration: InputDecoration(hintText: "price"),
                        controller: priceController,
                        onChanged: (input) => title = input),
                        Center(
                          child: isLoading
                          ?CircularProgressIndicator()
                          :RaisedButton(
                        child: Text("submit"),
                        onPressed: ()=>{
                          submit()
                        },
                        )),
                  ],
                ),
              ));
  }
}
