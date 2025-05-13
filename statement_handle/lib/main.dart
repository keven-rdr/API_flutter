import 'package:flutter/material.dart';
import 'package:statement_handle/models/car.dart';
import 'package:statement_handle/service/car_service.dart';
import 'package:statement_handle/service/img_car_service.dart';

void main()  {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String messageTitle = "Carros Esportivos";

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  int mainScreenState = 2; // 0: success, 1: failure, 2: loading
  List<Car>? cars;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    setState(() {
      mainScreenState = 2; // Tela de carregando
    });

    // Usando a API Car Query (gratuita sem necessidade de cadastro)
    var response = await CarService.loadCars();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      setState(() {
        mainScreenState = 0; // Tela de sucesso
        cars = response.data;
      });
    } else {
      setState(() {
        mainScreenState = 1; // Tela de falha
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
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(widget.messageTitle),
      ),
      body: ListView.builder(
        itemCount: cars?.length ?? 0,
        itemBuilder: (context, index) {
          final car = cars![index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                title: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            car.description,
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'R\$ ${car.price.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.blue[800], fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    FutureBuilder<String?>(
                      future: ImgCarService.fetchCarImage(
                        car.name.split(' ').first,
                        car.name.split(' ').length > 1 ? car.name.split(' ')[1] : '',
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[200],
                            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          );
                        } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
                          return Container(
                            height: 100,
                            width: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.directions_car, size: 50),
                          );
                        } else {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              snapshot.data!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          print("Item $index selecionado");
        },
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }

  Widget failureScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Erro!'),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Não foi possível carregar os dados',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loadData,
              child: const Text("Tentar Novamente"),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carregando...'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Carregando dados dos carros...'),
          ],
        ),
      ),
    );
  }
}