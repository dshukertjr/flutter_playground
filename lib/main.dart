import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Playground
const supabaseUrl = 'https://bxqrmzvwscpmnimeeesf.supabase.co';
const supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ4cXJtenZ3c2NwbW5pbWVlZXNmIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTI3NTU4NDAsImV4cCI6MjAwODMzMTg0MH0.GZBcMyenIRwCyyFdapZQGSX07iIjjitUU0Zsus1an50';

const redirectTo = 'io.supabase.newlink://login-callback';

// const supabaseUrl = 'http://localhost:54321';
// const supabaseKey =
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0';

// const supabaseUrl = 'https://wblagmqrvrpffsrkkses.supabase.red';
// const supabaseKey =
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndibGFnbXFydnJwZmZzcmtrc2VzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDMwMzY0MTIsImV4cCI6MjAxODYxMjQxMn0.YnElGN-Ln_RY_Jo3N52DP7wpGR1v5rURbJ7HvgKp3G4';

// const supabaseUrl = 'https://qitvepfxacjrezgpxneu.supabase.co';
// const supabaseKey =
//     'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFpdHZlcGZ4YWNqcmV6Z3B4bmV1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTIwMTYzOTEsImV4cCI6MjAyNzU5MjM5MX0.BUxwtY22CgUFW7e_qAroYAqTqzL9GjsTHoRkeb8gQoo';

Future<void> main() async {
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.implicit,
    ),
    debug: false,
  );

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Playground',
      // home: MyWidget(),
      home: SSEWidget(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _userId;
  late final RealtimeChannel channel;

  @override
  void initState() {
    super.initState();

    supabase.auth.onAuthStateChange.listen((event) {
      print(event.event);
      setState(() {
        _userId = event.session?.user.id;
      });
    });
    // some();
  }

  Future<void> some() async {
    final start = DateTime.now();
    try {
      final data = await supabase.from('posts').select();
    } catch (error) {
      print('error: $error');
    }
    print(
        "🙌 ${DateTime.now().difference(start).inMilliseconds / 1000} seconds for completing request");
    await Future.delayed(const Duration(milliseconds: 701));
    // some();
  }

  Future<void> yay() async {
    await Future.delayed(const Duration(seconds: 1));
    throw 'adsfa';
  }

  Future<void> another() async {
    await Future.delayed(const Duration(seconds: 1));
    await yay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_userId ?? 'no user'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final channel = supabase.channel('name');
                channel.onPresenceJoin((payload) {
                  print('presence join');
                  print(payload);
                }).onPresenceLeave((payload) {
                  print('presence leave');
                  print(payload);
                }).subscribe(((status, error) {
                  channel.track({'key': 'value'});
                }));
                return;
                final data =
                    await supabase.from('products').select().limit(0).single();

                try {
                  // print('before future');
                  // final response = await Some();
                  // print(response);
                  // return;

                  // await another();

                  final data = await supabase
                      .from('products')
                      .select()
                      .limit(0)
                      .single();

                  print(data);
                } catch (error, stack) {
                  print('🚀 error');
                  print(error);
                  print(stack);
                  // final trace = Chain([Trace.from(stack)]).toTrace().vmTrace;
                  // print(trace);
                  // print(stack);
                  print('done');
                }
                print('dfa');
                return;

                final res = await supabase.functions.invoke('sse');

                (res.data as ByteStream)
                    .transform(const Utf8Decoder(allowMalformed: true))
                    .listen((val) {
                  print(val);
                });
              },
              child: const Text('Press'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => supabase.auth.signOut(),
              child: const Text('sign out'),
            ),
          ],
        ),
      ),
    );
  }
}

class SSEWidget extends StatefulWidget {
  const SSEWidget({super.key});

  @override
  State<SSEWidget> createState() => _SSEWidgetState();
}

class _SSEWidgetState extends State<SSEWidget> {
  String _responseText = '';
  final TextEditingController _controller =
      TextEditingController(text: 'Tell me a story');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _responseText,
                style: const TextStyle(fontSize: 16),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Expanded(
                  //   child: TextFormField(
                  //     decoration:
                  //         const InputDecoration(border: InputBorder.none),
                  //     controller: _controller,
                  //   ),
                  // ),
                  ElevatedButton(
                    onPressed: () async {
                      final text = _controller.text;
                      _controller.clear();
                      final res = await supabase.functions
                          .invoke('sse', body: {'input': text});

                      (res.data as ByteStream)
                          .transform(const Utf8Decoder())
                          .listen((val) {
                        setState(() {
                          if (!_responseText.endsWith('\n') &&
                              _responseText.isNotEmpty) {
                            _responseText += ' ';
                          }
                          _responseText += val;
                        });
                      });
                    },
                    child: const Text('Start Streaming SSE'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
