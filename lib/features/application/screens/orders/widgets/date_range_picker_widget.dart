import 'package:flutter/material.dart';

class DateRangePickerWidget extends StatelessWidget {
  final DateTimeRange? initialDateRange;
  final Function(DateTimeRange?) onDateRangeSelected;

  const DateRangePickerWidget({
    Key? key,
    required this.initialDateRange,
    required this.onDateRangeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          initialDateRange: initialDateRange,
          firstDate: DateTime(2020),
          lastDate: DateTime(2101),
        );
        onDateRangeSelected(picked);
      },
      child: const Text('Filter by Date'),
    );
  }
}
