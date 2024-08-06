import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goffix/screens/home/components/tooltip.dart';
import '../../../constants.dart';
import 'arrow_clipper.dart';

class SimpleAccountMenu extends StatefulWidget {
  final List<Icon>? icons;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? iconColor;
  final ValueChanged<int>? onChange;
  final offClick;
  // final LayerLink _layerLink;

  const SimpleAccountMenu({
    Key? key,
    this.icons,
    this.borderRadius,
    this.backgroundColor = const Color(0xFFF67C0B9),
    this.iconColor = Colors.black,
    this.onChange,
    this.offClick,
  })  : assert(icons != null),
        super(key: key);
  @override
  _SimpleAccountMenuState createState() => _SimpleAccountMenuState();
}

class _SimpleAccountMenuState extends State<SimpleAccountMenu>
    with SingleTickerProviderStateMixin {
  GlobalKey? _key;
  bool isMenuOpen = false;
  Offset? buttonPosition;
  Size? buttonSize;
  OverlayEntry? _overlayEntry;
  BorderRadius? _borderRadius;
  AnimationController? _animationController;
  final LayerLink _layerLink = LayerLink();
  late ScrollController _scrollController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    _borderRadius = widget.borderRadius ?? BorderRadius.circular(4);
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  findButton() {
    RenderObject? renderBox = _key!.currentContext!.findRenderObject();
    // buttonSize = renderBox.size;
    // buttonPosition = renderBox!.localToGlobal(Offset.zero);
  }

  void closeMenu() {
    _overlayEntry!.remove();
    _animationController!.reverse();
    isMenuOpen = !isMenuOpen;
  }

  void openMenu() {
    findButton();
    _animationController!.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context).insert(_overlayEntry!);
    isMenuOpen = !isMenuOpen;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _key,
      decoration: BoxDecoration(
        borderRadius: _borderRadius,
      ),
      child: InkWell(
        onTap: () {
          if (isMenuOpen) {
            closeMenu();
          } else {
            openMenu();
          }
        },
        child: Icon(
          CupertinoIcons.person,
          size: 23,
          color: mainBlue,
        ),
      ),
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    // RenderBox? renderBox = context.findRenderObject();
    final LayerLink _layerLink = LayerLink();

    // var size = renderBox!.size;
    return OverlayEntry(
      maintainState: true,
      // opaque: true,
      builder: (context) {
        return Positioned(
          top: buttonPosition!.dy + buttonSize!.height * -2.1,
          left: buttonPosition!.dx * .5,
          width: buttonSize!.width * 3,
          child: Material(
            color: Colors.transparent,
            elevation: 20.0,
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 7.0),
                  child: Container(
                    width: widget.icons!.length * buttonSize!.width * 10,
                    decoration: BoxDecoration(
                      // color: widget.backgroundColor,
                      borderRadius: _borderRadius,
                    ),
                    child: Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(
                          color: widget.iconColor,
                        ),
                      ),
                      child: Center(
                        child: Container(
                            decoration: ShapeDecoration(
                              color: mainBlue,
                              shape: TooltipShapeBorder(arrowArc: .5),
                            ),
                            child: Container(
                                child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children:
                                  List.generate(widget.icons!.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    widget.onChange!(index);
                                    closeMenu();
                                  },
                                  child: Container(
                                    // color: Colors.white,
                                    width: buttonSize!.width * .99,
                                    height: buttonSize!.height * 1.5,
                                    child: widget.icons![index],
                                  ),
                                );
                              }),
                            ))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
