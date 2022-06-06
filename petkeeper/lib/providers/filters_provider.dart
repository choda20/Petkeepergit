import 'package:flutter/material.dart';

import '../models/filter.dart';

class FiltersProvider with ChangeNotifier {
  Filter filter = Filter(7, 7, 7, 7, 0, '', '');

  // Filter טענת כניסה: הפעולה מקבלת משתנה מסוג
  // טענת יציאה: הפעולה משווה את ערכי הסינון הנוכחיים לערכי הסינון שהתקבלו ומודיעה על כך למשתנים המשתמשים במחלקה זו
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

  // טענת כניסה: אין
  // טענת יציאה: הפעולה מאתחלת את ערכי הסינון לערכים אשר מציגים את כל הפוסטים
  void resetFilters() {
    filter.foodValue = 7;
    filter.walksValue = 7;
    filter.petsValue = 7;
    filter.waterValue = 7;
    filter.startingSalaryValue = 0;
    filter.startingDate = '';
    filter.endingDate = '';
  }
}
