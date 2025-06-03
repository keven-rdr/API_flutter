import 'package:flutter/material.dart';
import 'package:statement_handle/models/post.dart';

import '../../components/post_card.dart';
import '../timeline_screen/timeline_service.dart';

class MainScreen extends StatefulWidget {
  String messageTitle = "Timeline";
  String messageDescription = "Este é o Widget de Timeline";

  @override
  State<StatefulWidget> createState() {
    return MainsScreenState();
  }
}

class MainsScreenState extends State<MainScreen> {
  int mainScreenState = 2;
  List<Post>? posts;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void changeState() {
    setState(() {
      mainScreenState++;
      mainScreenState %= 3;
    });
  }

  void tryAgain() {
    setState(() {
      mainScreenState = 2;
    });
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      mainScreenState = 2;
    });

    var response = await TimelineService.loadTimeline();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        mainScreenState = 0;
        posts = response.data;
      });
    } else {
      setState(() {
        mainScreenState = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (mainScreenState) {
      case 0:
        return successScreen();
      case 1:
        return failureScreen();
      default:
        return loadingScreen();
    }
  }

  Widget successScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.messageTitle),
      ),
      body: ListView.builder(
        itemCount: posts?.length ?? 0,
        itemBuilder: (context, index) {
          final post = posts![index];
          return PostCard(post: post);
        },
      ),
    );
  }

  Widget failureScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Erro!'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Não foi possível carregar os dados'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: tryAgain,
              child: Text("Tentar Novamente"),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carregando...'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}