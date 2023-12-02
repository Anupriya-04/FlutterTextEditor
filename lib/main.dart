import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TextEditorPage(),
    );
  }
}

class TextEditorPage extends StatefulWidget {
  @override
  _TextEditorPageState createState() => _TextEditorPageState();
}

class _TextEditorPageState extends State<TextEditorPage> {
  List<String> texts = [''];
  double fontSize = 20.0;
  Color textColor = Colors.black;
  FontWeight fontWeight = FontWeight.normal;
  List<List<String>> undoStack = [];
  List<List<String>> redoStack = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Editor'),
      ),
      body: Stack(
        children: [
          Image.asset(
            'images/bg3.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: texts.length,
                      itemBuilder: (context, index) {
                        return Text(
                          texts[index],
                          style: GoogleFonts.getFont(
                            'Lato',
                            fontSize: fontSize,
                            color: textColor,
                            fontWeight: fontWeight,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showAddTextDialog();
                      },
                      child: Text('Add Text'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _showEditFontDialog();
                      },
                      child: Text('Edit Font'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _showEditSizeDialog();
                      },
                      child: Text('Edit Size'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _showEditColorDialog();
                      },
                      child: Text('Edit Color'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _undo();
                  },
                  child: Text('Undo'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _redo();
                  },
                  child: Text('Redo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTextDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newText = '';

        return AlertDialog(
          title: Text('Add Text'),
          content: TextField(
            onChanged: (value) {
              newText = value;
            },
            decoration: InputDecoration(
              hintText: 'Enter text',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _addToUndoStack();
                  texts.add(newText);
                });
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _showEditFontDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Font'),
          content: Column(
            children: [
              Text('Select a font weight:'),
              DropdownButton<FontWeight>(
                value: fontWeight,
                onChanged: (FontWeight? value) {
                  setState(() {
                    _addToUndoStack();
                    fontWeight = value ?? FontWeight.normal;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: FontWeight.normal,
                    child: Text('Normal'),
                  ),
                  DropdownMenuItem(
                    value: FontWeight.bold,
                    child: Text('Bold'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _showEditSizeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Size'),
          content: Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    _addToUndoStack();
                    fontSize = fontSize - 1.0;
                  });
                },
              ),
              Expanded(
                child: Text(
                  fontSize.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _addToUndoStack();
                    fontSize = fontSize + 1.0;
                  });
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _showEditColorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Color'),
          content: ColorPicker(
            pickerColor: textColor,
            onColorChanged: (Color color) {
              setState(() {
                _addToUndoStack();
                textColor = color;
              });
            },
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _addToUndoStack() {
    undoStack.add([...texts]);
    redoStack.clear();
  }

  void _undo() {
    if (undoStack.length > 1) {
      setState(() {
        redoStack.add([...texts]);
        undoStack.removeLast();
        texts = [...undoStack.last];
      });
    }
  }

  void _redo() {
    if (redoStack.isNotEmpty) {
      setState(() {
        undoStack.add([...texts]);
        texts = [...redoStack.last];
        redoStack.removeLast();
      });
    }
  }
}
