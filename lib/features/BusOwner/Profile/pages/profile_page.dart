import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../shared/widgets/common_app_bar.dart';
import '../widgets/company_admin_info_card.dart';
import '../widgets/company_editable_info_card.dart';
import '../widgets/company_address_card.dart';
import '../widgets/additional_contacts_card.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late String _primaryContactNo;
  late String _contactPerson;
  late String _website;
  String? _logoImagePath;

  late String _addressLine1;
  late String _addressLine2;
  late String _city;
  late String _province;
  late String _postalCode;
  late String _country;

  late List<AdditionalContact> _additionalContacts;

  @override
  void initState() {
    super.initState();
    // Initialize contact information with default values
    _primaryContactNo = '+94771234567';
    _contactPerson = 'John Doe';
    _website = 'https://mybustransport.lk';

    // Initialize address information with default values
    _addressLine1 = '123 Main Street';
    _addressLine2 = 'Suite 100';
    _city = 'Colombo';
    _province = 'Western';
    _postalCode = '00100';
    _country = 'Sri Lanka';

    // Initialize additional contacts with sample data
    _additionalContacts = [
      AdditionalContact(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        label: 'Manager',
        phone: '+94771234567',
        email: 'manager@example.com',
      ),
    ];
  }

  void _addAdditionalContact() {
    setState(() {
      _additionalContacts.add(
        AdditionalContact(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          label: '',
          phone: '',
          email: '',
        ),
      );
    });
  }

  void _removeAdditionalContact(String contactId) {
    setState(() {
      _additionalContacts.removeWhere((c) => c.id == contactId);
    });
  }

  void _updateAdditionalContact(AdditionalContact contact) {
    setState(() {
      final index =
          _additionalContacts.indexWhere((c) => c.id == contact.id);
      if (index != -1) {
        _additionalContacts[index] = contact;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Profile'),
      backgroundColor: AppColors.scaffold,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Admin Info Card
            CompanyAdminInfoCard(
              companyName: 'MyBus Transport Ltd.',
              companyEmail: 'admin@mybustransport.com',
              registrationNumber: 'REG-2023-12345',
              approvalStatus: 'Approved',
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Company Editable Info Card
            CompanyEditableInfoCard(
              primaryContactNo: _primaryContactNo,
              contactPerson: _contactPerson,
              website: _website,
              logoImagePath: _logoImagePath,
              onPrimaryContactNoChanged: (value) {
                setState(() => _primaryContactNo = value);
              },
              onContactPersonChanged: (value) {
                setState(() => _contactPerson = value);
              },
              onWebsiteChanged: (value) {
                setState(() => _website = value);
              },
              onLogoUpload: () {
                // TODO: Implement file picker
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File picker to be implemented')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Company Address Card
            CompanyAddressCard(
              addressLine1: _addressLine1,
              addressLine2: _addressLine2,
              city: _city,
              province: _province,
              postalCode: _postalCode,
              country: _country,
              onAddressLine1Changed: (value) {
                setState(() => _addressLine1 = value);
              },
              onAddressLine2Changed: (value) {
                setState(() => _addressLine2 = value);
              },
              onCityChanged: (value) {
                setState(() => _city = value);
              },
              onProvinceChanged: (value) {
                setState(() => _province = value);
              },
              onPostalCodeChanged: (value) {
                setState(() => _postalCode = value);
              },
              onCountryChanged: (value) {
                setState(() => _country = value);
              },
              onEditablePressed: () {
                // TODO: Handle editable badge press - could enable edit mode or navigate
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address edit mode to be implemented')),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Additional Contacts Card
            AdditionalContactsCard(
              contacts: _additionalContacts,
              onAddContact: _addAdditionalContact,
              onRemoveContact: _removeAdditionalContact,
              onContactChanged: _updateAdditionalContact,
            ),
          ],
        ),
      ),
    );
  }
}

