import 'package:flutter/material.dart';

class SecurityState<T extends StatefulWidget > extends State<T>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  void setState(v){
    if(this.mounted) v();
  }

}

class SecurityStatefulBuilder extends StatefulWidget {
  const SecurityStatefulBuilder({
    Key? key,
    required this.builder,
  }) : assert(builder != null),
        super(key: key);
  final StatefulWidgetBuilder builder;
  @override
  _SecurityStatefulBuilderState createState() => _SecurityStatefulBuilderState();
}

class _SecurityStatefulBuilderState extends SecurityState<SecurityStatefulBuilder> {
  @override
  Widget build(BuildContext context) => widget.builder(context, setState);
}