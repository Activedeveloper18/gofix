import 'package:flutter/material.dart';
import 'package:goffix/constants.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

void main() {
  return runApp(MyApp());
}

/// My app class to display the date range picker
class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

/// State for MyApp
class MyAppState extends State<MyApp> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  /// The method for [DateRangePickerSelectionChanged] callback, which will be
  /// called whenever a selection changed on the date picker widget.
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    /// The argument value will return the changed date as [DateTime] when the
    /// widget [SfDateRangeSelectionMode] set as single.
    ///
    /// The argument value will return the changed dates as [List<DateTime>]
    /// when the widget [SfDateRangeSelectionMode] set as multiple.
    ///
    /// The argument value will return the changed range as [PickerDateRange]
    /// when the widget [SfDateRangeSelectionMode] set as range.
    ///
    /// The argument value will return the changed ranges as
    /// [List<PickerDateRange] when the widget [SfDateRangeSelectionMode] set as
    /// multi range.
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() +
                ' - ' +
                DateFormat('dd/MM/yyyy')
                    .format(args.value.endDate ?? args.value.startDate)
                    .toString();
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
    print(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('DatePicker demo'),
            ),
            body: Stack(
              children: <Widget>[
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text('Selected date: ' + _selectedDate),
                      // Text('Selected date count: ' + _dateCount),
                      // Text('Selected range: ' + _range),
                      // Text('Selected ranges count: ' + _rangeCount)
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1)),
                  child: Positioned(
                    left: 0,
                    top: 80,
                    right: 0,
                    bottom: 0,
                    child: SfDateRangePicker(
                      headerStyle: DateRangePickerHeaderStyle(
                        textAlign: TextAlign.center,
                        textStyle: TextStyle(
                            fontFamily: "Lato",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: mainOrange),
                      ),
                      onSelectionChanged: _onSelectionChanged,
                      selectionColor: mainOrange,
                      selectionTextStyle: TextStyle(
                          fontFamily: "Lato",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      rangeSelectionColor: mainOrange,
                      yearCellStyle: DateRangePickerYearCellStyle(
                        todayCellDecoration: BoxDecoration(
                            // color: const Color(0xFFDFDFDF),
                            color: mainOrange,
                            border: Border.all(color: mainOrange, width: 5),
                            shape: BoxShape.rectangle),
                        todayTextStyle: const TextStyle(color: Colors.purple),
                      ),
                      selectionMode: DateRangePickerSelectionMode.single,
                      minDate: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day),
                      maxDate: DateTime(DateTime.now().year,
                          DateTime.now().month, DateTime.now().day + 10),
                    ),
                  ),
                )
              ],
            )));
  }
}
