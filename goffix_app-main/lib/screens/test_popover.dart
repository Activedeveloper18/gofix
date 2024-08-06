import 'dart:async';

import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class PopoverTestPage extends StatefulWidget {
  PopoverTestPage({
    Key? key,
  }) : super(key: key);
  @override
  _PopoverTestPageState createState() => new _PopoverTestPageState();
}

class _PopoverTestPageState extends State<PopoverTestPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.red,
      // body: new Center(child: TargetWidget()),
    );
  }
}

// class TargetWidget extends StatefulWidget {
//   const TargetWidget({Key? key}) : super(key: key);
//
//   @override
//   _TargetWidgetState createState() => new _TargetWidgetState();
// }
//
// class _TargetWidgetState extends State<TargetWidget> {
//   late SuperTooltip tooltip;
//
//   Future<bool> _willPopCallback() async {
//     // If the tooltip is open we don't pop the page on a backbutton press
//     // but close the ToolTip
//     if (tooltip.isOpen) {
//       tooltip.close();
//       return false;
//     }
//     return true;
//   }
//
//   void onTap() {
//     if (tooltip != null && tooltip!.isOpen) {
//       tooltip!.close();
//       return;
//     }
//
//     var renderBox = context.findRenderObject() as RenderBox;
//     final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
//
//     var targetGlobalCenter = renderBox
//         .localToGlobal(renderBox.size.center(Offset.zero), ancestor: overlay);
//
//     // We create the tooltip on the first use
//     tooltip = SuperTooltip(
//       maxHeight: 10,
//       minHeight: 10,
//       popupDirection: TooltipDirection.up,
//       top: 10.0,
//       right: 10.0,
//       left: 10.0,
//       // arrowTipDistance: 15.0,
//       // arrowBaseWidth: 40.0,
//       // arrowLength: 20.0,
//       // borderColor: Colors.green,
//       // borderWidth: 5.0,
//       // snapsFarAwayVertically: true,
//       // showCloseButton: ShowCloseButton.outside,
//       hasShadow: false,
//       touchThroughArea: new Rect.fromLTWH(
//           targetGlobalCenter.dx - 100, targetGlobalCenter.dy - 100, 50.0, 50.0),
//       touchThroughAreaShape: ClipAreaShape.rectangle,
//       content: new Material(
//           child: Padding(
//               padding: const EdgeInsets.only(top: 0.0),
//               child: Row(
//                 children: [
//                   Icon(Icons.ac_unit),
//                   Icon(Icons.access_alarm_outlined)
//                 ],
//               )
//               // Text(
//               //   "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, "
//               //   "sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, "
//               //   "sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. ",
//               //   softWrap: true,
//               // ),
//               )),
//     );
//
//     tooltip.show(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new WillPopScope(
//       onWillPop: _willPopCallback,
//       child: new GestureDetector(
//         onTap: onTap,
//         child: Container(
//             width: 10.0,
//             height: 10.0,
//             decoration: new BoxDecoration(
//               shape: BoxShape.circle,
//               color: Colors.blue,
//             )),
//       ),
//     );
//   }
//}
