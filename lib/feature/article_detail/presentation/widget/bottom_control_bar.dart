part of '../view/article_detail_view.dart';

class _BottomControlBar extends StatelessWidget {
  const _BottomControlBar();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ArticleDetailViewModel>();
    return Align(
      alignment: Alignment.bottomCenter,

      child: Padding(
        padding: context.paddingAllLow,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CustomIconButton(
                    onPressed: () {
                      if (viewModel.isPlaying) {
                        viewModel.pause();
                      } else {
                        viewModel.speak();
                      }
                    },
                    icon: viewModel.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: LinearProgressIndicator(
                        value: viewModel.progressValue,
                        backgroundColor: Colors.grey[600],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  _CustomSpeedButton(
                    onPressed: viewModel.toggleSpeed,
                    speedText: viewModel.currentSpeedText,
                  ),
                  const SizedBox(width: 12),
                  _CustomIconButton(
                    onPressed: viewModel.stop,
                    icon: Icons.stop,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  const _CustomIconButton({required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor,
        ),
        child: Icon(
          icon,
          color: AppColors.white,
          size: context.cLargeValue * 5 / 6,
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class _CustomSpeedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String speedText;

  const _CustomSpeedButton({required this.onPressed, required this.speedText});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primaryColor,
        ),
        child: Text(
          speedText,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
