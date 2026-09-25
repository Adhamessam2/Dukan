import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/features/home/data/models/product_model.dart';
import 'package:Dukan/features/home/data/models/products_response_model.dart';

void main() {
  group('ProductsResponseModel & ProductModel', () {
    const rawResponse = {
      "success": true,
      "statusCode": 200,
      "data": {
        "data": [
          {
            "id": 3,
            "categoryId": 4,
            "productName": "Cheap Budget Wireless Earbuds (OPEN BOX - CLEARANCE)",
            "productDescription": null,
            "sku": "EARBUD-CHEAP-CLR-000",
            "price": "0.5",
            "avgRating": "1",
            "totalReviews": 1,
            "isDeleted": false,
            "createdAt": "2024-02-01T12:00:00.000Z",
            "updatedAt": "2024-02-01T12:00:00.000Z",
            "productImages": [
              {
                "url": "https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg"
              }
            ]
          },
          {
            "id": 2,
            "categoryId": 5,
            "productName":
                "Panadol Extra 500mg - 24 Film-Coated Tablets [NEW BATCH] 💊",
            "productDescription":
                "Fast pain relief with Paracetamol + Caffeine.\\nKeep away from children. Dosage: 1-2 tablets every 4-6 hours.",
            "sku": "PANADOL-EXT-24T-EGY",
            "price": "45.5",
            "avgRating": "5",
            "totalReviews": 1,
            "isDeleted": false,
            "createdAt": "2024-01-16T09:30:00.000Z",
            "updatedAt": "2024-02-15T10:00:00.000Z",
            "productImages": [
              {
                "url": "https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg"
              }
            ]
          },
          {
            "id": 1,
            "categoryId": 4,
            "productName":
                "  Refurbished iPhone 14 Pro - 128GB (DEEP PURPLE) 📱 ",
            "productDescription":
                "Condition: Like New! Contains <b>minor micro-scratches</b> on bezel.\\nIncludes charging cable & 1-year seller warranty.\\nSKU Check: O'Reilly standard compliant.",
            "sku": "SKU-IPH14P-128-PURPLE#01",
            "price": "9999.99",
            "avgRating": "4.5",
            "totalReviews": 2,
            "isDeleted": false,
            "createdAt": "2024-01-15T08:00:00.000Z",
            "updatedAt": "2024-02-20T14:10:00.000Z",
            "productImages": [
              {
                "url": "https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg"
              },
              {
                "url": "https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg"
              }
            ]
          },
          {
            "id": 4,
            "categoryId": 3,
            "productName": "Discontinued Walkman Cassette Player Retro 1999",
            "productDescription":
                "Archived vintage item. No longer available in inventory.",
            "sku": "DISC-RETRO-WALK-99",
            "price": "199",
            "avgRating": "0",
            "totalReviews": 0,
            "isDeleted": true,
            "createdAt": "2024-01-05T10:00:00.000Z",
            "updatedAt": "2024-01-06T11:00:00.000Z",
            "productImages": [
              {
                "url": "https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg"
              }
            ]
          }
        ],
        "meta": {
          "page": 1,
          "limit": 10,
          "total": 4,
          "totalPages": 1,
          "hasNextPage": false,
          "hasPreviousPage": false
        }
      }
    };

    test('correctly parses user response with nested data, meta, and productImages', () {
      final responseModel = ProductsResponseModel.fromJson(rawResponse);

      expect(responseModel.success, isTrue);
      expect(responseModel.statusCode, 200);
      expect(responseModel.data.length, 4);

      // Verify meta
      expect(responseModel.meta, isNotNull);
      expect(responseModel.meta!.page, 1);
      expect(responseModel.meta!.limit, 10);
      expect(responseModel.meta!.total, 4);
      expect(responseModel.meta!.totalPages, 1);
      expect(responseModel.meta!.hasNextPage, isFalse);
      expect(responseModel.meta!.hasPreviousPage, isFalse);

      // Verify Product 1 (Earbuds)
      final p1 = responseModel.data[0];
      expect(p1.id, 3);
      expect(p1.categoryId, 4);
      expect(p1.productName, 'Cheap Budget Wireless Earbuds (OPEN BOX - CLEARANCE)');
      expect(p1.productDescription, isNull);
      expect(p1.sku, 'EARBUD-CHEAP-CLR-000');
      expect(p1.price, 0.5);
      expect(p1.avgRating, 1.0);
      expect(p1.totalReviews, 1);
      expect(p1.isDeleted, isFalse);
      expect(p1.isInStock, isTrue);
      expect(p1.createdAt, DateTime.parse("2024-02-01T12:00:00.000Z"));
      expect(p1.updatedAt, DateTime.parse("2024-02-01T12:00:00.000Z"));
      expect(p1.productImages.length, 1);
      expect(p1.productImages[0].url, 'https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg');
      expect(p1.primaryImageUrl, 'https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg');

      // Verify Product 2 (Panadol)
      final p2 = responseModel.data[1];
      expect(p2.id, 2);
      expect(p2.categoryId, 5);
      expect(p2.productName, contains('Panadol Extra 500mg'));
      expect(p2.price, 45.5);
      expect(p2.avgRating, 5.0);
      expect(p2.totalReviews, 1);
      expect(p2.isDeleted, isFalse);
      expect(p2.isInStock, isTrue);
      expect(p2.productImages.length, 1);
      expect(p2.primaryImageUrl, 'https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg');

      // Verify Product 3 (iPhone trimmed with 2 images)
      final p3 = responseModel.data[2];
      expect(p3.id, 1);
      expect(p3.categoryId, 4);
      expect(p3.productName, 'Refurbished iPhone 14 Pro - 128GB (DEEP PURPLE) 📱');
      expect(p3.price, 9999.99);
      expect(p3.avgRating, 4.5);
      expect(p3.totalReviews, 2);
      expect(p3.isDeleted, isFalse);
      expect(p3.isInStock, isTrue);
      expect(p3.productImages.length, 2);
      expect(p3.primaryImageUrl, 'https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg');

      // Verify Product 4 (Discontinued - deleted)
      final p4 = responseModel.data[3];
      expect(p4.id, 4);
      expect(p4.categoryId, 3);
      expect(p4.price, 199.0);
      expect(p4.avgRating, 0.0);
      expect(p4.totalReviews, 0);
      expect(p4.isDeleted, isTrue);
      expect(p4.isInStock, isFalse);
      expect(p4.productImages.length, 1);
      expect(p4.primaryImageUrl, 'https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg');
    });

    test('supports backwards compatibility with flat data list', () {
      final legacyJson = {
        "success": true,
        "statusCode": 200,
        "data": [
          {
            "id": 10,
            "productName": "Simple Product",
            "price": 100.0,
            "stock": {"quantity": 5}
          }
        ]
      };

      final responseModel = ProductsResponseModel.fromJson(legacyJson);
      expect(responseModel.success, isTrue);
      expect(responseModel.data.length, 1);
      expect(responseModel.data.first.id, 10);
      expect(responseModel.data.first.stockQuantity, 5);
      expect(responseModel.data.first.isInStock, isTrue);
      expect(responseModel.meta, isNull);
    });

    test('serializes to and from JSON correctly', () {
      final meta = const PaginationMetaModel(
        page: 1,
        limit: 10,
        total: 1,
        totalPages: 1,
        hasNextPage: false,
        hasPreviousPage: false,
      );
      const product = ProductModel(
        id: 1,
        categoryId: 2,
        productName: 'Sample Product',
        price: 99.9,
      );
      final response = ProductsResponseModel(
        success: true,
        statusCode: 200,
        data: const [product],
        meta: meta,
      );

      final json = response.toJson();
      final reconstructed = ProductsResponseModel.fromJson(json);

      expect(reconstructed.success, response.success);
      expect(reconstructed.statusCode, response.statusCode);
      expect(reconstructed.data.first.id, 1);
      expect(reconstructed.data.first.categoryId, 2);
      expect(reconstructed.data.first.productName, 'Sample Product');
      expect(reconstructed.data.first.price, 99.9);
      expect(reconstructed.meta?.total, 1);
    });
  });
}
