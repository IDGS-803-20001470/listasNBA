import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_screen.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imagePath = './assets/images/nba.png';
  List<String> items = [];

  TextEditingController textController = TextEditingController();
  ImageProvider? selectedImagePreview;

  int colorIndex = 0;

  @override
  void initState() {
    super.initState();
    loadShared();
  }

  Future<void> loadShared() async {
    final prefs = await SharedPreferences.getInstance();
    //prefs.clear();
    setState(() {
      items = prefs.getStringList("valores") ?? [];
    });
  }

  Future<void> saveShared() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('valores', items);
  }

  Future<void> selectImage() async {
    final selectedImage = await selectImageFromAssets();
    if (selectedImage != null) {
      setState(() {
        imagePath = selectedImage;
      });
    }
  }

  //Metodo para generear colores claros random
  Color getRandomColor() {
    final Random random = Random();
    int minBrightness = 200; // Establece el brillo mínimo deseado (0-255)

    Color generateColor() {
      return Color.fromARGB(
        255,
        minBrightness +
            random.nextInt(56), // Rango de valores más altos para el rojo
        minBrightness +
            random.nextInt(56), // Rango de valores más altos para el verde
        minBrightness +
            random.nextInt(56), // Rango de valores más altos para el azul
      );
    }

    Color color = generateColor();
    while (color.computeLuminance() < 0.5) {
      // Verifica si el color generado es lo suficientemente claro (luminancia > 0.5)
      color = generateColor();
    }

    return color;
  }

  Future<String?> selectImageFromAssets() async {
    final images = [
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

    final selectedImage = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Selecciona una imagen'),
          content: Container(
            width: double.maxFinite,
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              children: images.map((image) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, image);
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    child: Image.asset(
                      image,
                      height: 20,
                      width: 20,
                      //color: Colors.red,
                      
                      colorBlendMode: BlendMode.darken,
                      //fit: BoxFit.fitWidth,
                      //fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    return selectedImage;
  }

  Widget buildSelectedImagePreview() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  void _navigateToEditScreen(int index) async {
    final editedItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditScreen(initialValue: items[index]),
      ),
    );

    if (editedItem != null) {
      setState(() {
        items[index] = editedItem;
        saveShared();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          items.removeAt(index);
                          saveShared();
                        });
                      },
                      secondaryBackground: Container(
                        child: Align(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              Text(
                                ' Borrar   ',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        color: Color.fromARGB(255, 10, 17, 60),
                      ),
                      child: Card(
                        color: getRandomColor(),
                        child: ListTile(
                          title: Text(
                            items[index].split(';')[0],
                            style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0)),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Color.fromARGB(221, 15, 89, 142),
                            radius: 20,
                            child: items[index].split(';')[1] != ''
                                ? Image.asset(
                                    items[index].split(';')[1],
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  )
                                : Text(
                                    items[index].split(';')[0].substring(0, 1),
                                    style: TextStyle(
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0)),
                                  ),
                          ),
                          trailing: Wrap(
                            spacing: 5,
                            children: [
                              IconButton(
                                onPressed: () {
                                  _navigateToEditScreen(index);
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                                splashRadius: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              height: 70,
              child: Padding(
                padding: const EdgeInsets.all(13.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              items.add(value);
                              saveShared();
                            });
                            textController.clear();
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Agregar',
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await selectImage();
                      },
                      child: Icon(Icons.image),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          items.add('${textController.text};$imagePath');
                          textController.clear();
                          saveShared();
                          imagePath = './assets/images/nba.png';
                        });
                      },
                      child: Icon(Icons.save),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            buildSelectedImagePreview(),
          ],
        ),
      ),
    );
  }
}
