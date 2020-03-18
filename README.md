# flutter_extensions

Adds several extensions

## Dart

### Color

Extensions color code we thank "TinyColor"

### Iterable<T>

| Command | Description |
| ------- | ----------- |
| tryFirstWhereType<T>() | return a first element where type is T else null |
| more | more |


### String

| Command | Description |
| ------- | ----------- |
| ifEmpty<T>(() => 'text') | if string is empty returns a 'text' otherwise return string |
| isBlank | if string is empty or contains only space returns true otherwise returns false |
| ifBlank(() => 'text') | if string is empty or contains only space returns 'text' otherwise returns string |

## Dart - Flutter

### DateTime - Time

| D | Command | Description |
| ---- | ------- | ----------- |
| + | DateTime.copyWith |  |
| + | DateTime.copyWithPosition |  |
| - | DateTime.toTimeOfDay | |
| - | DateTime.copyWithTimeOfDay | |
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

#### Others

| Widget | Description |
| ------- | ----------- |
| SizeCopier | Update a `SizeCopierController` with the size of the child |
| SizeCopy | Create a SizedWidget taking inspiration from `SizeCopierController` |


