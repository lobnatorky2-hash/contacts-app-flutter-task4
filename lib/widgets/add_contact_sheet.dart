import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../core/app_colors.dart';
import '../models/contact.dart';
import 'app_text_field.dart';
import 'contact_image.dart';

/// Bottom sheet for adding one contact.
///
/// Top: tappable image box (opens the gallery via image_picker) next to a live
/// preview of the typed name / email / phone. Below: the three text fields and
/// the "Enter user" button.
class AddContactSheet extends StatefulWidget {
  const AddContactSheet({super.key, required this.onSubmit});

  final void Function(Contact contact) onSubmit;

  @override
  State<AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends State<AddContactSheet> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _picker = ImagePicker();

  String? _imagePath;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phoneRegex = RegExp(r'^\+?\d{8,15}$');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null && mounted) {
      setState(() => _imagePath = picked.path);
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSubmit(
      Contact(
        name: _name.text.trim(),
        email: _email.text.trim(),
        phone: _phone.text.replaceAll(' ', ''),
        imagePath: _imagePath,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPreviewRow(),
              const SizedBox(height: 20),
              AppTextField(
                controller: _name,
                hint: 'Enter User Name',
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _email,
                hint: 'Enter User Email',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.isEmpty) return 'Email is required';
                  if (!_emailRegex.hasMatch(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                controller: _phone,
                hint: 'Enter User Phone',
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                validator: (v) {
                  final value = (v ?? '').replaceAll(' ', '');
                  if (value.isEmpty) return 'Phone is required';
                  if (!_phoneRegex.hasMatch(value)) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Enter user'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 166,
            height: 170,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: AppColors.gold),
            ),
            clipBehavior: Clip.antiAlias,
            child: _imagePath == null
                ? const Center(
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 64,
                      color: AppColors.gold,
                    ),
                  )
                : ContactImage(path: _imagePath),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AnimatedBuilder(
            animation: Listenable.merge([_name, _email, _phone]),
            builder: (context, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _previewText(_name.text, 'User Name'),
                  const _PreviewDivider(),
                  _previewText(_email.text, 'example@email.com'),
                  const _PreviewDivider(),
                  _previewText(_phone.text, '+200000000000'),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _previewText(String value, String fallback) {
    return Text(
      value.trim().isEmpty ? fallback : value,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.gold,
      ),
    );
  }
}

class _PreviewDivider extends StatelessWidget {
  const _PreviewDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(height: 1, thickness: 1, color: AppColors.gold),
    );
  }
}
