import 'package:flutter/material.dart';

class ChoiceRow extends StatelessWidget {
  const ChoiceRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.values,
    required this.onSelected,
    super.key,
  });

  final String title;
  final String subtitle;
  final String value;
  final List<int> values;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: PopupMenuButton<int>(
        tooltip: 'Choose $title',
        initialValue: int.tryParse(value.replaceAll('s', '')),
        onSelected: onSelected,
        itemBuilder: (_) => values
            .map(
              (item) => PopupMenuItem(
                value: item,
                child: Text('$item${title.contains('interval') ? 's' : ''}'),
              ),
            )
            .toList(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
