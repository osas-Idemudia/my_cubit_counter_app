import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_counter_cubit/cubits/counter/counter_cubit.dart';
import 'package:my_counter_cubit/other_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CounterCubit>(
      create: (context) => CounterCubit(),
      child: MaterialApp(
        title: 'My Counter Cubit',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CounterCubit, CounterState>(
        listener: (context, state) {
          if (state.counter == 3) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text('counter is ${state.counter}'),
                );
              },
            );
          } else if (state.counter == -1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return OtherPage();
              }),
            );
          }
        },
        builder: (context, state) {
          return Center(
            child: Text(
              '${state.counter}',
              style: TextStyle(fontSize: 52.0),
            ),
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              // BlocProvider.of<CounterCubit>(context).increment(); // works fine
              context.read<CounterCubit>().increment(); // works fine
            },
            child: Icon(Icons.add),
            heroTag: 'increment',
          ),
          SizedBox(width: 10.0),
          FloatingActionButton(
            onPressed: () {
              // BlocProvider.of<CounterCubit>(context).decrement(); // works fine
              // context.watch<CounterCubit>().decrement(); // this failed because
              // It is unsupported because may pointlessly rebuild the widget
              //associated to the event handler, when the widget tree doesn't
              //care about the value.
              // BlocProvider.of<CounterCubit>(context, listen: true).decrement(); // also fails
              context.read<CounterCubit>().decrement(); //works fine
            },
            child: Icon(Icons.remove),
            heroTag: 'decrement',
          ),
        ],
      ),
    );
  }
}
