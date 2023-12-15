import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/size_config.dart';
import 'package:to_do_list/theme.dart';
import 'package:to_do_list/ui/views/widgets/input_field.dart';

import '../../controllers/task_controller.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  final TaskController _taskController =
      Get.put(TaskController()); //  object of TaskController
  int _selectedColor = 0;
  // final String _selectedRepeat = 'none';
  List<String> repeatList = ['None', 'Daily', 'Weekly', 'Monthly'];
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = DateFormat('hh:mm a')
      .format(DateTime.now().add(const Duration(minutes: 15)))
      .toString();
  final TextEditingController _titleControler = TextEditingController();
  final TextEditingController _noteControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: w,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text('Add Task', style: headingStyle),
              InputField(
                title: 'Title',
                hint: 'Enter something',
                controller: _titleControler,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter Note here',
                controller: _noteControler,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: () async {
                    DateTime? pickeredDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050),
                    );
                    setState(() {
                      _selectedDate = pickeredDate!;
                    });
                  },
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                        icon: const Icon(
                          Icons.access_time_rounded,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _selectColorTask(),
                  ElevatedButton(
                    onPressed: () {
                      _validateData();
                    },
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      textStyle: MaterialStateProperty.all(
                          const TextStyle(fontSize: 20)),
                      backgroundColor: MaterialStatePropertyAll(primary),
                      foregroundColor: MaterialStatePropertyAll(w),
                      minimumSize: MaterialStateProperty.all(
                        const Size(140, 60),
                      ),
                    ),
                    child: const Text('Create Task'),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Image.asset(
                'assets/images/task.jpg',
                width: SizeConfig.screenWidth *0.5,
              )
            ],
          ),
        ),
      ),
    );
  }

  _validateData() {
    if (_titleControler.text.isNotEmpty && _noteControler.text.isNotEmpty) {
      _addTasksToDB();
      Get.back();
    } else if (_titleControler.text.isEmpty || _noteControler.text.isEmpty) {
      Get.snackbar(
        'required',
        'All fields are required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: w,
        colorText: Colors.pink,
        icon: const Icon(
          Icons.warning_amber_outlined,
          color: Colors.red,
        ),
      );
    } else {
      print('############ SOMETHING BAD HAPPENED #################');
    }
  }

  _addTasksToDB() async {
    try {
      int value = await _taskController.addTask(
        task: Task(
          title: _titleControler.text,
          note: _noteControler.text,
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          isCompleted: 0,
          color: _selectedColor,
          //repeat:_selectedRepeat,
        ),
      );
    } catch (e) {
      print('Error');
    }
  }

  Column _selectColorTask() {
    return Column(
      children: [
        Text('Color', style: titleStyle),
        const SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(
              3,
              (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = index;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: CircleAvatar(
                        backgroundColor: index == 0
                            ? primary
                            : index == 1
                                ? Colors.pink
                                : Colors.orange,
                        radius: 14,
                        child: _selectedColor == index
                            ? Icon(Icons.done, color: w)
                            : null,
                      ),
                    ),
                  )),
        )
      ],
    );
  }

  _getTimeFromUser({required bool isStartTime}) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialEntryMode: TimePickerEntryMode
          .input, // this is way that user will select by it the time
      context: context,
      initialTime: isStartTime
          ? TimeOfDay.fromDateTime(DateTime.now())
          : TimeOfDay.fromDateTime(
              DateTime.now().add(const Duration(minutes: 15))),
    );
    String formattedTime = pickedTime!.format(
        context); // converting pickedTime from TimeOfDay to String  because _startTime & _endTime are String
    if (isStartTime) {
      setState(() => _startTime = formattedTime);
    } else if (!isStartTime)
      setState(() => _endTime = formattedTime);
    else {
      print('time canceld or something is wrong');
      Get.back();
    }
  }

  AppBar _appBar() => AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 24,
            color: primary,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        backgroundColor: w,
      );
}
