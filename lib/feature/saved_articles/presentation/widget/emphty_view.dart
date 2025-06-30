part of '../view/saved_articles_view.dart';

class _SavedArticlesEmptyView extends StatelessWidget {
  const _SavedArticlesEmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: context.paddingAllLarge,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bookmark_outline,
              size: context.cXxLargeValue - 6,
              color: AppColors.primaryColor.withOpacity(0.6),
            ),
          ),
          SizedBox(height: context.cLargeValue),
          Text(
            'Henüz makale kaydetmediniz',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: context.cLowValue),
          Text(
            'Dilediğiniz makaleyi kaydedebilir\nDilediğiniz zaman tekrar okuyabilirsiniz',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
          SizedBox(height: context.cXLargeValue),
        
        ],
      ),
    );
  }
} 