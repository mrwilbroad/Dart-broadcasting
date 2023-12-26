// example2
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

const MessageAndResponses = {
  "": "Ask me  a question liek 'How are you?'",
  "Hello": "Hi",
  "How are you?": " Fine",
  "What are you doing?": "Learning about Isolates in Dart!",
  "Are you having fun?": "Yeah sure"
};

void main(List<String> args) async {
  do {
    stdout.write("Say something ...");
    final line = stdin.readLineSync(encoding: utf8);
    switch (line?.trim().toLowerCase()) {
      case null:
        continue;
      case 'exit':
        exit(0);
      default:
        final msg = await getMessage(line!);
        print(msg);
    }
  } while (true);
}

// this person can both receive and send Message
// whenever you see ReceivePort , send and receive message
Future<String> getMessage(String msg) async {
  final rp = ReceivePort();
  Isolate.spawn(_communicator, rp.sendPort);

  final broad = rp.asBroadcastStream();
  final SendPort comm = await broad.first;
  comm.send(msg);

  return broad
      .takeWhile((element) => element is String)
      .cast<String>()
      .take(1)
      .first;
}

// whenever you see SendPort
// can ONLY send message
void _communicator(SendPort sp) async {
  final rp = ReceivePort();
  sp.send(rp.sendPort);
  final messages = rp.takeWhile((el) => el is String).cast<String>();
  await for (final msg in messages) {
    for (final entry in MessageAndResponses.entries) {
      if (entry.key.trim().toLowerCase() == msg.trim().toLowerCase()) {
        sp.send(entry.value);
        continue;
      }
    }
    sp.send('I have no response to this message!');
  }
}
