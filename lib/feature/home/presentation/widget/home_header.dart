part of '../view/home_view.dart';

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.cLowValue),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Hello Nazım',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color:Theme.of(context).colorScheme.onSurface ,
                ),
              ),
              Text(
                'Welcome to Lingzy',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w300,
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),

          FaIcon(
            FontAwesomeIcons.bell,
            size: context.cLargeValue * 1.2,
                  color:Theme.of(context).colorScheme.onSurface ,
          ),
        ],
      ),
    );
  }
}
