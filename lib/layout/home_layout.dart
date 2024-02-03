import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_app/shared/components/default_form_field.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens = [
    const NewTasksScreen(),
    const DoneTasksScreen(),
    const ArchivedTasksScreen(),
  ];
  List<String> titles = [
    'New tasks',
    'Done tasks',
    'Archived tasks',
  ];

  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  late Database? database;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        // onPressed: () async {
        //   try {
        //     var name = await getName();
        //     print(name);
        //
        //     throw ('some error!!!!!');
        //   } catch (error) {
        //     print('error ${error.toString()}');
        //   }
        // },

        // onPressed: () {
        //   getName().then((value) {
        //     debugPrint(value);
        //     debugPrint('get name is done');
        //     throw ('hona yougad error hehe');
        //   }).catchError((error) {
        //     debugPrint('error is ${error.toString()}');
        //   }, test: (error) {
        //     return error is int && error >= 400;
        //   });
        // },

        onPressed: () {
          if (isBottomSheetShown) {
            Navigator.pop(context);
            isBottomSheetShown = false;
            setState(() {
              fabIcon = Icons.edit;
            });
          } else {
            scaffoldKey.currentState?.showBottomSheet(
              (context) => Container(
                color: Colors.grey[200],
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    defaultFormField(
                      controller: titleController,
                      type: TextInputType.text,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'Title must not be empty';
                        }
                        return null;
                      },
                      label: "Task title",
                      prefix: Icons.title,
                    )!
                  ],
                ),
              ),
            );
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_outlined),
            label: 'Done',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            label: 'Archived',
          ),
        ],
      ),
    );
  }

  Future<String> getName() async {
    return 'mmm';
  }

  void createDatabase() async {
    database = await openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        debugPrint('database created');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          debugPrint('Table created');
        }).catchError((error) {
          debugPrint('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        if (kDebugMode) {
          print('database opened');
        }
      },
    );
  }

  void insertToDatabase() {
    database!.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks(title, date, time, status) VALUES("first task", "3456", "9876", "new")')
          .then((value) {
        debugPrint('$value inserted successfully');
      }).catchError((error) {
        debugPrint('Error when inserting new record ${error.toString()}');
      });
    });
  }
}
