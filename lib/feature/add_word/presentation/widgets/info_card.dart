part of '../view/add_word_view.dart';

class _InfoCard extends StatelessWidget {
  const _InfoCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.paddingAllMedium,
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.1),
        borderRadius: context.borderRadiusAllMedium,
        border: Border.all(
          color: AppColors.primaryColor.withOpacity(0.3),
          width: context.cLowValue / 4,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primaryColor,
            size: context.cMediumValue,
          ),
          SizedBox(width: context.cLowValue),
          Expanded(
            child: Text(
              'Eklediğiniz kelimeler güvenli bir şekilde kaydedilir ve tüm cihazlarınızda senkronize olur.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}
