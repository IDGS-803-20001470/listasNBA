import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  final String initialValue;

  EditScreen({required this.initialValue});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _textEditingController;
  late TextEditingController _textEditingController2;
  String nombre = '';
  String ruta = '';

  final List<String> imageOptions = [
      './assets/images/nba1.png',
      './assets/images/nba2.png',
      './assets/images/nba3.png',
      './assets/images/nba4.png',
      './assets/images/nba5.png',
      './assets/images/nba6.png',
      './assets/images/nba7.png',
      './assets/images/nba8.png',
      './assets/images/nba9.png',
      './assets/images/nba10.png',
  ];

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: widget.initialValue);
    _textEditingController2 =
        TextEditingController(text: widget.initialValue);

    // Extraer nombre y ruta
    List<String> parts = widget.initialValue.split(';');
    if (parts.length == 2) {
      nombre = parts[0];
      ruta = parts[1];
    }
    _textEditingController =
        TextEditingController(text: nombre);
    _textEditingController2 =
        TextEditingController(text: ruta);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _textEditingController2.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final newValue = _textEditingController.text;
    final newValue2 = _textEditingController.text + ';' + _textEditingController2.text;
    Navigator.pop(context, newValue2);
  }

  Future<void> _selectImageFromAssets() async {
    final selectedImage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Seleccionar imagen'),
          children: imageOptions.map((image) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, image);
              },
              child: ListTile(
                leading: Image.asset(image),
                title: SizedBox.shrink(),
              ),
            );
          }).toList(),
        );
      },
    );

    if (selectedImage != null) {
      setState(() {
        ruta = selectedImage;
        _textEditingController2.text = ruta;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              autofocus: true,
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Modificar',
              ),
              onSubmitted: (value) {
                _saveChanges();
              },
            ),
            SizedBox(height: 16.0),
            GestureDetector(
              onTap: _selectImageFromAssets,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                child: Image.asset(ruta),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}