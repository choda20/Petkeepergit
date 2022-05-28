import 'package:flutter/material.dart';

import '../models/filter.dart';
import '../models/post.dart';

class FiltersProvider with ChangeNotifier {
  Filter filter = Filter(7, 7, 7, 7, 0, '', '');

  void setValues(Filter newValues) {
    filter.foodValue = newValues.foodValue;
    filter.walksValue = newValues.walksValue;
    filter.petsValue = newValues.petsValue;
    filter.waterValue = newValues.waterValue;
    filter.startingSalaryValue = newValues.startingSalaryValue;
    filter.startingDate = newValues.startingDate;
    filter.endingDate = newValues.endingDate;
    notifyListeners();
  }

  int get water {
    return filter.waterValue;
  }

  String get startingDate {
    return filter.startingDate;
  }

  String get endingDate {
    return filter.endingDate;
  }

  int get food {
    return filter.foodValue;
  }

  int get salary {
    return filter.startingSalaryValue;
  }

  int get walks {
    return filter.walksValue;
  }

  int get pets {
    return filter.petsValue;
  }
}
