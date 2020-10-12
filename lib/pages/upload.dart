
import 'dart:io';

import 'package:ecom/grapgql/queryMutation.dart';
import 'package:ecom/main.dart';
import 'package:ecom/pages/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  File _image;
  TextEditingController title = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController image = TextEditingController();
  QueryMutation post=QueryMutation();
  final picker = ImagePicker();
  bool isLoading = false;
  String imageUrl;

  Future<Null> submit() async {
    setState(() {
      isLoading = true;
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    // .child('chats/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String url =await storageReference.getDownloadURL();
    print("image Url" + url);
    // storageReference.getDownloadURL().then((fileURL) {
    //   print(imageUrl);
    //   setState(() {
    //     // imageUrl = fileURL;
    //     fileURL=imageUrl;
    //   });
    // });
    GraphQLClient _client=graphQLConfiguration.clientToQuery();
    QueryResult result= await _client.mutate(
      MutationOptions(
        documentNode: gql(
          post.createProduct(
            url,
            description.text,
            title.text,
            price.text
          )
        )
      )
    );
    if(!result.hasException){
      print("Data");
      if(result.data != null){
        // print("There is Data");
        print(result.data?.data?.toString());
        // print(result.data['login']['token']);
      }else{
        print("There is No data");
      }
      setState(() {
        isLoading=false;
        description.clear();
        title.clear();
        price.clear();
        image.clear();
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
    }else{
      print(result.exception);
    }
  }
  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(DateTime.now().millisecondsSinceEpoch.toString());
    // .child('chats/${Path.basename(_image.path)}}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        imageUrl = fileURL;
      });
    });
  }

  @override
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child:  Column(
            children: [
              GestureDetector(
                onTap: () => getImage(),
                child: Container(
                    color: Colors.yellow[300],
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: _image == null
                        ? Center(
                            child: Text("Select Image"),
                          )
                        : Image.file(
                            _image,
                            fit: BoxFit.fitWidth,
                          )),
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Title",
                ),
                controller: title,
                maxLines: 2,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Cannot be empty";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Image Url",
                ),
                controller: image,
                maxLines: 2,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Cannot be empty";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Price",
                ),
                controller: price,
                maxLines: 2,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Cannot be empty";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Description",
                ),
                controller: description,
                maxLines: 4,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Cannot be empty";
                  } else {
                    return null;
                  }
                },
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : RaisedButton(
                      child: Text("Upload"), onPressed: () => submit())
            ],
          ),
      ),
    );
  }
}
