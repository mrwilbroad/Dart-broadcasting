## Broadcasting in dart via terminal

```dart
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
```
