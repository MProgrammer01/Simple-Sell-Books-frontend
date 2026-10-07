class ClsConditionsStatusesCategoriesData {
  static final Map<int, String> conditions = Map.unmodifiable({
    1: "New",
    2: "Like New",
    3: "Good",
    4: "Acceptable",
    5: "Poor",
  });

  static final Map<int, String> statuses = Map.unmodifiable({
    1: "Available",
    2: "Sold",
    3: "Reserved",
    4: "Hidden",
  });

  static final Map<int, String> categories = Map.unmodifiable({
    1: "Programming",
    2: "Database",
    3: "Business",
    4: "Science",
    5: "Literature",
  });

  static String getConditionName(int conditionID) {
    return conditions[conditionID]!;
  }

  static int getConditionID(String conditionName) {
    return conditions.entries
        .firstWhere((entry) => entry.value == conditionName)
        .key;
  }

  static String getStatuseName(int statuseID) {
    return statuses[statuseID]!;
  }

  static int getStatuseID(String statuseName) {
    return statuses.entries
        .firstWhere((entry) => entry.value == statuseName)
        .key;
  }

  static String getCategoryName(int categoryID) {
    return categories[categoryID]!;
  }

  static int getCategoryID(String categoryName) {
    return categories.entries
        .firstWhere((entry) => entry.value == categoryName)
        .key;
  }
}
