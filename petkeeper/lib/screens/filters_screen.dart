import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../widgets/gradient_button.dart';
import '../widgets/gradient_icons.dart';
import '../providers/filters_provider.dart';
import '../models/filter.dart';

class FiltersScreen extends StatefulWidget {
  static const routename = '/filters-screen';

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String _dropdownWaterValue = 'All';
  String _dropdownFoodValue = 'All';
  String _dropdownPetsValue = 'All';
  String _dropdownWalksValue = 'All';
  int _salaryValue = 0;
  String _startingDate = '';
  String _endingDate = '';
  TextEditingController _startingDateController = TextEditingController();
  TextEditingController _endingDateController = TextEditingController();
  TextEditingController _salaryController = TextEditingController();
  List<String> values = ["All", '0', '1', "2", "3", "4", "5", "6"];

  String allToSeven(String value) {
    if (value == 'All') {
      value = '7';
    }
    return value;
  }

  String sevenToAll(String value) {
    if (value == '7') {
      value = 'All';
    }
    return value;
  }

  String? get _error {
    final text = _salaryController.text;
    if (text.isEmpty) {
      return '';
    }
    if (int.tryParse(text) == null) {
      return 'enter a valid number';
    }
    return null;
  }

  TextField DatePicker(int indicator) {
    return TextField(
      controller:
          indicator == 0 ? _startingDateController : _endingDateController,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
            initialDate: indicator == 0
                ? DateTime.now()
                : DateTime.parse(_startingDateController.text),
            context: context,
            firstDate: DateTime.now(),
            lastDate: DateTime(3000));
        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            indicator == 0
                ? _startingDateController.text = formattedDate
                : _endingDateController.text = formattedDate;
            indicator == 0
                ? _startingDate = formattedDate
                : _endingDate = formattedDate;
          });
        }
      },
      decoration: const InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffee9617))),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color(0xffee9617)))),
      style: const TextStyle(fontSize: 22),
      keyboardType: TextInputType.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtersProvider = Provider.of<FiltersProvider>(context);
    int _waterValue = int.parse(allToSeven(_dropdownWaterValue));
    int _walksValue = int.parse(allToSeven(_dropdownWalksValue));
    int _foodValue = int.parse(allToSeven(_dropdownFoodValue));
    int _petsValue = int.parse(allToSeven(_dropdownPetsValue));
    return Scaffold(
      backgroundColor: const Color(0xffeaeaea),
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: <Color>[Color(0xfffe5858), Color(0xffee9617)]))),
        title: const Text('Please choose filters'),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RadiantGradientMask(
                child: const Icon(
                  Icons.pets,
                  size: 22,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Number of pets ',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                  value: _dropdownPetsValue,
                  items: values.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value.toString(),
                          style: const TextStyle(fontSize: 22),
                        ));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownPetsValue = newValue!;
                      _petsValue = int.parse(allToSeven(_dropdownPetsValue));
                    });
                  })
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RadiantGradientMask(
                child: const Icon(
                  Icons.directions_walk_outlined,
                  size: 22,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Walks Per day ',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 25),
              DropdownButton<String>(
                  value: _dropdownWalksValue,
                  items: values.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value.toString(),
                          style: const TextStyle(fontSize: 22),
                        ));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownWalksValue = newValue!;
                      _walksValue = int.parse(allToSeven(_dropdownWalksValue));
                    });
                  })
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RadiantGradientMask(
                child: const Icon(
                  Icons.fastfood,
                  size: 22,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Feeding Per day ',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                  value: _dropdownFoodValue,
                  items: values.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value.toString(),
                          style: const TextStyle(fontSize: 22),
                        ));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownFoodValue = newValue!;
                      _foodValue = int.parse(allToSeven(_dropdownFoodValue));
                    });
                  })
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RadiantGradientMask(
                child: const Icon(
                  Icons.water_drop,
                  size: 22,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Watering Per day ',
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                  value: _dropdownWaterValue,
                  items: values.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value.toString(),
                          style: const TextStyle(fontSize: 22),
                        ));
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownWaterValue = newValue!;
                      _waterValue = int.parse(allToSeven(_dropdownWaterValue));
                    });
                  })
            ],
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(width: 8),
            RadiantGradientMask(
              child: const Icon(
                Icons.monetization_on,
                size: 22,
                color: Colors.white,
              ),
            ),
            const Text(
              'Starting salary ',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 110,
              height: 45,
              child: TextField(
                style: const TextStyle(fontSize: 22),
                controller: _salaryController,
                decoration: InputDecoration(
                  enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffee9617))),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffee9617))),
                  errorText: _error,
                ),
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  if (_error == null) {
                    setState(() {
                      _salaryValue = int.parse(text);
                    });
                  } else {
                    setState(() {});
                  }
                },
              ),
            ),
          ]),
          const SizedBox(height: 15),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            RadiantGradientMask(
              child: const Icon(
                Icons.calendar_month,
                size: 22,
                color: Colors.white,
              ),
            ),
            const Text(
              'Starting date ',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(width: 8),
            SizedBox(width: 125, height: 25, child: DatePicker(0))
          ]),
          const SizedBox(height: 25),
          _startingDateController.text == ''
              ? const SizedBox()
              : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RadiantGradientMask(
                    child: const Icon(
                      Icons.calendar_month,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Ending date ',
                    style: TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(width: 125, height: 25, child: DatePicker(1))
                ]),
          const SizedBox(height: 25),
          GradientButton(() {
            if (_salaryController.text.isNotEmpty && _error == null) {
              filtersProvider.setValues(Filter(
                  _foodValue,
                  _petsValue,
                  _walksValue,
                  _waterValue,
                  _salaryValue,
                  _startingDate,
                  _endingDate));
              Navigator.of(context).pop();
            }
          }, 50, 150, Icons.search, "Filter", 22)
        ]),
      ),
    );
  }
}
