import 'dart:collection';

var digits = <String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
var operators = <String>['+', '-', '*', '/'];

class ParserCalc {
  const ParserCalc();

  num _eval(String op1, String op2, String op) {
    switch (op) {
      case '+':
        print("Op +: " + op1.toString() + op + op2.toString());
        return num.parse(op1) + num.parse(op2);
      case '-':
        return num.parse(op1) - num.parse(op2);
      case '*':
        return num.parse(op1) * num.parse(op2);
      case '/':
        return num.parse(op1) / num.parse(op2);
      /*case '.':
        print("Op .: "+op1.toString()+op+ op2.toString());
        return num.parse(op1+op+op2);*/
      default:
        return 0.0;
    }
  }

  int _getPriority(String op) {
    switch (op) {
      case '+':
      case '-':
        return 0;
      case '*':
      case '/':
        return 1;
      default:
        return -1;
    }
  }

  bool _isOperator(String op) {
    return operators.contains(op);
  }

  bool _isDigit(String op) {
    return digits.contains(op);
  }

  num parseExpression(String expr) {


    Queue<String> operators = new ListQueue<String>();
    Queue<num> operands = new ListQueue<num>();
    // True if the last character was a digit
    // to accept numbers with more digits
    bool lastDig = true;
    // INIT
    operands.addLast(0);

    expr.split('').forEach((String c) {
      print("Split:"+c);
      if (_isDigit(c)) {
        print("Es numero" + c + ": " + _isDigit(c).toString());
        if (lastDig) {
          num last = operands.removeLast();
          print("last:"+last.toString());
          operands.addLast(last + num.parse(c));
        } else
          operands.addLast(num.parse(c));
      } else if (_isOperator(c)) {
        if (!lastDig) throw new ArgumentError('Illegal expression-ERROR');

        if (operators.isEmpty)
          operators.addLast(c);
        else {
          while (operators.isNotEmpty &&
              operands.isNotEmpty &&
              _getPriority(c) <= _getPriority(operators.last)) {
            num op1 = operands.removeLast();
            num op2 = operands.removeLast();
            String op = operators.removeLast();

            // op1 and op2 in reverse order!
            num res = _eval(op2.toString(), op1.toString(), op);
            operands.addLast(res);
          }
          operators.addLast(c);
        }
      }
      lastDig = _isDigit(c);
    });

    while (operators.isNotEmpty) {
      num op1 = operands.removeLast();
      num op2 = operands.removeLast();
      String op = operators.removeLast();

      // op1 and op2 in reverse order!
      num res = _eval(op2.toString(), op1.toString(), op);
      operands.addLast(res);
    }

    return operands.removeLast();
  }
}
