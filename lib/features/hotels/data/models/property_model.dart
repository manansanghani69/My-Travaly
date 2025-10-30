import '../../domain/entities/property.dart';

class PropertyAddressModel extends PropertyAddress {
  const PropertyAddressModel({
    required super.addressLine,
    required super.city,
    required super.state,
    required super.country,
    required super.postalCode,
  });

  factory PropertyAddressModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PropertyAddressModel(
        addressLine: '',
        city: '',
        state: '',
        country: '',
        postalCode: '',
      );
    }
    return PropertyAddressModel(
      addressLine:
          (json['addressLine'] ??
                  json['address1'] ??
                  json['street'] ??
                  json['address'] ??
                  json['streetAddress'] ??
                  '')
              .toString(),
      city: (json['city'] ?? '').toString(),
      state: (json['state'] ?? '').toString(),
      country: (json['country'] ?? '').toString(),
      postalCode:
          (json['postalCode'] ??
                  json['postalcode'] ??
                  json['zip'] ??
                  json['zipcode'] ??
                  '')
              .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'addressLine': addressLine,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
    };
  }
}

class PriceInfoModel extends PriceInfo {
  const PriceInfoModel({
    required super.amount,
    required super.currency,
    required super.formatted,
  });

  factory PriceInfoModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const PriceInfoModel(
        amount: 0,
        currency: 'INR',
        formatted: 'INR 0',
      );
    }
    final dynamic amount = json['amount'] ?? json['price'];
    final currency = json['currency'] as String? ?? 'INR';
    final formatted =
        (json['formatted'] as String?) ??
        json['displayAmount'] as String? ??
        json['currencyAmount'] as String? ??
        '$currency ${amount ?? 0}';
    return PriceInfoModel(
      amount: (amount is num)
          ? amount.toDouble()
          : double.tryParse(amount?.toString() ?? '') ?? 0,
      currency: currency,
      formatted: formatted,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'amount': amount,
      'currency': currency,
      'formatted': formatted,
    };
  }
}

class GoogleReviewModel extends GoogleReview {
  const GoogleReviewModel({required super.rating, required super.totalReviews});

  factory GoogleReviewModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const GoogleReviewModel(rating: 0, totalReviews: 0);
    }
    final rating = json['rating'] ?? json['ratingValue'];
    final totalReviews = json['reviewsCount'] ?? json['totalReviews'];
    return GoogleReviewModel(
      rating: (rating is num)
          ? rating.toDouble()
          : double.tryParse(rating?.toString() ?? '') ?? 0,
      totalReviews: (totalReviews is num)
          ? totalReviews.toInt()
          : int.tryParse(totalReviews?.toString() ?? '') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'rating': rating, 'totalReviews': totalReviews};
  }
}
