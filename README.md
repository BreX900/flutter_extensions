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

### Widgets

#### Listenable

| Widget | Description |
| ------- | ----------- |
| ListenableBuilder | listen to a `Listenable` and construct the ui based on the changes |
| ValueListenableBuilder | listen to a `Listenable` and construct the ui based on the changes only if they respect the 'condition' or the value does not change |
| ListenableListener | to do... |
| ValueListenableListener | to do... |
| ConsumerListener | to do... |
| ValueConsumerListener | to do... |

#### Others

| Widget | Description |
| ------- | ----------- |
| SizeCopier | Update a `SizeCopierController` with the size of the child |
| SizeCopy | Create a SizedWidget taking inspiration from `SizeCopierController` |


