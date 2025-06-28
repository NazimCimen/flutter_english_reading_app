part of '../view/word_bank_view.dart';

class _AppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final bool isSearching;
  final VoidCallback onSearchChanged;

  const _AppBar({
    Key? key,
    required this.searchController,
    required this.isSearching,
    required this.onSearchChanged,
  }) : super(key: key);

  @override
  State<_AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends State<_AppBar> {
  bool _showSearchField = false;
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WordBankViewmodel>(context, listen: false);
    
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      foregroundColor: AppColors.white,
      backgroundColor: AppColors.primaryColor,
      iconTheme: const IconThemeData(color: AppColors.white),
      automaticallyImplyLeading: false,
      elevation: 0,
      title: _showSearchField
          ? TextField(
              controller: widget.searchController,
              focusNode: _searchFocusNode,
              style: TextStyle(color: AppColors.white),
              decoration: InputDecoration(
                hintText: 'Kelime ara...',
                hintStyle: TextStyle(color: AppColors.white.withOpacity(0.7)),
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear, color: AppColors.white),
                  onPressed: () {
                    widget.searchController.clear();
                    provider.clearSearch();
                    setState(() {
                      _showSearchField = false;
                    });
                  },
                ),
              ),
              onChanged: (value) => widget.onSearchChanged(),
            )
          : Text(
              'Kelime Bankası',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
      actions: [
        if (!_showSearchField) ...[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              provider.refreshWords();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              setState(() {
                _showSearchField = true;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _searchFocusNode.requestFocus();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_outlined),
            onPressed: () => NavigatorService.pushNamed(AppRoutes.addWordView),
          ),
        ],
      ],
    );
  }
} 