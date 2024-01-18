import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '';

  void _updateExpression(String value) {
    setState(() {
      _expression += value;
    });
  }

  void _calculateResult() {
    try {
      double evalResult = evaluateExpression(_expression);
      setState(() {
        _result = evalResult.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  void _clearMemory() {
    setState(() {
      _expression = '';
      _result = '';
    });
  }

  void _clearEntry() {
    setState(() {
      _expression = _expression.isNotEmpty
          ? _expression.substring(0, _expression.length - 1)
          : '';
    });
  }

  void _clearAll() {
    setState(() {
      _expression = '';
      _result = '';
    });
  }

  double evaluateExpression(String expression) {
    List<String> tokens = tokenizeExpression(expression);
    double result = double.parse(tokens[0]);

    for (int i = 1; i < tokens.length; i += 2) {
      String operator = tokens[i];
      double operand = double.parse(tokens[i + 1]);

      if (operator == '+') {
        result += operand;
      } else if (operator == '-') {
        result -= operand;
      } else if (operator == 'x') {
        result *= operand;
      } else if (operator == '/') {
        if (operand != 0) {
          result /= operand;
        } else {
          throw Exception('Error: Division by zero');
        }
      }
    }

    return result;
  }

  List<String> tokenizeExpression(String expression) {
    List<String> tokens = [];
    String currentToken = '';

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];

      if (_isOperator(char)) {
        if (currentToken.isNotEmpty) {
          tokens.add(currentToken);
        }
        tokens.add(char);
        currentToken = '';
      } else {
        currentToken += char;
      }
    }

    if (currentToken.isNotEmpty) {
      tokens.add(currentToken);
    }

    return tokens;
  }

  bool _isOperator(String char) {
    return ['+', '-', 'x', '/'].contains(char);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                _expression,
                style: TextStyle(fontSize: 24.0),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                _result,
                style: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          buildButtonRow(['7', '8', '9', 'x']),
          buildButtonRow(['4', '5', '6', '-']),
          buildButtonRow(['1', '2', '3', '+']),
          buildButtonRow(['C', '0', '⌫', '=']),
        ],
      ),
    );
  }

  Widget buildButtonRow(List<String> buttons) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttons
          .map((button) => ElevatedButton(
                onPressed: () {
                  if (button == '=') {
                    _calculateResult();
                  } else if (button == 'C') {
                    _clearMemory();
                  } else if (button == '⌫') {
                    _clearEntry();
                  } else {
                    _updateExpression(button);
                  }
                },
                child: Text(button),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: EdgeInsets.all(20.0),
                ),
              ))
          .toList(),
    );
  }
}
