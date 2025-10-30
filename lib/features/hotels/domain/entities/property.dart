import 'package:equatable/equatable.dart';

class PropertyAddress extends Equatable {
  final String addressLine;
  final String city;
  final String state;
  final String country;
  final String postalCode;

  const PropertyAddress({
    required this.addressLine,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  @override
  List<Object?> get props => [addressLine, city, state, country, postalCode];
}

class PriceInfo extends Equatable {
  final double amount;
  final String currency;
  final String formatted;

  const PriceInfo({
    required this.amount,
    required this.currency,
    required this.formatted,
  });

  @override
  List<Object?> get props => [amount, currency, formatted];
}

class GoogleReview extends Equatable {
  final double rating;
  final int totalReviews;

  const GoogleReview({required this.rating, required this.totalReviews});

  @override
  List<Object?> get props => [rating, totalReviews];
}
