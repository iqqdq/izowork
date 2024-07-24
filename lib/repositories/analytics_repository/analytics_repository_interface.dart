abstract class AnalyticsRepositoryInterface {
  Future<dynamic> getCompanyAnalytics();

  Future<dynamic> getManagerAnalytics(String id);

  Future<dynamic> getObjectAnalytics();

  Future<dynamic> getProductAnalytics(
    String id,
    String? year,
  );
}
