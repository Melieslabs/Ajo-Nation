import 'package:flutter/material.dart';

import '../../../data/mock_data_repository.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/my_back_button.dart';
import '../../../widgets/primary_button.dart';

class ManagePayoutOrderScreen extends StatefulWidget {
  const ManagePayoutOrderScreen({
    super.key,
    required this.groupId,
  });

  final String groupId;

  @override
  State<ManagePayoutOrderScreen> createState() =>
      _ManagePayoutOrderScreenState();
}

class _ManagePayoutOrderScreenState extends State<ManagePayoutOrderScreen> {
  final _repo = MockDataRepository.instance;

  late List<String> _order;

  bool _saving = false;


  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex--;
      }

      final item = _order.removeAt(oldIndex);
      _order.insert(newIndex, item);
    });
  }

  Future<void> _saveOrder() async {
    setState(() => _saving = true);

    await _repo.updatePayoutOrder(
      widget.groupId,
      _order,
    );

    if (!mounted) return;

    setState(() => _saving = false);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final group = _repo.group(widget.groupId)!;

    return Scaffold(
      appBar: AppBar(
        leading: const MyBackButton(),
        title: const Text("Payout Order"),
      ),
      body: Column(
        children: [
          /// HEADER
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(AppTheme.spacing24),
            padding: const EdgeInsets.all(AppTheme.spacing20),
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: .08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  "Drag members to choose the payout order. "
                  "Position #1 receives the first payout, "
                  "#2 receives the second, and so on.",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),

          Expanded(
            child: ReorderableListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              buildDefaultDragHandles: false,
              itemCount: _order.length,
              onReorderItem: _onReorder,
              itemBuilder: (context, index) {
                final member = _repo.member(_order[index]);

                return Card(
                  key: ValueKey(_order[index]),
                  margin: const EdgeInsets.only(bottom: 14),
                  elevation: 0,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primary,
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      member?.name ?? "Unknown Member",
                    ),
                    subtitle: Text(
                      "Payout Position #${index + 1}",
                    ),
                    trailing: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(
                        Icons.drag_indicator,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(
                AppTheme.spacing24,
              ),
              child: PrimaryButton(
                label: _saving ? "Saving..." : "Save Payout Order",
                onPressed: _saving
                    ? () {}
                    : () {
                        _saveOrder();
                      },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
