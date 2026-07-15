import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../../../widgets/primary_button.dart';

class AddManageMembersScreen extends StatefulWidget {
  const AddManageMembersScreen({super.key});

  @override
  State<AddManageMembersScreen> createState() => _AddManageMembersScreenState();
}

class _AddManageMembersScreenState extends State<AddManageMembersScreen> {
  final List<String> _members = ['Amina', 'Dayo', 'Nneka'];
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage members')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invite members',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacing16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacing12),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.add_circle_outline),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing24),
            Text(
              'Current order',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacing12),
            Expanded(
              child: ReorderableListView(
                children: [
                  for (int index = 0; index < _members.length; index++)
                    ListTile(
                      key: ValueKey(_members[index]),
                      title: Text(_members[index]),
                      subtitle: const Text('Payout rotation'),
                      trailing: const Icon(Icons.drag_handle),
                    ),
                ],
                onReorderItem: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) newIndex--;
                    final item = _members.removeAt(oldIndex);
                    _members.insert(newIndex, item);
                  });
                },
              ),
            ),
            PrimaryButton(
              label: 'Save order',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
