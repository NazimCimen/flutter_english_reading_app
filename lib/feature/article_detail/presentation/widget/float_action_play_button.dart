// Bu dosya artık kullanılmıyor veya boş bırakılabilir.

part of '../view/article_detail_view.dart';

class _FloatActionPlayButton extends StatelessWidget {
  const _FloatActionPlayButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
      },
      child: Container(
        padding: context.cPaddingSmall,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor,
        ),
        child: Icon(
          Icons.play_arrow,
          color: AppColors.white,
          size: context.cLargeValue,
        ),
      ),
    );
  }
}
