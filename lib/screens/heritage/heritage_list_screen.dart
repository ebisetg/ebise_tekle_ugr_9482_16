import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/heritage_provider.dart';
import '../../widgets/heritage_card.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/error_widget.dart';
import '../../widgets/empty_state_widget.dart';
import '../../core/routes/route_names.dart';

class HeritageListScreen extends StatefulWidget {
  const HeritageListScreen({super.key});

  @override
  State<HeritageListScreen> createState() => _HeritageListScreenState();
}

class _HeritageListScreenState extends State<HeritageListScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HeritageProvider>().loadItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HeritageProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Cultural Heritage',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          body: _buildBody(provider),

          floatingActionButton: FloatingActionButton.extended(
            elevation: 4,
            onPressed: () {
              Navigator.pushNamed(context, RouteNames.add);
            },
            icon: const Icon(Icons.add),
            label: const Text(
              'Add Heritage',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(HeritageProvider provider) {
    if (provider.isLoading && provider.items.isEmpty) {
      return const LoadingWidget();
    }

    if (provider.error != null && provider.items.isEmpty) {
      return ErrorWidgetApp(
        message: provider.error!,
        onRetry: () => provider.loadItems(),
      );
    }

    if (provider.items.isEmpty) {
      return const EmptyStateWidget();
    }

    return RefreshIndicator(
      onRefresh: () => provider.loadItems(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 100),
        itemCount: provider.items.length,
        itemBuilder: (context, index) {
          final item = provider.items[index];

          return HeritageCard(
            item: item,
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteNames.detail,
                arguments: item.id,
              );
            },
          );
        },
      ),
    );
  }
}