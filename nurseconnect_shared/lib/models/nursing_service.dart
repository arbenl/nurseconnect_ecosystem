import 'package:equatable/equatable.dart';

class NursingService extends Equatable {
  final String id;
  final String name;
  final String description;
  final double? price;

  const NursingService({
    required this.id,
    required this.name,
    required this.description,
    this.price,
  });

  factory NursingService.fromMap(String id, Map<String, dynamic> map) {
    return NursingService(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }

  @override
  List<Object?> get props => [id, name, description, price];
}
