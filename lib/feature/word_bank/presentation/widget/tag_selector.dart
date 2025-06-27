part of '../view/add_word_view.dart';



class _TagSelector extends StatelessWidget {
  final String? selectedTag;
  final ValueChanged<String?> onTagSelected;

  const _TagSelector({
    required this.selectedTag,
    required this.onTagSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('None'),
            onTap: () {
              onTagSelected(null);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Work'),
            onTap: () {
              onTagSelected('Work');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Add New Tag'),
            leading: const Icon(Icons.add),
            onTap: () async {
              Navigator.pop(context); // sheet kapanır
              final tag = await showDialog<String>(
                context: context,
                builder: (context) {
                  String newTag = '';
                  Color selectedColor = Colors.blue;
                  return AlertDialog(
                    title: const Text('Add New Tag'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: 'Tag Name'),
                          onChanged: (value) => newTag = value,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text('Select Color:'),
                            const SizedBox(width: 10),
                            ...[
                              Colors.red,
                              Colors.green,
                              Colors.orange,
                            ].map(
                              (color) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: GestureDetector(
                                  onTap: () => selectedColor = color,
                                  child: CircleAvatar(
                                    backgroundColor: color,
                                    radius: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, newTag),
                        child: const Text('Add'),
                      ),
                    ],
                  );
                },
              );
              if (tag != null && tag.isNotEmpty) {
                onTagSelected(tag);
              }
            },
          ),
        ],
      ),
    );
  }
}
