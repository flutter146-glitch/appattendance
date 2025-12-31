class GeofenceService {
  static String getGeofenceName(double lat, double lon) {
    // Bhiwandi approx range
    if (lat >= 19.25 && lat <= 19.35 && lon >= 73.00 && lon <= 73.10) {
      return 'WFH';
    }
    return 'Nutantek Office';
  }

  static bool isInAllowedZone(String geofenceName) {
    return geofenceName == 'WFH' || geofenceName == 'Nutantek Office';
  }
}
