import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e) {
              return Container(
                constraints: const BoxConstraints(minWidth: 48),
                height: 48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.primaries[e.hashCode % Colors.primaries.length],
                ),
                child: Center(child: Icon(e, color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<IconData> items;

  /// Builder building the provided [T] item.
  final Widget Function(IconData) builder;

  @override
  State<Dock> createState() => _DockState();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState extends State<Dock> {
  /// [T] items being manipulated.
  late final List<IconData> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      height: 72,
      padding: const EdgeInsets.all(4),
      child: ReorderableListView(
        scrollDirection: Axis.horizontal, // Drag horizontally like Dock
        buildDefaultDragHandles: false,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1; // Adjust position when dragging
            }
            final IconData icon = _items.removeAt(oldIndex);
            _items.insert(newIndex, icon); // Rearrange icons
          });
        },
        proxyDecorator: (child, index, animation) => child,
        children: List.generate(
          _items.length,
          (index) {
            return ReorderableDelayedDragStartListener(
              key: ValueKey(_items[index]), // Unique key to sort
              index: index,
              child: widget.builder.call(_items[index]),
            );
          },
        ),
      ),
    );
  }
}
