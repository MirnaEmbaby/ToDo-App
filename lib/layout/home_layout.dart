import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/shared/components/components.dart';
import 'package:to_do_app/shared/cubit/cubit.dart';
import 'package:to_do_app/shared/cubit/states.dart';
import 'package:to_do_app/shared/styles/colors.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex]),
              elevation: 4.0,
              shadowColor: Colors.black,
              backgroundColor: darkBlue,
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => const Center(
                child: CircularProgressIndicator(
                  color: darkBlue,
                ),
              ),
            ),
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
              //     throw ('error');
              //   }).catchError((error) {
              //     debugPrint('error is ${error.toString()}');
              //   }, test: (error) {
              //     return error is int && error >= 400;
              //   });
              // },
              backgroundColor: darkBlue,
              elevation: 4.0,
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      date: dateController.text,
                      time: timeController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState
                      ?.showBottomSheet(
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
                              child: SingleChildScrollView(
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
                                          barrierColor: darkBlue,
                                          initialTime: TimeOfDay.now(),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme:
                                                    const ColorScheme.light(
                                                  primary: darkBlue,
                                                  onPrimary: Colors.white,
                                                  onSurface: darkBlue,
                                                  onBackground: darkBlue,
                                                  onPrimaryContainer:
                                                      Colors.white,
                                                  tertiary: darkBlue,
                                                ),
                                                textButtonTheme:
                                                    TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: darkBlue,
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
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
                                          lastDate:
                                              DateTime.parse('2050-01-01'),
                                          builder: (context, child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme:
                                                const ColorScheme.light(
                                                  primary: darkBlue,
                                                  onPrimary: Colors.white,
                                                  onSurface: darkBlue,
                                                  onBackground: darkBlue,
                                                  onPrimaryContainer:
                                                  Colors.white,
                                                  tertiary: darkBlue,
                                                ),
                                                textButtonTheme:
                                                TextButtonThemeData(
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: darkBlue,
                                                  ),
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
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
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                      isShown: false,
                      icon: Icons.edit,
                    );
                  });
                  cubit.changeBottomSheetState(
                    isShown: true,
                    icon: Icons.add,
                  );
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
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
        },
      ),
    );
  }

// Future<String> getName() async {
//   return 'mmm';
// }
}
