/// Central place for backend / third-party endpoint configuration.
///
/// NOTE: [cloudinaryCloudName] and [cloudinaryUploadPreset] must be filled in
/// with the SAME values used by the BookMyBus website
/// (client/.env -> VITE_CLOUDINARY_CLOUD_NAME / VITE_CLOUDINARY_UPLOAD_PRESET)
/// so that images uploaded from the app land in the same Cloudinary account
/// the backend expects `imageUrl` to point to.
class ApiConfig {
  ApiConfig._();

  /// Render deployment of the BookMyBus backend.
  static const String baseUrl =
      'https://bookmybus-qubitz-demo.onrender.com/api';

  /// Fill these in from the website's Cloudinary account (unsigned upload
  /// preset). Bus images are uploaded directly from the client to
  /// Cloudinary, exactly like the website does, and only the resulting
  /// secure URL is sent to the backend.
  static const String cloudinaryCloudName = 'dwhuxdgw9';
  static const String cloudinaryUploadPreset = 'qubitz';
}
