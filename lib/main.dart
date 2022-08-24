import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://nlbsnpoablmsxwkdbmer.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyOTE5ODEwMiwiZXhwIjoxOTQ0Nzc0MTAyfQ.XZWLzz95pyU9msumQNsZKNBXfyss-g214iTVAwyQLPA',
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
  @override
  void initState() {
    super.initState();
    _getStorage();

    Supabase.instance.client.auth.onAuthStateChange((event, session) {
      if (event == AuthChangeEvent.passwordRecovery) {
        print('password recovery');
      } else {
        print(event);
      }
    });
  }

  Future<void> _getStorage() async {
    final res = await Supabase.instance.client.storage.from('posts').list(
          path: 'folder',
          searchOptions: const SearchOptions(
            sortBy: SortBy(column: 'created_at', order: 'asc'),
          ),
        );
    print(res);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              try {
                final res = await Supabase.instance.client.auth.api
                    .resetPasswordForEmail('dshukertjr@gmail.com',
                        options: const AuthOptions(
                            redirectTo:
                                'io.supabase.newlink://login-callback/'));
                print(res);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('done')));
              } catch (e) {
                print(e);
              }
            },
            child: const Text('press')),
      ),
    );
  }
}
