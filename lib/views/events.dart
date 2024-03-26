import 'dart:io';

import 'package:emergency_app/main.dart';
import 'package:flutter/material.dart';
import 'package:emergency_app/database/database.dart';
import 'package:emergency_app/helpers/datetime.dart';
import 'package:image_picker/image_picker.dart';

class CreateEvents extends StatefulWidget {
  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  DatabaseHelper dbhelper = DatabaseHelper();
  final date = getDate();

  TextEditingController tituloController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  File? _image;
  String? _imagePath;

  Future<void> _getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
        _imagePath = pickedImage.path;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Eventos'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: tituloController,
              decoration: InputDecoration(labelText: 'Ingrese el titulo'),
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 15.0,
            ),
            TextField(
              controller: descripcionController,
              maxLines: null,
              decoration: InputDecoration(
                  labelText: 'Ingrese el titulo', border: OutlineInputBorder()),
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 15.0,
            ),
            _image != null
                ? Image.file(_image!,
                    height: 100, width: 100, fit: BoxFit.cover)
                : Container(),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _getImage(ImageSource.camera);
                    },
                    child: Text('Tomar Foto')),
                ElevatedButton(
                    onPressed: () {
                      _getImage(ImageSource.gallery);
                    },
                    child: Text('Seleccionar de Galeria'))
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final titulo = tituloController.text;
          final descripcion = descripcionController.text;

          try {
            String foto = _imagePath ?? '';

            await dbhelper.insertEvento({
              'fecha': date,
              'titulo': titulo,
              'descripcion': descripcion,
              'foto': foto
            });

            print('data guardada satisfactoriamente');

            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => MyHomePage()));
          } catch (e) {
            print('Error saving data: $e');
          }
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
      ),
    );
  }
}
