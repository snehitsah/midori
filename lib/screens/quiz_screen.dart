import 'package:flutter/material.dart';
import 'package:Midori/screens/result_screen.dart';
import 'package:Midori/quiz_time_data.dart' as QuizTimeData;

class QuizArguments {
  QuizArguments();
}

class QuizScreen extends StatefulWidget {
  static const routeName = '/quizArguments';

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  @override
  Widget build(BuildContext context) {
    //Form the questions array here

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
              Expanded(child: Container()),
              Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Enter your answer',
                        labelText: 'Type Romaji equivalent',
                        suffixIcon: IconButton(
                          onPressed: () => _controller.clear(),
                          icon: Icon(Icons.clear),
                        ),
                      ),
                      onChanged: (String userInput) {
                        if (QuizTimeData.vowels.contains(
                                userInput.substring(userInput.length - 1)) ||
                            (userInput == 'n' &&
                                QuizTimeData.quizEntries[
                                        QuizTimeData.currentQuestionIndex][1] ==
                                    'n')) {
                          if (userInput ==
                              QuizTimeData.quizEntries[
                                  QuizTimeData.currentQuestionIndex][1]) {
                            QuizTimeData.score++;
                            QuizTimeData.rightAnswers.add([
                              QuizTimeData.quizEntries[
                                  QuizTimeData.currentQuestionIndex][0],
                              QuizTimeData.quizEntries[
                                  QuizTimeData.currentQuestionIndex][1],
                              userInput,
                            ]);
                          } else {
                            QuizTimeData.wrongAnswers.add([
                              QuizTimeData.quizEntries[
                                  QuizTimeData.currentQuestionIndex][0],
                              QuizTimeData.quizEntries[
                                  QuizTimeData.currentQuestionIndex][1],
                              userInput,
                            ]);
                          }
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
                          print(QuizTimeData.quizEntries);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 2,
                    child: RaisedButton(
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
                      color: Colors.green[400],
                      onPressed: () => {
                        setState(() {
                          QuizTimeData.currentQuestionIndex++;
                          _controller.clear();
                        }),
                        _controller.clear(),
                        QuizTimeData.skippedAnswers.add([
                          QuizTimeData.quizEntries[
                              QuizTimeData.currentQuestionIndex][0],
                          QuizTimeData.quizEntries[
                              QuizTimeData.currentQuestionIndex][1],
                          '-',
                        ])
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
                onTap: () => Navigator.of(context).pop(true),
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }
}
