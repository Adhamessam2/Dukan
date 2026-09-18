import 'package:flutter_test/flutter_test.dart';
import 'package:Dukan/features/home/data/models/categories_response_model.dart';

void main() {
  group('CategoriesResponseModel & CategoryModel', () {
    test(
      'fromJson parses user payload correctly with trimmed name and subcategories',
      () {
        final json = {
          "success": true,
          "statusCode": 200,
          "data": [
            {
              "id": 1,
              "categoryName": "  Electronics & Smart Devices 🎧 ",
              "parentId": null,
              "subCategories": [
                {
                  "id": 4,
                  "categoryName": "Smartphones & 5G Tablets (Refurbished)",
                  "isDeleted": false,
                  "createdAt": "2024-01-02T00:00:00.000Z",
                  "updatedAt": "2024-01-02T00:00:00.000Z",
                  "parentId": 1,
                },
              ],
            },
          ],
        };

        final response = CategoriesResponseModel.fromJson(json);

        expect(response.success, isTrue);
        expect(response.statusCode, 200);
        expect(response.data.length, 1);

        final parentCategory = response.data.first;
        expect(parentCategory.id, 1);
        expect(parentCategory.categoryName, "Electronics & Smart Devices 🎧");
        expect(parentCategory.parentId, isNull);
        expect(parentCategory.subCategories.length, 1);

        final subCategory = parentCategory.subCategories.first;
        expect(subCategory.id, 4);
        expect(
          subCategory.categoryName,
          "Smartphones & 5G Tablets (Refurbished)",
        );
        expect(subCategory.parentId, 1);
        expect(subCategory.isDeleted, isFalse);
        expect(
          subCategory.createdAt,
          DateTime.parse("2024-01-02T00:00:00.000Z"),
        );
      },
    );
  });
}
