/// Mirrors the JSON returned by `GET /api/companies/me` on the backend
/// (see server/controllers/companyController.js -> getMyCompany).
class CompanyProfile {
  const CompanyProfile({
    required this.id,
    required this.companyName,
    required this.email,
    required this.contactNo,
    this.addressString = '',
  });

  final String id;
  final String companyName;
  final String email;
  final String contactNo;
  final String addressString;

  factory CompanyProfile.fromJson(Map<String, dynamic> json) {
    return CompanyProfile(
      id: (json['_id'] ?? '').toString(),
      companyName: (json['companyName'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      contactNo: (json['contactNo'] ?? '').toString(),
      addressString: (json['addressString'] ?? '').toString(),
    );
  }
}
