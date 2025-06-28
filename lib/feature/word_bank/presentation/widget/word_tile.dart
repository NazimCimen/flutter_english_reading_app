part of '../view/word_bank_view.dart';

class _WordTile extends StatelessWidget {
  final DictionaryEntry word;

  const _WordTile({required this.word});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<WordBankViewmodel>();

    return Container(
      margin: EdgeInsets.only(bottom: context.cLowValue),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: context.borderRadiusAllMedium,
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: context.borderRadiusAllMedium,
          onTap: () {
            // Kelime detaylarını göster
            _showWordDetail(context);
          },
          child: Padding(
            padding: EdgeInsets.all(context.cMediumValue),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.word,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      if (word.meanings.isNotEmpty && word.meanings.first.definitions.isNotEmpty) ...[
                        SizedBox(height: context.cLowValue / 2),
                        Text(
                          word.meanings.first.definitions.first.definition,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            height: 1.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (word.createdAt != null) ...[
                        SizedBox(height: context.cLowValue / 2),
                        Text(
                          _formatDate(word.createdAt!),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    size: context.cMediumValue,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        NavigatorService.pushNamed(
                          AppRoutes.addWordView,
                          arguments: word,
                        );
                        break;
                      case 'delete':
                        _showDeleteDialog(context, provider);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: context.cMediumValue),
                          SizedBox(width: context.cLowValue),
                          Text('Düzenle'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: context.cMediumValue, color: Colors.red),
                          SizedBox(width: context.cLowValue),
                          Text('Sil', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showWordDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => WordDetailViewModel(
          WordDetailRepositoryImpl(
            remoteDataSource: WordDetailRemoteDataSourceImpl(
              Dio(),
              FirebaseServiceImpl<DictionaryEntry>(
                firestore: FirebaseFirestore.instance,
              ),
            ),
            localDataSource: WordDetailLocalDataSourceImpl(),
          ),
          UserService(),
        ),
        child: WordDetailSheet(
          word: word.word,
          source: WordDetailSource.local, // Local'dan veri al
          onWordSaved: () {
            final provider = context.read<WordBankViewmodel>();
            provider.refreshWords();
          },
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WordBankViewmodel provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Kelimeyi Sil'),
        content: Text('"${word.word}" kelimesini silmek istediğinizden emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              provider.deleteWord(word.documentId!);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Sil'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Bugün';
    } else if (difference.inDays == 1) {
      return 'Dün';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} gün önce';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks hafta önce';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
