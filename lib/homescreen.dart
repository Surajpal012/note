import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:note/models/notes_model.dart';

import 'boxes/boxes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Notes have to do'),

      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: GradientColors.black,
            center: Alignment.center,

          )
        ),
        child: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _){
            var data = box.values.toList().cast<NotesModel>();
            return ListView.builder(
              itemCount: box.length,
                itemBuilder: (context,index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(data[index].title.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                              Spacer(),
                              InkWell(
                                  onTap: (){
                                    _editDialog(data[index], data[index].title.toString(), data[index].description.toString());
                                  },
                                  child: Icon(Icons.edit)),
                              SizedBox(width: 15,),
                              InkWell(
                                onTap: (){
                                  delete(data[index]);
                                },
                                  child: Icon(Icons.delete,color: Colors.red,))
                            ],
                          ),

                          Text(data[index].description.toString(),style: TextStyle(fontWeight: FontWeight.w300,fontSize: 15),),
                        ],
                      ),
                    ),
                  );
                });
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () async {

        _showMyDialog();

      },

      child: Icon(Icons.add),)
    );
  }
  void delete(NotesModel notesModel)async{
    await notesModel.delete();
  }
  Future<void> _editDialog(NotesModel notesModel, String title, String description)async{

    titleController.text = title;
    descriptionController.text = description;
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Edit Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: "Enter Title",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: "Enter Description",
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),
              TextButton(onPressed: ()async{
                notesModel.title  = titleController.text.toString();
                notesModel.description = descriptionController.text.toString();

                await notesModel.save();
                Navigator.pop(context);
              }, child: Text("Save")),
            ],
          );
        }
    );
  }
  Future<void> _showMyDialog()async{
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Add Notes"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Enter Title",
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: "Enter Description",
                        border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("Cancel")),
              TextButton(onPressed: (){
                final data = NotesModel(title: titleController.text, description: descriptionController.text);

                final box = Boxes.getData();
                box.add(data);

                //data.save();
                
                print(box);
                titleController.clear();
                descriptionController.clear();
                Navigator.pop(context);
              }, child: Text("Add")),
            ],
          );
        }
    );
  }
}

