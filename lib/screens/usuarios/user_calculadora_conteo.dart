import 'package:flutter/material.dart';
import 'package:inventario/utils/parse_calculator.dart';

class UserCalculadoraConteoProductoZona extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
        children: <Widget>[
          new Display(),
          new Keyboard(),
        ],
      ),
    );
  }

}



var _displayState = new DisplayState();
class Display extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _displayState;
  }
}

class DisplayState extends State<Display> {
  var _expression = '';
  var _result = '';
  var resultAc='';
  @override
  Widget build(BuildContext context) {
    var views = <Widget>[
      new Expanded(
          flex: 1,
          child: new Row(
            children: <Widget>[
              new Expanded(
                  child: new Text(
                    _expression,
                    textAlign: TextAlign.right,
                    style: new TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                    ),
                  ))
            ],
          )),
    ];

    if (_result.isNotEmpty) {
      views.add(new Expanded(
          flex: 1,
          child: new Row(
            children: <Widget>[
              new Expanded(
                  child: new Text(
                    _result,
                    textAlign: TextAlign.right,
                    style: new TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                    ),
                  ))
            ],
          )),
      );
    }

    return new Expanded(
        flex: 2,
        child: new Container(
          color: Theme
              .of(context)
              .primaryColor,
          padding: const EdgeInsets.all(30.0),
          child: new Column(
            children: views,
          ),
        ));
  }
}

void _addKey(String key) {
  var _expr = _displayState._expression;
  var _result = '';
  if (_displayState._result.isNotEmpty) {
    // _expr = '';//ori
    _expr = (_displayState.resultAc)
        .toString(); //almacena el valor calculado cada vez que se presiona igual
    _result = ''; //ori
  }

  if(key!="."){
  if (operators.contains(key)) {
    // Handle as an operator
    if (_expr.length > 0 && operators.contains(_expr[_expr.length - 1])) {
      _expr = _expr.substring(0, _expr.length - 1);
      print("DESC" + _expr[_expr.length - 1].toString());
    }
    _expr += key;
  } else if (digits.contains(key)) {
    // Handle as an operand
    _expr += key;
  } else if (key == 'C') {
    // Delete last character
    if (_expr.length > 0) {
      _expr = _expr.substring(0, _expr.length - 1);
    }
  } else if (key == 'AC') {
    if (_expr.length > 0) {
      _expr = '';
    }
  } else if (key == '.') {
    if (_expr.length > 0) {
      _expr = _expr + key;
    }
  } else if (key == '=') {
    //try {
    evaluaNumero(_expr.toString());
    //_result=evaluaNumero(_expr.toString());
    var parser = const ParserCalc();
    _result = parser.parseExpression(_expr).toString();
    print("Exp:=" + _expr);

    //adiciones
    _displayState.resultAc =
        _result; //guarda el valor calculado hasta el momento
    print("ResultAC" + _result);
    //try {
    // } on Error {
    //_result = 'Error';
    //}
  }
}else{
    _expr = _expr + key;
  }
  // ignore: invalid_use_of_protected_member
  _displayState.setState(() {
    _displayState._expression = _expr;
    _displayState._result = _result;
  });

  //




}

 void evaluaNumero(String cadena) {

  /*Parser p = new Parser();
  Expression exp = p.parse(cadena);

  print(exp);

  ContextModel cm = new ContextModel();
  //cm.bindVariableName('x', new Number(1.0));

  double evalnum = exp.evaluate(EvaluationType.REAL, cm);
  print(evalnum);*/

  //return evalnum.toString();
}


class Keyboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
        flex: 4,
        child: new Center(
            child:
            new AspectRatio(
              aspectRatio: 1.0, // To center the GridView
              child: new GridView.count(
                crossAxisCount: 4,
                childAspectRatio: 1.3,
                padding: const EdgeInsets.all(2.0),
                mainAxisSpacing: 5.0,
                crossAxisSpacing: 5.0,
                children: <String>[
                  // @formatter:off
                  'C', 'AC', '%', '/',
                  '7', '8', '9', '*',
                  '4', '5', '6', '-',
                  '1', '2', '3', '+',
                  '.', '0', '=','\u2713'
                  // @formatter:on
                ].map((key) {
                  return new GridTile(
                    child: new KeyboardKey(key),
                  );
                }).toList(),
              ),
            )
        ));
  }
}

class KeyboardKey extends StatelessWidget {
  KeyboardKey(this._keyValue);

  final _keyValue;

  @override
  Widget build(BuildContext context) {
    return new FlatButton(
      child: new Text(
        _keyValue,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 26.0,
          color: Colors.black,
        ),
      ),
      color: Theme
          .of(context)
          .scaffoldBackgroundColor,
      onPressed: () {
        _addKey(_keyValue);
      },
    );
  }
}