# MyTravaly API Documentation

## Overview

MyTravaly is a hotel booking platform API that provides endpoints for device registration, hotel search, property listings, and booking management.

**Base URL**: `https://api.mytravaly.com/public/v1/`

**Auth Token**: `71523fdd8d26f585315b4233e39d9263`

---

## Authentication

All API requests require the following headers:

- `authtoken`: `71523fdd8d26f585315b4233e39d9263` (Required for all endpoints)
- `visitortoken`: Required for most endpoints (obtained from Device Registration)

---

## Endpoints

### 1. Register Device

**Purpose**: Registers a new device and generates a unique visitor token required for subsequent API calls. This should be the first call made by the client application.

**Method**: `POST`

**URL**: `https://api.mytravaly.com/public/v1/`

**Headers**:
```
authtoken: 71523fdd8d26f585315b4233e39d9263
Content-Type: application/json
```

**Request Body**:
```json
{
  "action": "deviceRegister",
  "deviceRegister": {
    "deviceModel": "RMX3521",
    "deviceFingerprint": "realme/RMX3521/RE54E2L1:13/RKQ1.211119.001/S.f1bb32-7f7fa_1:user/release-keys",
    "deviceBrand": "realme",
    "deviceId": "RE54E2L1",
    "deviceName": "RMX3521_11_C.10",
    "deviceManufacturer": "realme",
    "deviceProduct": "RMX3521",
    "deviceSerialNumber": "unknown"
  }
}
```

**Response** (201 Created):
```json
{
  "status": true,
  "message": "Device registered successfully.",
  "responseCode": 201,
  "data": {
    "visitorToken": "7a1f-1c7c-d871-aaf9-5ada-a1a0-abac-ccae"
  }
}
```

---

### 2. Search Auto Complete

**Purpose**: Provides intelligent auto-complete suggestions for hotel searches based on user input. Helps users quickly find relevant cities, states, countries, or properties.

**Method**: `POST`

**URL**: `https://api.mytravaly.com/public/v1/`

**Headers**:
```
authtoken: 71523fdd8d26f585315b4233e39d9263
visitortoken: {your_visitor_token}
Content-Type: application/json
```

**Request Body**:
```json
{
  "action": "searchAutoComplete",
  "searchAutoComplete": {
    "inputText": "indi",
    "searchType": [
      "byCity",
      "byState",
      "byCountry",
      "byRandom",
      "byPropertyName"
    ],
    "limit": 10
  }
}
```

**Search Types Available**:
- `byCity`: Search by city name
- `byState`: Search by state name
- `byCountry`: Search by country name
- `byRandom`: Random search
- `byPropertyName`: Search by hotel/property name

**Response** (200 OK):
```json
{
  "status": true,
  "message": "Search result fetch successfully.",
  "responseCode": 200,
  "data": {
    "present": true,
    "totalNumberOfResult": 7,
    "autoCompleteList": {
      "byPropertyName": {
        "present": true,
        "listOfResult": [
          {
            "valueToDisplay": "Regenta Inn,Indiranagar",
            "propertyName": "Regenta Inn,Indiranagar",
            "address": {
              "city": "Bangalore",
              "state": "Karnataka"
            },
            "searchArray": {
              "type": "hotelIdSearch",
              "query": ["zgRpricB"]
            }
          }
        ],
        "numberOfResult": 3
      },
      "byCity": {
        "present": true,
        "listOfResult": [
          {
            "valueToDisplay": "Dindigul",
            "address": {
              "city": "Dindigul",
              "state": "Tamil Nadu",
              "country": "India"
            },
            "searchArray": {
              "type": "citySearch",
              "query": ["Dindigul", "Tamil Nadu", "India"]
            }
          }
        ],
        "numberOfResult": 1
      },
      "byCountry": {
        "present": true,
        "listOfResult": [
          {
            "valueToDisplay": "India",
            "address": {
              "country": "India"
            },
            "searchArray": {
              "type": "countrySearch",
              "query": ["India"]
            }
          }
        ],
        "numberOfResult": 1
      }
    }
  }
}
```

---

### 3. Get Property List (Popular Stays)

**Purpose**: Retrieves a list of popular stays (hotels, resorts, homestays, campsites) based on specified filters and location criteria.

**Method**: `POST`

**URL**: `https://api.mytravaly.com/public/v1/`

**Headers**:
```
authtoken: 71523fdd8d26f585315b4233e39d9263
visitortoken: {your_visitor_token}
Content-Type: application/json
```

**Request Body**:
```json
{
  "action": "popularStay",
  "popularStay": {
    "limit": 10,
    "entityType": "Any",
    "filter": {
      "searchType": "byCity",
      "searchTypeInfo": {
        "country": "India",
        "state": "Jharkhand",
        "city": "Jamshedpur"
      }
    },
    "currency": "INR"
  }
}
```

**Parameters**:
- `limit`: Maximum 10
- `entityType`: `hotel`, `resort`, `Home Stay`, `Camp_sites/tent`, `Any`
- `searchType`: `byCity`, `byState`, `byCountry`, `byRandom`
- `currency`: Currency code (e.g., `INR`, `USD`, `EUR`)

**Response** (200 OK):
```json
{
  "status": true,
  "message": "Details fetched successfully.",
  "responseCode": 200,
  "data": [
    {
      "propertyName": "Hotel Holideiinn",
      "propertyStar": 4,
      "propertyImage": "https://dwq3yv87q1b43.cloudfront.net/public/property/property_images/fit-in/600x600/725350030-2072256155.jpg",
      "propertyCode": "PgVcKFPF",
      "propertyType": "hotel",
      "propertyPoliciesAndAmmenities": {
        "present": true,
        "data": {
          "cancelPolicy": "7days before check in no cancellations will applicable.",
          "refundPolicy": "If cancel 72Hrs before check in 20% booking refunded.",
          "childPolicy": "Above than 5 years payment will applicable.",
          "petsAllowed": false,
          "coupleFriendly": true,
          "suitableForChildren": true,
          "bachularsAllowed": true,
          "freeWifi": true,
          "freeCancellation": true,
          "payAtHotel": false,
          "payNow": true
        }
      },
      "markedPrice": {
        "amount": 1673.49,
        "displayAmount": "₹1,673.49",
        "currencyAmount": "1,673.49",
        "currencySymbol": "₹"
      },
      "staticPrice": {
        "amount": 1389,
        "displayAmount": "₹1,389",
        "currencyAmount": "1,389",
        "currencySymbol": "₹"
      },
      "googleReview": {
        "reviewPresent": true,
        "data": {
          "overallRating": 3.8,
          "totalUserRating": 1139,
          "withoutDecimal": 4
        }
      },
      "propertyUrl": "https://mytravaly.com/hotels/hotel-details/?hotelid=PgVcKFPF",
      "propertyAddress": {
        "street": "Sakchi , Straight Mile Road, Near Ramlila Maidan",
        "city": "Jamshedpur",
        "state": "Jharkhand",
        "country": "India",
        "zipcode": "831001",
        "latitude": 22.8049718,
        "longitude": 86.2073332
      }
    }
  ]
}
```

---

### 4. Get Search Result

**Purpose**: Fetches a filtered list of available hotels based on detailed search criteria including check-in/check-out dates, number of rooms, price range, and accommodation type.

**Method**: `POST`

**URL**: `https://api.mytravaly.com/public/v1/`

**Headers**:
```
authtoken: 71523fdd8d26f585315b4233e39d9263
visitortoken: {your_visitor_token}
Content-Type: application/json
```

**Request Body**:
```json
{
  "action": "getSearchResultListOfHotels",
  "getSearchResultListOfHotels": {
    "searchCriteria": {
      "checkIn": "2026-07-11",
      "checkOut": "2026-07-12",
      "rooms": 2,
      "adults": 2,
      "children": 0,
      "searchType": "hotelIdSearch",
      "searchQuery": ["qyhZqzVt"],
      "accommodation": ["all", "hotel"],
      "arrayOfExcludedSearchType": ["street"],
      "highPrice": "3000000",
      "lowPrice": "0",
      "limit": 5,
      "preloaderList": [],
      "currency": "INR",
      "rid": 0
    }
  }
}
```

**Accommodation Types**:
- `hotel`, `resort`, `Boat House`, `bedAndBreakfast`, `guestHouse`
- `Holidayhome`, `cottage`, `apartment`, `Home Stay`, `hostel`
- `Guest House`, `Camp_sites/tent`, `co_living`, `Villa`, `Motel`
- `Capsule Hotel`, `Dome Hotel`, `all`

**Search Types**:
- `hotelIdSearch`: Search by hotel ID
- `citySearch`: Search by city
- `stateSearch`: Search by state
- `countrySearch`: Search by country
- `streetSearch`: Search by street address

**Response** (200 OK):
```json
{
  "status": true,
  "message": "Result fetched successfully.",
  "responseCode": 200,
  "data": {
    "arrayOfHotelList": [
      {
        "propertyCode": "qyhZqzVt",
        "propertyName": "Hotel India International Dx",
        "propertyImage": {
          "fullUrl": "https://dwq3yv87q1b43.cloudfront.net/public/property/property_images/fit-in/408x246/288447813-277520548.jpg",
          "location": "https://dwq3yv87q1b43.cloudfront.net/public/property/property_images/",
          "imageName": "288447813-277520548.jpg"
        },
        "propertytype": "Hotel",
        "propertyStar": 3,
        "propertyPoliciesAndAmmenities": {
          "present": true,
          "data": {
            "cancelPolicy": "Cancellation can be done before 48 hours of check in time - 100% refund",
            "refundPolicy": "After 24 hours of check in time - 50% refund",
            "childPolicy": "Up to 6 years complimentary.",
            "petsAllowed": false,
            "coupleFriendly": true,
            "suitableForChildren": true,
            "freeWifi": true
          }
        },
        "propertyAddress": {
          "street": "2485, Nalwa St, Bazar Sangatrashan, Chuna Mandi, Paharganj",
          "city": "New Delhi",
          "state": "Delhi",
          "country": "India",
          "zipcode": "110055",
          "latitude": 28.6417859,
          "longitude": 77.2118298
        },
        "roomName": "Deluxe Room",
        "numberOfAdults": 2,
        "markedPrice": {
          "amount": 7710.84,
          "displayAmount": "₹7,710.84",
          "currencySymbol": "₹"
        },
        "propertyMaxPrice": {
          "amount": 6400,
          "displayAmount": "₹6,400",
          "currencySymbol": "₹"
        },
        "propertyMinPrice": {
          "amount": 6400,
          "displayAmount": "₹6,400",
          "currencySymbol": "₹"
        },
        "googleReview": {
          "reviewPresent": true,
          "data": {
            "overallRating": 3.7,
            "totalUserRating": 872,
            "withoutDecimal": 4
          }
        }
      }
    ],
    "arrayOfExcludedHotels": ["qyhZqzVt"],
    "arrayOfExcludedSearchType": ["street"]
  }
}
```

---

### 5. Get Currency List

**Purpose**: Retrieves a list of supported currencies and their conversion rates relative to a specified base currency.

**Method**: `POST`

**URL**: `https://api.mytravaly.com/public/v1/`

**Headers**:
```
authtoken: 71523fdd8d26f585315b4233e39d9263
visitortoken: {your_visitor_token}
Content-Type: application/json
```

**Request Body**:
```json
{
  "action": "getCurrencyList",
  "getCurrencyList": {
    "baseCode": "INR"
  }
}
```

**Response** (200 OK):
```json
{
  "status": true,
  "message": "Currency list fetched successfully.",
  "responseCode": 200,
  "data": {
    "currencyList": [
      {
        "currencyCode": "INR",
        "currencyName": "Indian Rupee",
        "currencySymbol": "₹"
      },
      {
        "currencyCode": "USD",
        "currencyName": "United States Dollar",
        "currencySymbol": "$"
      },
      {
        "currencyCode": "EUR",
        "currencyName": "Euro",
        "currencySymbol": "€"
      }
    ]
  }
}
```

---

### 6. App Settings

**Purpose**: Fetches configuration and settings data required for initializing the app, including feature toggles, version info, and contact details.

**Method**: `POST`

**URL**: `https://api.mytravaly.com/public/v1/appSetting/`

**Headers**:
```
authtoken: 71523fdd8d26f585315b4233e39d9263
Content-Type: application/json
```

**Response** (200 OK):
```json
{
  "status": true,
  "message": "Settings fetched successfully.",
  "responseCode": 200,
  "data": {
    "googleMapApi": "xyz",
    "appAndroidVersion": "2.0.3",
    "appIosVersion": "2.0.2",
    "appAndroidForceUpdate": true,
    "appIsoForceUpdate": true,
    "appMaintenanceMode": false,
    "supportEmailId": "support@mytravaly.com",
    "contactEmailId": "support@mytravaly.com",
    "conatctNumber": "+918068507734",
    "whatsappNumber": "+919611735014",
    "playStoreLink": "https://play.google.com/store/apps/details?id=com.mytravaly.mytravaly",
    "appStoreLink": "https://apps.apple.com/app/id6462813657",
    "termsAndConditionUrl": "https://mytravaly.com/terms-conditions",
    "privacyUrl": "https://mytravaly.com/privacy-policy"
  }
}
```

---

## Error Handling

All endpoints may return error responses in the following format:

```json
{
  "status": false,
  "message": "Error description",
  "responseCode": 400
}
```

Common response codes:
- `200`: Success
- `201`: Created
- `400`: Bad Request
- `401`: Unauthorized
- `404`: Not Found
- `500`: Internal Server Error

---

## Notes

1. Always call **Register Device** first to obtain a `visitorToken`
2. Store the `visitorToken` securely for subsequent API calls
3. All request bodies must be valid JSON
4. Date format: `YYYY-MM-DD`
5. Prices are in the smallest currency unit (e.g., paise for INR)