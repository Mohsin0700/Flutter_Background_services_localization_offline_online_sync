import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/core/controller/home_controller.dart';
import 'package:todo/ui/widgets/add_task_dialog.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  void _showDialog(BuildContext cntx) {
    showDialog(
      context: cntx,
      builder: (context) {
        return AddTaskDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('All Tasks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            FutureBuilder(
              future: ctrl.getTasks(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return const Center(child: Text('No Tasks Found'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No Tasks Found'));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (ctx, idx) {
                    return ListTile(
                      title: Text(snapshot.data![idx].title.toString()),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: ElevatedButton.icon(
        label: Text('Add Task'),
        onPressed: () {
          _showDialog(context);
        },
        icon: Icon(Icons.add),
      ),
    );
  }
}
