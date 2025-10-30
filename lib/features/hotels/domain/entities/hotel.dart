import 'package:equatable/equatable.dart';

import 'property.dart';

class Hotel extends Equatable {
  final String propertyCode;
  final String propertyName;
  final int propertyStar;
  final String propertyImage;
  final String propertyType;
  final PropertyAddress address;
  final PriceInfo markedPrice;
  final PriceInfo staticPrice;
  final GoogleReview? googleReview;

  const Hotel({
    required this.propertyCode,
    required this.propertyName,
    required this.propertyStar,
    required this.propertyImage,
    required this.propertyType,
    required this.address,
    required this.markedPrice,
    required this.staticPrice,
    this.googleReview,
  });

  @override
  List<Object?> get props => [
    propertyCode,
    propertyName,
    propertyStar,
    propertyImage,
    propertyType,
    address,
    markedPrice,
    staticPrice,
    googleReview,
  ];
}
