import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/heritage_provider.dart';
import '../../core/routes/route_names.dart';
import '../../core/utils/helpers.dart';

class HeritageDetailScreen extends StatelessWidget {
  final String itemId;
  const HeritageDetailScreen({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Consumer<HeritageProvider>(
      builder: (context, provider, _) {
        final item = provider.getItemById(itemId);
        if (item == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail')),
            body: const Center(child: Text('Item not found')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(item.name)),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.network(
                  Helpers.imageFallback(item.imageUrl),
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (_, provider, _) => Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      Text('${item.country} • ${item.category}', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      Text(item.description),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(
                      context,
                      RouteNames.edit,
                      arguments: item.id,
                    ),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmDelete(context, provider, item.id),
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _confirmDelete(BuildContext context, HeritageProvider provider, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await provider.deleteItem(id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'Deleted successfully' : 'Delete failed')),
                );
                if (success) Navigator.pop(context);
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}