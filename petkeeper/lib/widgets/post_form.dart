import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostForm extends StatefulWidget {
  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  int dropdownWaterValue = 0;
  int dropdownFeedingValue = 0;
  int dropdownWalksValue = 0;
  TextEditingController dateinput = TextEditingController();
  final _postKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _postKey,
      child: Column(
        children: [
          TextFormField(
            key: const ValueKey('Title'),
            decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            style: const TextStyle(color: Colors.blue),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          TextFormField(
            key: const ValueKey('Dates'),
            controller: dateinput,
            onTap: () async {
              DateTimeRange? pickedDate = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(3000));
              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('dd-MM-yyyy').format(pickedDate.start) +
                        ' to ' +
                        DateFormat('dd-MM-yyyy').format(pickedDate.end);
                setState(() {
                  dateinput.text = formattedDate;
                });
              }
            },
            decoration: const InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: 'Dates',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            style: const TextStyle(color: Colors.blue),
          ),
          const Padding(
            padding: EdgeInsets.all(5),
          ),
          TextFormField(
            key: const ValueKey('Salary'),
            decoration: const InputDecoration(
                icon: Icon(Icons.monetization_on),
                labelText: 'Salary(USD\$)',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            style: const TextStyle(color: Colors.blue),
            keyboardType: TextInputType.number,
          ),
          const Padding(
            padding: EdgeInsets.all(5),
          ),
          TextFormField(
            key: const ValueKey('Job Description'),
            decoration: const InputDecoration(
                labelText: 'Job Description',
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue))),
            style: const TextStyle(color: Colors.blue),
          ),
          const Padding(
            padding: EdgeInsets.all(5),
          ),
          FormField(
            builder: (FormFieldState state) {
              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const SizedBox(width: 5),
                    const Text('Walks(per day)',
                        style: TextStyle(
                            decorationColor: Colors.blue, fontSize: 17)),
                    const SizedBox(width: 200),
                    DropdownButton<int>(
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 17),
                        underline: Container(height: 2, color: Colors.blue),
                        value: dropdownWaterValue,
                        items: <int>[0, 1, 2, 3, 4, 5, 6]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            child: Text(value.toString()),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownWaterValue = newValue!;
                          });
                        }),
                    const SizedBox(width: 5)
                  ]));
            },
            key: const ValueKey('Watering'),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          FormField(
            builder: (FormFieldState state) {
              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const SizedBox(width: 5),
                    const Text('Feeding(per day)',
                        style: TextStyle(
                            decorationColor: Colors.blue, fontSize: 17)),
                    const SizedBox(width: 185),
                    DropdownButton<int>(
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 17),
                        underline: Container(height: 2, color: Colors.blue),
                        value: dropdownFeedingValue,
                        items: <int>[0, 1, 2, 3, 4, 5, 6]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            child: Text(value.toString()),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownFeedingValue = newValue!;
                          });
                        }),
                    const SizedBox(width: 5)
                  ]));
            },
            key: const ValueKey('Feeding'),
          ),
          const Padding(padding: EdgeInsets.all(5)),
          FormField(
            builder: (FormFieldState state) {
              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    const SizedBox(width: 5),
                    const Text('Walks(per day)',
                        style: TextStyle(
                            decorationColor: Colors.blue, fontSize: 17)),
                    const SizedBox(width: 200),
                    DropdownButton<int>(
                        style:
                            const TextStyle(color: Colors.blue, fontSize: 17),
                        underline: Container(height: 2, color: Colors.blue),
                        value: dropdownWalksValue,
                        items: <int>[0, 1, 2, 3, 4, 5, 6]
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            child: Text(value.toString()),
                            value: value,
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            dropdownWalksValue = newValue!;
                          });
                        }),
                    const SizedBox(width: 5)
                  ]));
            },
            key: const ValueKey('Walks'),
          )
        ],
      ),
    );
  }
}
