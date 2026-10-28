import 'package:flutter/material.dart';

import '../controllers/contacts_controller.dart';
import '../core/app_colors.dart';
import '../widgets/add_contact_sheet.dart';
import '../widgets/contact_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/route_logo.dart';
import '../widgets/square_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ContactsController _controller = ContactsController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openAddSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.darkBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (_) => AddContactSheet(onSubmit: _controller.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final contacts = _controller.contacts;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.darkBlue,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            toolbarHeight: 72,
            titleSpacing: 16,
            title: const Align(
              alignment: Alignment.centerLeft,
              child: RouteLogo(),
            ),
          ),
          body: contacts.isEmpty
              ? const EmptyState()
              : GridView.builder(
                  // Extra bottom padding so the floating buttons never hide a card.
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 170),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: contacts.length,
                  itemBuilder: (context, index) => ContactCard(
                    contact: contacts[index],
                    onDelete: () => _controller.removeAt(index),
                  ),
                ),
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Delete the last item: only visible when the list is not empty.
              if (!_controller.isEmpty) ...[
                SquareFab(
                  icon: Icons.delete,
                  background: AppColors.red,
                  foreground: AppColors.white,
                  tooltip: 'Delete last contact',
                  onPressed: _controller.removeLast,
                ),
                const SizedBox(height: 16),
              ],
              // Add button disappears once 6 contacts are added.
              if (_controller.canAdd)
                SquareFab(
                  icon: Icons.add,
                  background: AppColors.gold,
                  foreground: AppColors.darkBlue,
                  tooltip: 'Add contact',
                  onPressed: _openAddSheet,
                ),
            ],
          ),
        );
      },
    );
  }
}
