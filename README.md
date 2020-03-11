# flutter_extensions

Adds several extensions

## Dart

### Color

Extensions color code we thank "TinyColor"

### Iterable


### String

Returns a default value when the string is empty or blank


```dart
''.ifEmpty(() => 'text');  // => text
' '.isBlank;               // => true
' '.ifBlank(() => 'text'); // => text
```

### SizeCopier

Copy the size of a widget on the screen ( copy height and width )

```dart
GlobalKey buttonBarKey = GlobalKey();
// ...
Scaffold(
  extendBody: true,
  body: SingleChildScrollView(
    child: Column(
      children: <Widget>[
        // ...
        SizeCopier(originalKey: buttonBarKey),
      ],
    ),
  ),
  bottomBar: ButtonBar(
    key: buttonBarKey,
    // ...
  );
);
```
