import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Firestore _store = Firestore.instance;

class AddTodoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState(){
    return new AddTodoPageState();
  }
}

class AddTodoPageState extends State<AddTodoPage> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _subjectName = '';
  
  Widget build(BuildContext context){
    //Text field of subject
    TextFormField subject = new TextFormField(
      decoration: const InputDecoration(
        labelText: 'Subject',
      ),
      onSaved: (v) => _subjectName = v,
      validator: (subjectName){
        if (subjectName.isEmpty)
          return 'Please fill subject';
        else
          _subjectName = subjectName;
      },
    );

    //validate functionw
    void _ValidateInput() async {
      _formKey.currentState.validate();
      if (_subjectName.isEmpty){
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: new Text('Please fill subject'),
          ),
        );
      }
      else{
        _store.collection('todo').add({'title':_subjectName, 'done':false});
        Navigator.pop(context);
      }
    }

    //save button
    RaisedButton saveButton = new RaisedButton(
      child: Text('Save'),
      color: Colors.lightGreen,
      textColor: Colors.white,
      onPressed: _ValidateInput,
    );
  
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: Text("New Subject"),
        backgroundColor: Colors.redAccent,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
            children: <Widget>[
              subject,
              saveButton,
            ],
          ),
        ),
      ),
    );
  }
}