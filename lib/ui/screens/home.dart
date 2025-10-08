import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/core/controller/home_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
    );
  }
}
