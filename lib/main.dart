import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const supabaseUrl = 'https://nlbsnpoablmsxwkdbmer.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyOTE5ODEwMiwiZXhwIjoxOTQ0Nzc0MTAyfQ.XZWLzz95pyU9msumQNsZKNBXfyss-g214iTVAwyQLPA';
// const supabaseUrl = 'https://ptrumrnsjkyjjzstvuvi.supabase.co';
// const supabaseKey =
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB0cnVtcm5zamt5amp6c3R2dXZpIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTYzMTc4OTMsImV4cCI6MTk3MTg5Mzg5M30.ScS-Mrq3XvM3Xqcfw78Y__q7pZlT-hVFayqjClAR66g';

class Country {
  final String name;

  Country(this.name);

  Country.fromJson(dynamic json) : name = json['name'] as String;
}

Future<void> main() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
    // url: 'http://localhost:8000',
    // anonKey:
    //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyAgCiAgICAicm9sZSI6ICJhbm9uIiwKICAgICJpc3MiOiAic3VwYWJhc2UtZGVtbyIsCiAgICAiaWF0IjogMTY0MTc2OTIwMCwKICAgICJleHAiOiAxNzk5NTM1NjAwCn0.dc_X5iR_VP_qT0zsiyj_I_OZ2T9FtRU2BBNWN8Bu4GE',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Playground',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final supabase = Supabase.instance.client;
  // final supabase = SupabaseClient(supabaseUrl, supabaseKey);

  @override
  void initState() {
    super.initState();
    supabase.auth.onAuthStateChange.listen((event) {
      print(event.event);
      print('on auth state change sessino: ${event.session?.toString()}');
    });
  }

  //io.supabase.new%3A%2F%2Flogin-callback

  // Future<void> some() async {
  //   try {
  //     final session = await SupabaseAuth.instance.initialSession;
  //     final some = supabase.from('sdfa').insert(
  //       {'some': ''},
  //     );
  //     print(session);
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        ElevatedButton(
          onPressed: () async {
            try {
              final session = supabase.auth.currentSession;
              print(session);

              // await supabase.auth.signOut();
              final some = Random().nextDouble();
              supabase.auth.signInWithOtp(
                  email:
                      'dshukertjr+${some.toString().split('.').last}@gmail.com',
                  data: {'username': 'myiphone'});
            } catch (error) {
              print(error);
            }
          },
          child: const Text('press'),
        ),
      ]),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream:
            supabase.from('random').stream(primaryKey: ['id']).lt('id', 226394),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: ((context, index) {
              return ListTile(
                leading: Text(snapshot.data![index]['id'].toString()),
                title: Text(
                  snapshot.data![index]['content'],
                  maxLines: 1,
                ),
              );
            }),
          );
        },
      ),
      // Center(
      //   child: Column(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       ElevatedButton(
      //         onPressed: () async {
      //           try {
      //             await supabase.auth.signInWithOtp(
      //                 email: 'dshukertjr+dfasnmklew@gmail.com',
      //                 data: {'username': 'somerw'});
      //           } catch (e) {
      //             print(e);
      //           }
      //         },
      //         child: const Text(
      //           'press',
      //           style: TextStyle(color: Colors.white),
      //         ),
      //       ),
      //       ElevatedButton(
      //         onPressed: () {
      //           supabase.auth.signOut();
      //         },
      //         child: const Text('signout'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () async {},
      //         child: const Text('signout'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
