import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_shadows.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_text_theme.dart';

/// Represents a single additional contact.
class AdditionalContact {
  /// Unique identifier for this contact.
  final String id;

  /// Label for this contact (e.g., "Primary", "Secondary").
  final String label;

  /// Phone number for this contact.
  final String phone;

  /// Email address for this contact.
  final String email;

  AdditionalContact({
    required this.id,
    required this.label,
    required this.phone,
    required this.email,
  });

  /// Creates a copy of this contact with modified fields.
  AdditionalContact copyWith({
    String? id,
    String? label,
    String? phone,
    String? email,
  }) {
    return AdditionalContact(
      id: id ?? this.id,
      label: label ?? this.label,
      phone: phone ?? this.phone,
      email: email ?? this.email,
    );
  }
}

/// A reusable card widget for managing additional contacts.
/// 
/// This widget displays a list of additional contact entries with the ability
/// to add new contacts and remove existing ones. Each contact has fields for
/// label, phone, and email.
class AdditionalContactsCard extends StatefulWidget {
  /// Creates an [AdditionalContactsCard] widget.
  const AdditionalContactsCard({
    super.key,
    required this.contacts,
    required this.onAddContact,
    required this.onRemoveContact,
    required this.onContactChanged,
  });

  /// List of additional contacts.
  final List<AdditionalContact> contacts;

  /// Callback when a new contact is added.
  final Function() onAddContact;

  /// Callback when a contact is removed by its ID.
  final Function(String contactId) onRemoveContact;

  /// Callback when a contact's field is changed.
  final Function(AdditionalContact contact) onContactChanged;

  @override
  State<AdditionalContactsCard> createState() =>
      _AdditionalContactsCardState();
}

class _AdditionalContactsCardState extends State<AdditionalContactsCard> {
  late Map<String, TextEditingController> _labelControllers;
  late Map<String, TextEditingController> _phoneControllers;
  late Map<String, TextEditingController> _emailControllers;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _labelControllers = {};
    _phoneControllers = {};
    _emailControllers = {};

    for (final contact in widget.contacts) {
      _labelControllers[contact.id] =
          TextEditingController(text: contact.label);
      _phoneControllers[contact.id] =
          TextEditingController(text: contact.phone);
      _emailControllers[contact.id] =
          TextEditingController(text: contact.email);
    }
  }

  @override
  void didUpdateWidget(AdditionalContactsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle new contacts added
    for (final contact in widget.contacts) {
      if (!_labelControllers.containsKey(contact.id)) {
        _labelControllers[contact.id] =
            TextEditingController(text: contact.label);
        _phoneControllers[contact.id] =
            TextEditingController(text: contact.phone);
        _emailControllers[contact.id] =
            TextEditingController(text: contact.email);
      }
    }
  }

  @override
  void dispose() {
    for (final controller in _labelControllers.values) {
      controller.dispose();
    }
    for (final controller in _phoneControllers.values) {
      controller.dispose();
    }
    for (final controller in _emailControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _updateContact(String contactId, {
    String? label,
    String? phone,
    String? email,
  }) {
    final contact = widget.contacts.firstWhere((c) => c.id == contactId);
    widget.onContactChanged(
      contact.copyWith(
        label: label ?? contact.label,
        phone: phone ?? contact.phone,
        email: email ?? contact.email,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.card,
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Title and Add Button
          _buildHeader(),
          const SizedBox(height: AppSpacing.lg),

          // Divider
          Container(
            height: 1,
            color: AppColors.divider,
          ),
          const SizedBox(height: AppSpacing.lg),

          // Contacts List
          if (widget.contacts.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(
                  'No additional contacts yet. Tap "+ Add" to add one.',
                  style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            Column(
              children: [
                for (int i = 0; i < widget.contacts.length; i++) ...[
                  _buildContactItem(widget.contacts[i], i + 1),
                  if (i < widget.contacts.length - 1)
                    const SizedBox(height: AppSpacing.lg),
                ],
              ],
            ),
        ],
      ),
    );
  }

  /// Builds the header section with title and add button.
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Additional Contacts',
          style: AppTextTheme.textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        // Add Button
        ElevatedButton.icon(
          onPressed: widget.onAddContact,
          icon: const Icon(Icons.add),
          label: Text(
            'Add',
            style: AppTextTheme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a single contact item card.
  Widget _buildContactItem(AdditionalContact contact, int index) {
    final labelController = _labelControllers[contact.id]!;
    final phoneController = _phoneControllers[contact.id]!;
    final emailController = _emailControllers[contact.id]!;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.section,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: AppColors.divider,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact Header with Remove Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contact #$index',
                style: AppTextTheme.textTheme.labelLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => widget.onRemoveContact(contact.id),
                child: Text(
                  'Remove',
                  style: AppTextTheme.textTheme.labelLarge?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Label Field
          _buildContactTextField(
            label: 'Label',
            hintText: 'e.g., Primary',
            controller: labelController,
            onChanged: (value) => _updateContact(contact.id, label: value),
          ),
          const SizedBox(height: AppSpacing.md),

          // Phone Field
          _buildContactTextField(
            label: 'Phone',
            hintText: 'e.g., +94755840187',
            controller: phoneController,
            onChanged: (value) => _updateContact(contact.id, phone: value),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: AppSpacing.md),

          // Email Field
          _buildContactTextField(
            label: 'Email',
            hintText: 'e.g., contact@example.com',
            controller: emailController,
            onChanged: (value) => _updateContact(contact.id, email: value),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  /// Builds a text field for a contact's information.
  Widget _buildContactTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required Function(String) onChanged,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextTheme.textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          style: AppTextTheme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            hintText: hintText,
            hintStyle: AppTextTheme.textTheme.bodyLarge?.copyWith(
              color: AppColors.textHint,
              fontSize: 14,
            ),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: const BorderSide(
                color: Color(0xFFE2E8F0),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
