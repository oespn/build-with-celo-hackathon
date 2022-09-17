import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'class/pomodoro_cycle.dart';
import 'class/pomodoro_config.dart';
import 'class/state/pomodoro.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AMA',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'AMA'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _tasks = 1;
  static const int minSec = 1; //60
  int _duration = 25 * minSec; 
  PomodoroState? nextState = PomodoroState.INIT;

  final CountDownController _controller = CountDownController();

  final PomodoroBase _pomodoro = PomodoroBase(Configuration()
        .setFocusMinutes(2) //25
        .setBreakMinutes(1) //1
        .setLongerBreakMinutes(1) //15
        .setCountUntilLongerBreak(4));

  //final Timer _polling;// = Timer();

  @override
  void initState() {
    super.initState();
    //final Timer _polling = 
    //Timer.periodic(const Duration(seconds: 1), (t) => _checkPomodoro(t));

  }

  // void _checkPomodoroStatus() {
  //       if (_pomodoro.shouldStartBreak()) {
  //         debugPrint('Should Break');
  //         _pomodoro.startBreak();
  //       }

  //       if (_pomodoro.shouldEndBreak()) {
  //         _pomodoro.endBreak();
  //         debugPrint('Breakended');
  //       }
  // }


  void _checkPomodoro() {
      nextState = _pomodoro.nextState(); 
      // _pomodoro.state;

      debugPrint('Next State: $nextState');
      if (nextState == null) 
      {
        _pomodoro.endBreak();
        _pomodoro.performs(); // resume
      }
      else

      if (nextState == PomodoroState.BREAK)
      {
        _pomodoro.startBreak();
      }
      else 
      if (nextState == PomodoroState.FOCUS)
      {
        _pomodoro.performs(); //?
      }
      else
      if (nextState == PomodoroState.FINISHED || nextState == PomodoroState.INIT)
      {
        _pomodoro.reset(); //?
        _pomodoro.performs(); 
      }

      _controllerSetup(nextState);
      //return nextState;
  }


  void _controllerSetup(PomodoroState? state ) {
    //PomodoroState state = _pomodoro.state;
    debugPrint('duration calc state: $state');
    int duration = 25 * minSec;
    switch (state) {
      case PomodoroState.BREAK:
      {
        duration = 5 * minSec;
      }
      break;
      case PomodoroState.LONG_BREAK:
      {
        duration = 15 * minSec;
      }
      break;
      default: //PomodoroState.FOCUS:
      {
        duration = 25 * minSec;
      }
      break;
    }
    _duration = duration;
    debugPrint('duration: $duration');
    //_controller.duration = duration; 
    _controller.restart(duration: duration);
  }

  int _getDuration() {
    return _duration;
  }

  Color _getStateColor() {
    // Display colour
    //return nextState;// _pomodoro.state; 

    if (nextState != PomodoroState.FOCUS)
    {
      return Colors.greenAccent[100]!;
    }
    else  
    {
      return Colors.blueAccent[100]!;
    }
    //return //nextState != PomodoroState.FOCUS ?  : Colors.blueAccent[100]!;

  }


  void _skipStep() {

    _checkPomodoro(); // changes staus eg: Long or short break or back to focus;


  }

  void _addTask() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _tasks++;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: CircularCountDownTimer(
          // Countdown duration in Seconds.
          duration: _getDuration(),

          // Countdown initial elapsed Duration in Seconds.
          initialDuration: 0,

          // Controls (i.e Start, Pause, Resume, Restart) the Countdown Timer.
          controller: _controller,

          // Width of the Countdown Widget.
          width: MediaQuery.of(context).size.width / 2,

          // Height of the Countdown Widget.
          height: MediaQuery.of(context).size.height / 2,

          // Ring Color for Countdown Widget.
          ringColor: Colors.grey[300]!,

          // Ring Gradient for Countdown Widget.
          ringGradient: null,

          // Filling Color for Countdown Widget.
          fillColor: _getStateColor(),

          // Filling Gradient for Countdown Widget.
          fillGradient: null,

          // Background Color for Countdown Widget.
          backgroundColor: Colors.blue[500],

          // Background Gradient for Countdown Widget.
          backgroundGradient: null,

          // Border Thickness of the Countdown Ring.
          strokeWidth: 20.0,

          // Begin and end contours with a flat edge and no extension.
          strokeCap: StrokeCap.round,

          // Text Style for Countdown Text.
          textStyle: const TextStyle(
            fontSize: 33.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),

          // Format for the Countdown Text.
          textFormat: CountdownTextFormat.MM_SS,

          // Handles Countdown Timer (true for Reverse Countdown (max to 0), false for Forward Countdown (0 to max)).
          isReverse: true,

          // Handles Animation Direction (true for Reverse Animation, false for Forward Animation).
          isReverseAnimation: false,

          // Handles visibility of the Countdown Text.
          isTimerTextShown: true,

          // Handles the timer start.
          autoStart: false,

          // This Callback will execute when the Countdown Starts.
          onStart: () {
            // Here, do whatever you want
            debugPrint('Countdown Started');
            // _checkPomodoro(); 
            // _pomodoro.reset();
            // _pomodoro.performs();
          },

          // This Callback will execute when the Countdown Ends.
          onComplete: () {
            // Here, do whatever you want
            debugPrint('Countdown Ended');
            _checkPomodoro();
            //_controllerSetup();

          },

          // This Callback will execute when the Countdown Changes.
          onChange: (String timeStamp) {
            PomodoroState state = _pomodoro.state;
            // Here, do whatever you want
            //debugPrint('Countdown Changed $timeStamp, state: $state.');
            //**_checkPomodoroStatus();
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _addTask,
      //   tooltip: 'Add Task',
      //   child: const Icon(Icons.add),
      // ), 

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [


          const SizedBox(
            width: 30,
          ),
          _button(
            title: "Start",
            onPressed: () => _controller.start(),
          ),
          const SizedBox(
            width: 10,
          ),
          _button(
            title: "Pause",
            onPressed: () => _controller.pause(),
          ),
          const SizedBox(
            width: 10,
          ),
          _button(
            title: "Resume",
            onPressed: () => _controller.resume(),
          ),
          _button(
            title: "Skip",
            onPressed: () => {
              _skipStep()
              //Call _controller.restart(break or focus),
            }
                
          ),
          const SizedBox(
            width: 10,
          ),
          _button(
            title: "Restart",
            onPressed: () => {
              _pomodoro.reset(),
              _checkPomodoro(),
              //_controllerSetup(),
              //_controller.restart(duration: _duration)
            }
          ),
        ],
      ),
    );
  }

  Widget _button({required String title, VoidCallback? onPressed}) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.purple),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}