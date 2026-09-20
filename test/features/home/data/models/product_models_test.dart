import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/features/home/data/models/products_response_model.dart';

void main() {
  group('ProductsResponseModel & ProductModel', () {
    test(
      'fromJson parses user payload correctly with images, categories, and stock',
      () {
        final json = {
          "success": true,
          "statusCode": 200,
          "data": [
            {
              "id": 1,
              "productName":
                  "  Refurbished iPhone 14 Pro - 128GB (DEEP PURPLE) 📱 ",
              "productDescription":
                  "Condition: Like New! Contains <b>minor micro-scratches</b> on bezel.\\nIncludes charging cable & 1-year seller warranty.\\nSKU Check: O'Reilly standard compliant.",
              "sku": "SKU-IPH14P-128-PURPLE#01",
              "stock": {"quantity": 3},
              "price": "9999.99",
              "avgRating": "4.5",
              "totalReviews": 2,
              "category": {
                "id": 4,
                "categoryName": "Smartphones & 5G Tablets (Refurbished)",
                "parent": {
                  "id": 1,
                  "categoryName": "  Electronics & Smart Devices 🎧 ",
                  "isDeleted": false,
                  "createdAt": "2024-01-01T00:00:00.000Z",
                  "updatedAt": "2024-01-01T00:00:00.000Z",
                  "parentId": null,
                },
              },
              "productImages": [
                {
                  "id": "cm1prodimg000108l4abcdef01",
                  "productId": 1,
                  "storageKey": "uploads/2024/01/iphone14_front_view%20(1).jpg",
                  "provider": "CLOUDINARY",
                  "url":
                      "https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg",
                  "originalName": "iphone14_front_view (1).jpg",
                  "mimeType": "image/jpeg",
                  "size": 2048576,
                  "isPrimary": true,
                  "order": 1,
                  "createdAt": "2024-01-15T08:05:00.000Z",
                },
                {
                  "id": "cm1prodimg000208l4abcdef02",
                  "productId": 1,
                  "storageKey": "uploads/2024/01/iphone14_back_angle#2.png",
                  "provider": "CLOUDINARY",
                  "url":
                      "https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg",
                  "originalName": "iphone14_back_angle#2.png",
                  "mimeType": "image/png",
                  "size": 4194304,
                  "isPrimary": false,
                  "order": 2,
                  "createdAt": "2024-01-15T08:06:00.000Z",
                },
              ],
            },
            {
              "id": 2,
              "productName":
                  "Panadol Extra 500mg - 24 Film-Coated Tablets [NEW BATCH] 💊",
              "productDescription":
                  "Fast pain relief with Paracetamol + Caffeine.\\nKeep away from children. Dosage: 1-2 tablets every 4-6 hours.",
              "sku": "PANADOL-EXT-24T-EGY",
              "stock": {"quantity": 9999},
              "price": "45.5",
              "avgRating": "5",
              "totalReviews": 1,
              "category": {
                "id": 5,
                "categoryName": "Vitamins, Pain Relief & Supplements",
                "parent": {
                  "id": 2,
                  "categoryName": "PHARMACY & HEALTHCARE [OTC] 💊",
                  "isDeleted": false,
                  "createdAt": "2024-01-01T00:00:00.000Z",
                  "updatedAt": "2024-01-01T00:00:00.000Z",
                  "parentId": null,
                },
              },
              "productImages": [
                {
                  "id": "cm1prodimg000308l4abcdef03",
                  "productId": 2,
                  "storageKey":
                      "uploads/pharma/panadol_box_photo_FINAL_v2.webp",
                  "provider": "CLOUDINARY",
                  "url":
                      "https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg",
                  "originalName": "panadol_box_photo_FINAL_v2.webp",
                  "mimeType": "image/webp",
                  "size": 512000,
                  "isPrimary": true,
                  "order": 1,
                  "createdAt": "2024-01-16T09:35:00.000Z",
                },
              ],
            },
            {
              "id": 3,
              "productName":
                  "Cheap Budget Wireless Earbuds (OPEN BOX - CLEARANCE)",
              "productDescription": null,
              "sku": "EARBUD-CHEAP-CLR-000",
              "stock": {"quantity": 1},
              "price": "0.5",
              "avgRating": "1",
              "totalReviews": 1,
              "category": {
                "id": 4,
                "categoryName": "Smartphones & 5G Tablets (Refurbished)",
                "parent": {
                  "id": 1,
                  "categoryName": "  Electronics & Smart Devices 🎧 ",
                  "isDeleted": false,
                  "createdAt": "2024-01-01T00:00:00.000Z",
                  "updatedAt": "2024-01-01T00:00:00.000Z",
                  "parentId": null,
                },
              },
              "productImages": [
                {
                  "id": "cm1prodimg000408l4abcdef04",
                  "productId": 3,
                  "storageKey": "uploads/dirty/earbuds_open_box.jpeg",
                  "provider": "CLOUDINARY",
                  "url":
                      "https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg",
                  "originalName": "earbuds_open_box.jpeg",
                  "mimeType": "image/jpeg",
                  "size": 102400,
                  "isPrimary": true,
                  "order": 1,
                  "createdAt": "2024-02-01T12:05:00.000Z",
                },
              ],
            },
          ],
        };

        final response = ProductsResponseModel.fromJson(json);

        expect(response.success, isTrue);
        expect(response.statusCode, 200);
        expect(response.data.length, 3);

        // Product 1
        final p1 = response.data[0];
        expect(p1.id, 1);
        expect(
          p1.productName,
          "Refurbished iPhone 14 Pro - 128GB (DEEP PURPLE) 📱",
        );
        expect(p1.sku, "SKU-IPH14P-128-PURPLE#01");
        expect(p1.stockQuantity, 3);
        expect(p1.price, 9999.99);
        expect(p1.avgRating, 4.5);
        expect(p1.totalReviews, 2);
        expect(p1.category?.id, 4);
        expect(p1.category?.parent?.id, 1);
        expect(
          p1.category?.parent?.categoryName,
          "Electronics & Smart Devices 🎧",
        );
        expect(p1.productImages.length, 2);
        expect(p1.productImages[0].id, "cm1prodimg000108l4abcdef01");
        expect(p1.productImages[0].isPrimary, isTrue);
        expect(p1.productImages[1].isPrimary, isFalse);
        expect(p1.primaryImage?.id, "cm1prodimg000108l4abcdef01");
        expect(
          p1.primaryImageUrl,
          "https://4kwallpapers.com/images/walls/thumbs_3t/21872.jpg",
        );

        // Product 2
        final p2 = response.data[1];
        expect(p2.id, 2);
        expect(p2.stockQuantity, 9999);
        expect(p2.price, 45.5);
        expect(p2.avgRating, 5.0);

        // Product 3 (null description)
        final p3 = response.data[2];
        expect(p3.id, 3);
        expect(p3.productDescription, isNull);
        expect(p3.price, 0.5);
        expect(p3.avgRating, 1.0);
      },
    );
  });
}
