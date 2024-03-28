//vehicle class
class Vehicle{
  String id;
  String unit_number;
  String year;
  String model;
  String license;
  String vin_number;

  Vehicle({
    required this.id,
    required this.unit_number,
    required this.year,
    required this.model,
    required this.license,
    required this.vin_number,
  });

  //setters and getters
  String get getId => id;
  String get getUnitNumber => unit_number;
  String get getYear => year;
  String get getModel => model;
  String get getLicense => license;
  String get getVinNumber => vin_number;

  //setters
  set setId(String id) => this.id = id;
  set setUnitNumber(String unitNumber) => unit_number = unitNumber;
  set setYear(String year) => this.year = year;
  set setModel(String model) => this.model = model;
  set setLicense(String license) => this.license = license;
  set setVinNumber(String vinNumber) => vin_number = vinNumber;
}