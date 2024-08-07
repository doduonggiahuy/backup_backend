class Shoes {
  final int id;
  final String name;
  final double price;
  final String image;
  final String description;
  final int quantity;
  final Rating rating;

  Shoes({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.quantity,
    required this.rating,
  });

  factory Shoes.fromJson(Map<String, dynamic> json) {
    return Shoes(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(), // Convert to double if necessary
      image: json['image'],
      description: json['description'],
      quantity: json['quantity'],
      rating: Rating.fromJson(json['rating']),
    );
  }
}

class Rating {
  final double rate;
  final int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: (json['rate'] as num).toDouble(), // Convert to double if necessary
      count: json['count'],
    );
  }
}
