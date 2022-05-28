class Filter {
  int waterValue;
  int foodValue;
  int petsValue;
  int walksValue;
  int startingSalaryValue;
  String startingDate;
  String endingDate;
  Filter(this.foodValue, this.petsValue, this.walksValue, this.waterValue,
      this.startingSalaryValue, this.startingDate, this.endingDate);

  set setFood(int newValue) {
    foodValue = newValue;
  }

  set setStartingDate(String newValue) {
    startingDate = newValue;
  }

  set setEndingDate(String newValue) {
    endingDate = newValue;
  }

  set setStartingSalary(int newValue) {
    startingSalaryValue = newValue;
  }

  set setWater(int newValue) {
    waterValue = newValue;
  }

  set setPets(int newValue) {
    petsValue = newValue;
  }

  set setWalks(int newValue) {
    walksValue = newValue;
  }
}
