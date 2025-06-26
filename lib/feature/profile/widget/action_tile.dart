part of '../view/profile_view.dart';

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: context.cPaddingSmall,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColorSoft,
        ),
        child: Icon(icon, color: AppColors.background),
      ),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: const Icon(Icons.chevron_right_outlined),
    );
  }
}

