import 'package:english_reading_app/core/size/app_border_radius_extensions.dart';
import 'package:english_reading_app/core/size/constant_size.dart';
import 'package:english_reading_app/feature/edit_profile/widget/edit_text_form_field.dart';
import 'package:english_reading_app/product/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Profili Güncelle',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.cMediumValue),
        child: Column(
          children: [
            SizedBox(height: context.cXLargeValue),
            Center(
              child: Image.network(
                'https://firebasestorage.googleapis.com/v0/b/eras-task-management.firebasestorage.app/o/null_profile_image.png?alt=media&token=99de3542-edce-4704-ae3d-4fd3da38a294',
                height: context.cXLargeValue * 2.5,
              ),
            ),
            SizedBox(height: context.cXLargeValue),
            EditTextFormWidget(
              controller: TextEditingController(),
              hintText: 'Ebubekir Ergin',
            ),
            SizedBox(height: context.cLowValue * 1.5),
            EditTextFormWidget(
              controller: TextEditingController(),
              hintText: '+905523461842',
            ),
            SizedBox(height: context.cLowValue * 1.5),
            EditTextFormWidget(
              controller: TextEditingController(),
              hintText: '*********',
            ),
            SizedBox(height: context.cLowValue * 1.5),
            EditTextFormWidget(
              controller: TextEditingController(),
              hintText: '*********',
            ),
            SizedBox(height: context.cLowValue * 1.5),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shadowColor: Colors.black.withOpacity(0.1),
                  backgroundColor: AppColors.primaryColor,
                  shape: ContinuousRectangleBorder(
                    borderRadius: context.cBorderRadiusAllLow / 2,
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Güncelle',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
