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
  // final supabaseUrl = 'https://nlbsnpoablmsxwkdbmer.supabase.co';
  // final supabaseKey =
  //     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYyOTE5ODEwMiwiZXhwIjoxOTQ0Nzc0MTAyfQ.XZWLzz95pyU9msumQNsZKNBXfyss-g214iTVAwyQLPA';
  final supabaseUrl = 'https://bbifkfukkjpeiygqrkip.supabase.co';
  final supabaseKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJiaWZrZnVra2pwZWl5Z3Fya2lwIiwicm9sZSI6ImFub24iLCJpYXQiOjE2NTcwOTk1MTgsImV4cCI6MTk3MjY3NTUxOH0.XGGVrF_EPqSBd7vjABKGxVXqT7s6ntGElNT_oyhHMMY';
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

  late final RealtimeChannel channel;

  // Future<void> _getSomething() async {
  //   await Future.delayed(const Duration(seconds: 5));

  //   final supabase = SupabaseClient(supabaseUrl, supabaseKey);
  //   final data = await supabase.from('chats').insert({'content': 'sfsad'});
  //   _getSomething();
  // }

  @override
  void initState() {
    super.initState();

    // _getSomething();

    final client = RealtimeClient(
      'ws://${supabaseUrl.split('://').last}/realtime/v1',
      params: {'apikey': supabaseKey},
      // ignore: avoid_print
      logger: (kind, msg, data) {
        print('within logger $kind $msg $data');
      },
    );

    channel = client.channel('some', {
      'config': {
        'broadcast': {'ack': true, 'self': true},
      }
    });
    // channel.on('DELETE', {}, (payload, [ref]) {
    //   print('channel delete payload: $payload');
    // });

    // channel.on(
    //     'postgres_changes',
    //     ChannelFilter(
    //       event: 'INSERT',
    //       schema: 'public',
    //       table: 'chats',
    //       // 'filter': 'id=eq.1'
    //     ), (payload, [ref]) {
    //   print('🎉🎉🎉 channel insert payload: $payload');
    // });

    channel.on('broadcast', ChannelFilter(event: 'location'), (payload, [ref]) {
      print('🚀🚀🚀 broadcast 🚀');
      print(payload);
    });

    channel.subscribe();

    // final presenceChannel = client.channel('something');

    // presenceChannel.on('broadcast', {'event': 'track'}, (payload, [ref]) {
    //   print('within presence channel $ref, $payload');
    // });

    // // presenceChannel.push('track', {'another': 'yay'});

    // client.onMessage((message) {
    //   print('within on message $message');
    // });

    // on connect and subscribe
    // client.connect();
    // channel.subscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final status = await channel.send({
              'type': 'broadcast',
              'event': 'location',
              'payload': {'here': 'is this shown?'},
            });
            print('status: ');
            print(status);
          },
          child: const Text('here'),
        ),
      ),
    );
  }
}
