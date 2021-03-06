//     This file is part of Midori.

//     Midori is free software: you can redistribute it and/or modify
//     it under the terms of the GNU General Public License as published by
//     the Free Software Foundation, either version 3 of the License, or
//     (at your option) any later version.

//     Midori is distributed in the hope that it will be useful,
//     but WITHOUT ANY WARRANTY; without even the implied warranty of
//     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//     GNU General Public License for more details.

//     You should have received a copy of the GNU General Public License
//     along with Midori.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:midori/screens/result_screen.dart';
import 'package:midori/quiz_time_data.dart' as QuizTimeData;

class QuizArguments {
  QuizArguments();
}

class QuizScreen extends StatefulWidget {
  static const routeName = '/quizArguments';

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool isRight = false;
  bool isWrong = false;
  @override
  Widget build(BuildContext context) {
    String lastAnswer;

    var _controller = TextEditingController();

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 45),
                child: Text(
                  'Identify the kana shown:',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Text(
                QuizTimeData.quizEntries[QuizTimeData.currentQuestionIndex][0],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 72,
                ),
              ),
              Expanded(
                  child: FeedbackIcons(isRight: isRight, isWrong: isWrong)),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: buildAnswerBox(_controller, lastAnswer, context),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 2,
                    child: buildSkipButton(_controller),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField buildAnswerBox(TextEditingController _controller, String lastAnswer,
      BuildContext context) {
    return TextField(
      autofocus: true,
      controller: _controller,
      decoration: InputDecoration(
        hintText: 'Enter your answer',
        labelText: 'Type Romaji equivalent',
        suffixIcon: IconButton(
          onPressed: () => _controller.clear(),
          icon: Icon(Icons.clear),
        ),
      ),
      onChanged: (String userInput) =>
          checkInput(userInput, lastAnswer, _controller, context),
    );
  }

  void checkInput(String userInput, String lastAnswer,
      TextEditingController _controller, BuildContext context) {
    if (userInput != '' && userInput != lastAnswer) {
      lastAnswer = userInput;
      if (QuizTimeData.vowels
              .contains(userInput.substring(userInput.length - 1)) ||
          (userInput == 'n' &&
              QuizTimeData.quizEntries[QuizTimeData.currentQuestionIndex][1] ==
                  'n')) {
        if (userInput ==
            QuizTimeData.quizEntries[QuizTimeData.currentQuestionIndex][1]) {
          QuizTimeData.score++;
          showIconFeedBack(true);
          QuizTimeData.rightAnswers.add([
            QuizTimeData.quizEntries[QuizTimeData.currentQuestionIndex][0],
            QuizTimeData.quizEntries[QuizTimeData.currentQuestionIndex][1],
            userInput,
          ]);
        } else {
          showIconFeedBack(false);

          QuizTimeData.wrongAnswers.add([
            QuizTimeData.quizEntries[QuizTimeData.currentQuestionIndex][0],
            QuizTimeData.quizEntries[QuizTimeData.currentQuestionIndex][1],
            userInput,
          ]);
        }
        redirectOrClearText(_controller, context);
      }
    }
  }

  void redirectOrClearText(
      TextEditingController _controller, BuildContext context) {
    if (QuizTimeData.currentQuestionIndex <
        QuizTimeData.quizEntries.length - 1) {
      setState(() {
        QuizTimeData.currentQuestionIndex++;
        _controller.clear();
      });
    } else {
      Navigator.pop(context);
      Navigator.pushNamed(
        context,
        ResultScreen.routeName,
        arguments: ResultArguments(),
      );
    }
  }

  void showIconFeedBack(bool answerTruth) {
    setState(() {
      if (answerTruth)
        isRight = true;
      else
        isWrong = true;
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      if (!mounted) return;
      setState(() {
        if (answerTruth)
          isRight = false;
        else
          isWrong = false;
      });
    });
  }

  ElevatedButton buildSkipButton(TextEditingController _controller) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(primary: Colors.green[400]),
      child: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'SKIP',
            style: TextStyle(color: Colors.white),
          ),
          Icon(
            Icons.arrow_right_alt,
            color: Colors.white,
          ),
        ],
      )),
      onPressed: () => onPressSkip(_controller),
    );
  }

  Set<void> onPressSkip(TextEditingController _controller) {
    return {
      QuizTimeData.skippedAnswers.add([
        QuizTimeData.quizEntries[QuizTimeData.currentQuestionIndex][0],
        QuizTimeData.quizEntries[QuizTimeData.currentQuestionIndex][1],
        '-',
      ]),
      redirectOrClearText(_controller, context),
    };
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            actionsPadding: EdgeInsets.only(right: 15, bottom: 15),
            title: new Text('Really abort quiz?'),
            content: new Text(
                'This will abort the quiz and current scoers will not be added to the total.'),
            actions: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16, width: 10),
              GestureDetector(
                onTap: () {
                  QuizTimeData.currentQuestionIndex = 0;
                  QuizTimeData.prefKey = "null";
                  QuizTimeData.quizEntries.clear();
                  Navigator.of(context).pop(true);
                },
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }
}

class FeedbackIcons extends StatelessWidget {
  const FeedbackIcons({
    Key key,
    @required this.isRight,
    @required this.isWrong,
  }) : super(key: key);

  final bool isRight;
  final bool isWrong;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          child: Icon(
            Icons.check,
            color: Colors.green,
          ),
          visible: isRight,
        ),
        Visibility(
          child: Icon(
            Icons.close,
            color: Colors.red,
          ),
          visible: isWrong,
        ),
      ],
    );
  }
}
