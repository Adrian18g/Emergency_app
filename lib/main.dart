//Adrian Gonzalez 2022-0479

import 'package:emergency_app/views/event_details.dart';
import 'package:flutter/material.dart';
import 'package:emergency_app/views/events.dart';
import 'package:emergency_app/database/database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DatabaseHelper dbhelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text('911 Eventos'),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Map<String, dynamic>>>(
            future: dbhelper.getEventos(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                List<Map<String, dynamic>> eventos = snapshot.data ?? [];

                if (eventos.isEmpty) {
                  return Center(child: Text('No existe ningun evento'));
                }

                return ListView.builder(
                  itemCount: eventos.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> evento = eventos[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Card(
                        elevation: 3,
                        child: ListTile(
                          title: Text(evento['titulo'] ?? ''),
                          subtitle: Text(evento['fecha'] ?? ''),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailPage(evento: evento)));
                          },
                        ),
                      ),
                    );
                  },
                );
              }
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateEvents()));
          },
          tooltip: 'Add',
          child: Icon(Icons.add),
        ));
  }
}
