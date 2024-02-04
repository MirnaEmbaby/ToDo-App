import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:to_do_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:to_do_app/modules/new_tasks/new_tasks_screen.dart';
import 'package:to_do_app/shared/components/default_form_field.dart';
import 'package:to_do_app/shared/styles/colors.dart';

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
  var formKey = GlobalKey<FormState>();

  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(titles[currentIndex]),
        elevation: 4.0,
        shadowColor: Colors.black,
        backgroundColor: darkBlue,
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
        backgroundColor: darkBlue,
        elevation: 4.0,
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertToDatabase(
                title: titleController.text,
                date: dateController.text,
                time: timeController.text,
              ).then((value) {
                Navigator.pop(context);
                isBottomSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
              });
            }
          } else {
            scaffoldKey.currentState?.showBottomSheet(
              (context) => Material(
                color: lightBlue,
                elevation: 30,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        defaultFormField(
                          controller: titleController,
                          type: TextInputType.text,
                          hasSuffix: false,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Title must not be empty';
                            }
                            return null;
                          },
                          label: "Task title",
                          prefix: Icons.title,
                        )!,
                        const SizedBox(
                          height: 10,
                        ),
                        defaultFormField(
                          controller: timeController,
                          type: TextInputType.none,
                          hasSuffix: false,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Time must not be empty';
                            }
                            return null;
                          },
                          onTap: () {
                            showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            ).then((value) {
                              timeController.text =
                                  value!.format(context).toString();
                            });
                          },
                          label: "Task time",
                          prefix: Icons.watch_later_outlined,
                        )!,
                        const SizedBox(
                          height: 10,
                        ),
                        defaultFormField(
                          controller: dateController,
                          type: TextInputType.none,
                          hasSuffix: false,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Date must not be empty';
                            }
                            return null;
                          },
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.parse('2050-01-01'),
                            ).then((value) {
                              dateController.text =
                                  DateFormat.yMMMd().format(value!);
                            });
                          },
                          label: "Task date",
                          prefix: Icons.calendar_today,
                        )!,
                      ],
                    ),
                  ),
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
        fixedColor: darkBlue,
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

  // Future<String> getName() async {
  //   return 'mmm';
  // }

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

  Future insertToDatabase({
    required String title,
    required String date,
    required String time,
  }) async {
    return await database!.transaction(
      (txn) {
        return txn
            .rawInsert(
                'INSERT INTO tasks(title, date, time, status) VALUES("$title", "$date", "$time", "new")')
            .then((value) {
          debugPrint('$value inserted successfully');
        }).catchError((error) {
          debugPrint('Error when inserting new record ${error.toString()}');
        });
      },
    );
  }
}
