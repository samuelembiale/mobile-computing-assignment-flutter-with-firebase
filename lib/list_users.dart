import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_autentication/detail.dart';
import 'package:user_autentication/Constants.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ListPage extends StatefulWidget {

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  FirebaseAuth firebaseAuth;
  var firestore = Firestore.instance;

  Future getPosts() async {
    QuerySnapshot qn = await firestore.collection('users').getDocuments();
    return qn.documents;
  }

  navigateToDetail(DocumentSnapshot post ){
    Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailPage(post: post,)));
  }
  void signOut(String choice) async{
    firebaseAuth = FirebaseAuth.instance;
      await firebaseAuth.signOut();
    Navigator.pop(context);
  }
  void deleteUsers(docId) async{
    await Firestore.instance.collection('users').document(docId).delete().catchError((e){
        print(e);
    });

    print(docId);
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ሰነድ',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new Scaffold(
            appBar: new AppBar(
              title: new Text('ተጠቃሚዎች'),
              actions: <Widget>[
                PopupMenuButton<String>(
                  onSelected: signOut,
                  itemBuilder: (BuildContext context){
                    return Constants.choices.map((String choice){
                      return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                      );
                    }).toList();
                  },
                )
              ],
    ),
    body: Container(
      child: FutureBuilder(
          future: getPosts(),
          builder:(_, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Text('በመጫን ላይ'),
              );
            }else{
              return ListView.builder(
                itemCount : snapshot.data.length,
                itemBuilder: (_,index){
              return Card(
                child: ListTile(
                    leading: Icon(Icons.account_circle),
                  title: Text(snapshot.data[index].data['user name']),
                  subtitle: Text(snapshot.data[index].documentID),

                  onTap: ()=> navigateToDetail(snapshot.data[index]),
                  onLongPress: (){
                    deleteUsers(snapshot.data[index].documentID);
                    setState(() {
                      snapshot.data.removeAt(index);
                    });
                  },
                ),
              );
                });
                  }
          }),
    ),
        ));

  }
}

