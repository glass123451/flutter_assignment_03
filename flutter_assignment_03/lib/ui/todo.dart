import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Firestore _store = Firestore.instance;

class TodoPage extends StatefulWidget{
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage>{

  int _tapState = 0;
  
  Widget build(BuildContext context){
    Container todoList = new Container(
      child: StreamBuilder(
        stream: _store.collection('todo').where('done', isEqualTo: false).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            if (snapshot.data.documents.length == 0){
              return Center(
                child: Text('No data found...'),
              );
            }
            else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    title: Text(snapshot.data.documents.elementAt(index).data['title']),
                    trailing: Checkbox(
                      value: snapshot.data.documents.elementAt(index).data['done'],
                      onChanged: (bool isCheck) async {
                        _store.collection('todo').document(snapshot.data.documents.elementAt(index).documentID).updateData({'done':isCheck});
                      },
                    ),
                  );
                },
              );
            }
          }
          else{
            return Center(
              child: new CircularProgressIndicator(),
            );
          }
        },
      ),
    );

    Container doneList = new Container(
      child: StreamBuilder(
        stream: _store.collection('todo').where('done', isEqualTo: true).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasData){
            if (snapshot.data.documents.length == 0){
              return Center(
                child: Text('No data found...'),
              );
            }
            else{
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index){
                  return ListTile(
                    title: Text(snapshot.data.documents.elementAt(index).data['title']),
                    trailing: Checkbox(
                      value: snapshot.data.documents.elementAt(index).data['done'],
                      onChanged: (bool isCheck){
                        _store.collection('todo').document(snapshot.data.documents.elementAt(index).documentID).updateData({'done':isCheck});
                      }
                    ),
                  );
                },
              );
            }
          }
          else{
            return Center(
              child: new CircularProgressIndicator(),
            );
          }
        },
      ),
    );

    Row todoAppBar = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Todo'),
        IconButton(
          icon: Icon(Icons.add),
          color: Colors.white,
          onPressed: (){
            Navigator.pushNamed(context, '/addTodo');
          },
        ),
      ],
    );

    Row doneAppBar = new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('Todo'),
        IconButton(
          icon: Icon(Icons.delete),
          color: Colors.white,
          onPressed: (){
            _store.collection('todo').getDocuments().then((snapshot){
              for(DocumentSnapshot ds in snapshot.documents){
                if(ds.data['done'])
                  ds.reference.delete();
              }
            });
          },
        ),
      ],
    );

  
    return DefaultTabController(
      initialIndex: _tapState,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: TabBarView(
            children: <Widget>[
              todoAppBar,
              doneAppBar,
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            todoList,
            doneList,
          ],
        ),
        bottomNavigationBar: TabBar(
          indicatorColor: Colors.redAccent,
          labelColor: Colors.redAccent,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.list),
              text: 'Task',
            ),
            Tab(
              icon: Icon(Icons.done_all),
              text: 'Completed',
            ),
          ],
        ),
      ),
      
    );
  }
}