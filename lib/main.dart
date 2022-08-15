import 'package:flutter/material.dart';
import 'package:realtime_client/realtime_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Supabase.initialize(
  //   url: 'https://nlbsnpoablmsxwkdbmer.supabase.co',
  //   anonKey:
  //       'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyOTE5ODEwMiwiZXhwIjoxOTQ0Nzc0MTAyfQ.XZWLzz95pyU9msumQNsZKNBXfyss-g214iTVAwyQLPA',
  // );
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
  final supabaseUrl = 'https://nlbsnpoablmsxwkdbmer.supabase.co';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyOTE5ODEwMiwiZXhwIjoxOTQ0Nzc0MTAyfQ.XZWLzz95pyU9msumQNsZKNBXfyss-g214iTVAwyQLPA';
  // late final SupabaseClient supabase;
  // @override
  // void initState() {
  //   supabase.from('chats').on(SupabaseEventTypes.insert, (payload) {
  //     print(payload);
  //   }).subscribe(((event, {errorMsg}) {
  //     print(errorMsg);
  //   }));
  //   final channel = supabase
  //       .from('test')
  //       .on(SupabaseEventTypes.broadcast, (payload) {})
  //       .subscribe();

  //   super.initState();
  // }

  @override
  void initState() {
    super.initState();
    // supabase = SupabaseClient(supabaseUrl, supabaseKey);

    final client = RealtimeClient(
      'ws://${supabaseUrl.split('://').last}/realtime/v1',
      params: {'apikey': supabaseKey},
      // ignore: avoid_print
      logger: (kind, msg, data) {
        print('$kind $msg $data');
      },
    );

    final channel = client.channel('realtime:public:random');
    channel.on('DELETE', {}, (payload, [ref]) {
      print('channel delete payload: $payload');
    });
    channel.on('INSERT', {}, (payload, [ref]) {
      print('channel insert payload: $payload');
    });

    final presenceChannel = client.channel('something');

    presenceChannel.on('broadcast', {'event': 'track'}, (payload, [ref]) {
      print('$ref, $payload');
    });

    // presenceChannel.push('track', {'another': 'yay'});

    client.onMessage((message) {
      print('MESSAGE $message');
    });

    // on connect and subscribe
    client.connect();
    channel.subscribe().receive('ok', (_) => print('SUBSCRIBED'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // try {
            //   await supabase.rpc('some');
            //   final res = await supabase.from('products').update(
            //       {'name': 'Relaxed Fit Twill Pull-on Pants'}).eq('id', 1);
            //   ScaffoldMessenger.of(context)
            //       .showSnackBar(const SnackBar(content: Text('Success!')));
            //   print(res);
            // } catch (e) {
            //   print(e);
            //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            //       backgroundColor: Colors.red, content: Text(e.toString())));
            // }
          },
          child: const Text('here'),
        ),
      ),
    );
  }
}
