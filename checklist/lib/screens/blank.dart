import 'package:flutter/material.dart';
import 'package:checklist/screens/drawer.dart';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

const List<Widget> categories = <Widget>[
  Icon(Icons.code),
  Icon(Icons.local_activity),
  Icon(Icons.fastfood),
  Icon(Icons.shopping_cart)
];

class ToDo extends StatefulWidget {
  final String? name;
  const ToDo({Key? key, required this.name}) : super(key: key);

  @override
  ToDoState createState() => ToDoState();
}

class ToDoState extends State<ToDo> {
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  final List<List<String>> _todoList = [];
  final TextEditingController _textFieldController1 = TextEditingController();
  final TextEditingController _textFieldController2 = TextEditingController();
  final List<bool> _selectedCategories = <bool>[false, false, false, false];
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadTodoList().then((loadedList) {
      if (loadedList != null) {
        setState(() {
          _todoList.addAll(loadedList);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: BarraLateral(
        name: widget.name,
        onNuevaTarea: openNuevaTareaDialog,
        onEliminarTareas: eliminarTareas,
      ),
      appBar: AppBar(title: const Text('Lista de cosas por hacer')),
      body: ListView(
          padding: const EdgeInsets.only(bottom: 16.0), children: _getItems()),
    );
  }

  Future<void> saveTodoList(List<List<String>> todoList) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> flatList =
        todoList.expand((element) => element).toList();
    await prefs.setStringList('todoList', flatList);
  }

  Future<List<List<String>>?> loadTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    final flatList = prefs.getStringList('todoList');

    if (flatList == null) {
      return null;
    }

    final todoList = <List<String>>[];

    for (int i = 0; i < flatList.length; i += 8) {
      todoList.add(flatList.sublist(i, i + 8));
    }

    return todoList;
  }

  void _addTodoItem(String title, String subtitle, DateTime start, DateTime end,
      List<bool> categories) {
    setState(() {
      _todoList.add([
        title,
        subtitle,
        start.toLocal().toString(),
        end.toLocal().toString(),
        categories[0].toString(),
        categories[1].toString(),
        categories[2].toString(),
        categories[3].toString(),
      ]);
      saveTodoList(_todoList);
    });
    _textFieldController1.clear();
    _textFieldController2.clear();
    for (int i = 0; i < _selectedCategories.length; i++) {
      _selectedCategories[i] = false;
    }
  }

  void _removeTodoItem(int index) {
    setState(() {
      _todoList.removeAt(index);
      saveTodoList(_todoList);
    });
  }

  void setCategories(int index) {
    setState(() {
      _selectedCategories[index] = !_selectedCategories[index];
    });
  }

  Widget _buildTodoItem(
      String title,
      String subtitle,
      DateTime startDate,
      DateTime endDate,
      String codear,
      String flojear,
      String comer,
      String comprar,
      int index) {
    return Card(
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                title),
            Text(
                '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}')
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                subtitle),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (codear == 'true') ...[
                  const Icon(Icons.code),
                  const SizedBox(width: 16), // Adjust the width as needed
                ],
                if (flojear == 'true') ...[
                  const Icon(Icons.local_activity),
                  const SizedBox(width: 16), // Adjust the width as needed
                ],
                if (comer == 'true') ...[
                  const Icon(Icons.fastfood),
                  const SizedBox(width: 16), // Adjust the width as needed
                ],
                if (comprar == 'true') ...[
                  const Icon(Icons.shopping_cart),
                  const SizedBox(width: 16), // Adjust the width as needed
                ],
              ],
            )
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _showDeleteConfirmationDialog(context, index);
          },
        ),
      ),
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedStartDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedEndDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
      });
    }
  }

  Future<void> _displayDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(12),
            title: const Text('Agregar nuevo elemento'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () => _selectStartDate(context),
                        child: const Text('Fecha de Inicio'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => _selectEndDate(context),
                        child: const Text('Fecha de Termino'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text("Nombres"),
                  TextFormField(
                    validator: Validators.required('Título requerido'),
                    controller: _textFieldController1,
                    decoration:
                        const InputDecoration(hintText: 'Escribe el título'),
                  ),
                  const SizedBox(height: 8),
                  const Text("Descripción"),
                  TextField(
                    controller: _textFieldController2,
                    decoration: const InputDecoration(
                        hintText: 'Escribe una descripción'),
                  ),
                  const SizedBox(height: 8),
                  ToggleButtons(
                    onPressed: (int index) {
                      setState(() {
                        _selectedCategories[index] =
                            !_selectedCategories[index];
                      });
                    },
                    selectedColor: Colors.white,
                    fillColor: Colors.green[200],
                    color: Colors.black,
                    isSelected: _selectedCategories,
                    children: categories,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Add'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop();
                    _addTodoItem(
                        _textFieldController1.text,
                        _textFieldController2.text,
                        selectedStartDate,
                        selectedEndDate,
                        _selectedCategories);
                  }
                },
              ),
            ],
          );
        });
      },
    );
  }

  List<Widget> _getItems() {
    final List<Widget> todoWidgets = <Widget>[];
    for (int index = 0; index < _todoList.length; index++) {
      final List<String> row = _todoList[index];
      final DateTime startDate = DateTime.parse(row[2]);
      final DateTime endDate = DateTime.parse(row[3]);
      todoWidgets.add(_buildTodoItem(row[0], row[1], startDate, endDate, row[4],
          row[5], row[6], row[7], index));
    }
    return todoWidgets;
  }

  void _showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content:
              const Text('¿Estas seguro de que deseas eliminar este item?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                _removeTodoItem(index); // Remove the to-do item
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void openNuevaTareaDialog() {
    _displayDialog();
  }

  void eliminarTareas() {
    setState(() {
      while (_todoList.isNotEmpty) {
        _todoList.removeAt(0);
      }
      saveTodoList(_todoList);
    });
  }
}
