// Question 4: Inheritance & Polymorphism (Difficulty: 4/5) ⭐⭐⭐⭐
/**
 * EXPECTED OUTPUT:
 * Vehicle Info: 2020 Toyota Camry (4 doors)
 * Starting the car engine...
 * Stopping the car engine...
 *
 * Vehicle Info: 2021 Honda CBR (Has windshield: true)
 * Starting the motorcycle engine...
 * Stopping the motorcycle engine...
 *
 * Car age: <Value> years
 * Motorcycle age: <Value> years
 */

// 1. Abstract class Vehicle
abstract class Vehicle {
  String brand;
  String model;
  int year;

  Vehicle(this.brand, this.model, this.year);

  // Abstract methods
  void start();
  void stop();

  // Concrete method
  void displayInfo() {
    print("Vehicle Info: $year $brand $model");
  }

  // Vehicle age = current year - vehicle year
  int calculateAge() {
    return DateTime.now().year - year;
  }
}

// 2. Concrete classes
class Car extends Vehicle {
  int numberOfDoors;

  Car(String brand, String model, int year, this.numberOfDoors)
      : super(brand, model, year);

  @override
  void start() {
    print("Starting the car engine...");
  }

  @override
  void stop() {
    print("Stopping the car engine...");
  }

  @override
  void displayInfo() {
    print("Vehicle Info: $year $brand $model ($numberOfDoors doors)");
  }
}

class Motorcycle extends Vehicle {
  bool hasWindshield;

  Motorcycle(String brand, String model, int year, this.hasWindshield)
      : super(brand, model, year);

  @override
  void start() {
    print("Starting the motorcycle engine...");
  }

  @override
  void stop() {
    print("Stopping the motorcycle engine...");
  }

  @override
  void displayInfo() {
    print("Vehicle Info: $year $brand $model (Has windshield: $hasWindshield)");
  }
}

void main() {
  // 3. Demonstrate polymorphism through a List<Vehicle>
  Car car = Car("Toyota", "Camry", 2020, 4);
  Motorcycle motorcycle = Motorcycle("Honda", "CBR", 2021, true);
  List<Vehicle> vehicles = [car, motorcycle];

  for (Vehicle vehicle in vehicles) {
    vehicle.displayInfo();
    vehicle.start();
    vehicle.stop();
    print("");
  }

  print("Car age: ${car.calculateAge()} years");
  print("Motorcycle age: ${motorcycle.calculateAge()} years");
}
