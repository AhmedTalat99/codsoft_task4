import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do_list/controllers/task_controller.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/ui/views/add_task_view.dart';
import 'package:to_do_list/ui/views/widgets/showed_task.dart';

import '../../size_config.dart';
import '../../theme.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  @override
  void initState() {
    super.initState();
    _taskController.getTasks();
  }

  DateTime _selectedDate = DateTime.now();
  final TaskController _taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: w,
      appBar: _appBar(),
      body: Column(
        children: [
          _chooseDate(),
          _showTasks(),
        ],
      ),
    );
  }

  showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 4),
          width: SizeConfig.screenWidth,
          height: task.isCompleted == 1
              ? SizeConfig.screenHeight * 0.3
              : SizeConfig.screenHeight * 0.39,
          color: w,
          child: Column(
            children: [
              Flexible(
                child: Container(
                  height: 6,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              task.isCompleted == 1
                  ? Container()
                  : _buildBottomSheet(
                      label: 'Task Completed',
                      onTap: () {
                        _taskController.markTaskDone(task.id!);
                        Get.back();
                      },
                      clr: primary,
                    ),
              _buildBottomSheet(
                label: 'Delete Task',
                onTap: () {
                  _taskController.deletTask(task);
                  Get.back();
                },
                clr: const Color(0xFFE57373),
              ),
              const Divider(color: Colors.grey),
              _buildBottomSheet(
                label: 'Cancel',
                onTap: () {
                  Get.back();
                },
                clr: primary,
              ),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  _showTasks() {
    return Expanded(child: Obx(
      () {
        if (_taskController.taskList.isEmpty) {
          return _emptyMessage();
        } else {
          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                var task = _taskController.taskList[index];
                if (task.date == DateFormat.yMd().format(_selectedDate) ||
                    task.repeat == 'Daily' ||
                    (task.repeat == 'Weekly' &&
                        _selectedDate
                                    .difference(
                                        DateFormat.yMd().parse(task.date!))
                                    .inDays %
                                7 ==
                            0) ||
                    (task.repeat == 'Monthly' &&
                        _selectedDate.day ==
                            DateFormat.yMd().parse(task.date!).day)) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 1300),
                    child: SlideAnimation(
                      horizontalOffset: 300,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () => showBottomSheet(context, task),
                          child: ShowedTask(task),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
              itemCount: _taskController.taskList.length,
            ),
          );
        }
      },
    ));
  }

  Future<void> _onRefresh() async {
    _taskController.getTasks();
  }

  _emptyMessage() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 220),
            SvgPicture.asset(
              'assets/images/task.svg',
              height: 90,
              colorFilter:
                  ColorFilter.mode(primary.withOpacity(0.3), BlendMode.srcIn),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Text(
                'You do not have any task yet !\nAdd new tasks to make days productive',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _chooseDate() {
    return Container(
      margin: const EdgeInsets.only(top: 6, left: 10),
      child: DatePicker(
        DateTime.now(),
        selectionColor: primary,
        selectedTextColor: w,
        initialSelectedDate: _selectedDate,
        onDateChange: (newDate) {
          setState(() {
            _selectedDate = newDate;
          });
        },
      ),
    );
  }

  AppBar _appBar() => AppBar(
        backgroundColor: w,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: b,
                  fontSize: 15,
                ),
              ),
              Text(
                DateFormat.MMMd().format(DateTime.now()),
                style: TextStyle(
                  color: b,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _taskController.deleteAllTasks();
              _taskController.getTasks();
            },
            icon: const Icon(Icons.cleaning_services_outlined),
            color: b,
          ),
          FloatingActionButton(
            heroTag: 'add',
            mini: true,
            onPressed: () async {
              await Get.to(() => const AddTaskView());
              _taskController.getTasks();
            },
            backgroundColor: primary,
            child: const Icon(Icons.add),
          ),
        ],
      );

  _buildBottomSheet(
      {required String label,
      required Function() onTap,
      required Color clr,
      bool isClose = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 65,
        width: SizeConfig.screenWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose ? Colors.grey[300]! : clr,
          ),
          borderRadius: BorderRadius.circular(10),
          color: isClose ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle
                : titleStyle.copyWith(
                    color: w,
                  ),
          ),
        ),
      ),
    );
  }
}
