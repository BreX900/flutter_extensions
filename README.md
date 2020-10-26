# flutter_extensions

Adds several extensions

## Dart

### Color

Extensions color code we thank "TinyColor"

### String

| Command | Description |
| ------- | ----------- |
| ifEmpty<T>(() => 'text') | if string is empty returns a 'text' otherwise return string |
| isBlank | if string is empty or contains only space returns true otherwise returns false |
| ifBlank(() => 'text') | if string is empty or contains only space returns 'text' otherwise returns string |

### num
They are extended with the methods of the 'math' package

### Iterable<T>

| Command | Description |
| ------- | ----------- |
| tryFirstWhereType<T>() | returns a first element where type is T else null |
| separate(int Function(T) separator) | returns a `SeparatedResult` separated by separator |
| separateByContains(Iterable<T> iterable) | returns a `SeparatedResult` separated by an iterable via contains method  |
| List<T> expandByIterable(Iterable<T> another) | returns the two iterable joined | 

##### Iterable<MapEntry<K, V>>
| Command | Result | Description |
| toBuiltMapList() | Map<K, List<V>> | groups values by key |

### Map<K, V> - BuiltMap<K, V>

| Command | Description |
| ------- | ----------- |
| generateIterable<K, V>(T Function(K key, V value) generator) | return List of MapEntry<K, V> |
| every<K, V>(bool test(K key, V value)) |  |
| any<K, V>(bool test(K key, V value)) |  |

## Dart - Flutter

### DateTime - Time

| T | Command | Description |
| --- | ------- | ----------- |
| D | DateTime.copyWith | |
| D | DateTime.copyWithPosition |  |
| F | DateTime.toTimeOfDay | |
| F | DateTime.copyWithTimeOfDay | |

## Flutter

| Command | Description |
| ------- | ----------- |
| TargetPlatformExt.isMobile | returns bool |
| TargetPlatformExt.isDesktop | returns bool |
| InputDecoration.completeWith(...) | returns a copy of `InputDecoration` by completing it with the attributes |
| DataRow.copyWith(...) | returns a copy of `DataRow` with the new attributes |
| DataRow.completeWith(...) | returns a copy of `DataRow` by completing it with the attributes |
| DataCell.copyWith(...) | returns a copy of `DataCell` with the new attributes |
| DataCell.completeWith(...) | returns a copy of `DataCell` by completing it with the attributes |


### Widgets

#### Listenable - ChangeNotifier

| Widget | Description |
| ------- | ----------- |
| ChangeableProvider | ... |
| ChangeableBuilder | listen to a `Listenable` and construct the ui based on the changes |
| ChangeableListener | ... |
| ChangeableConsumer | to do... |
| ChangeableValueBuilder | listen to a `Listenable` and construct the ui based on the changes only if they respect the 'condition' or the value does not change |
| ChangeableValueListener | to do... |
| ChangeableValueConsumer | to do... |

#### RxStream
Listen to a `Stream` or `StreamValue` and filtering by previous e current state
Not repeat data or `AsyncSnapshot`
| Widget | Description |
| ------- | ----------- |
| RxStreamConsumer | Construct the `Widget` based on the `AsyncSnapshot` and notify change `AsyncSnapshot`  |
| RxStreamBuilder | Construct the `Widget` based on the `AsyncSnapshot` |
| RxStreamListener | Notify change `AsyncSnapshot` |
| ValueStreamConsumer | Construct the `Widget` based on the data and notify change data |
| ValueStreamBuilder | Construct the `Widget` based on the data |
| ValueStreamListener | Notify change data |

#### Basic

| Widget | Description |
| ------- | ----------- |
| FixedIndexedStack | Build the child only when the index is selected |
| SizeCopier | Update a `SizeCopierController` with the size of the child |
| SizeCopy | Create a SizedWidget taking inspiration from `SizeCopierController` |
| KeyboardRemover | Close the keyboard when use press on the screen |


