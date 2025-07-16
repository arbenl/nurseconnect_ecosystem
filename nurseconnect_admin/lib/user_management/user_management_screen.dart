import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:nurseconnect_admin/user_management/user_management_repository.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final UserManagementRepository _repository = UserManagementRepository();
  late Future<List<DocumentSnapshot>> _usersFuture;
  late Future<List<DocumentSnapshot>> _nursesFuture;

  String _patientSearchQuery = '';
  String _nurseSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    _usersFuture = _repository.fetchAllUsers();
    _nursesFuture = _repository.fetchAllNurses();
  }

  void _refreshData() {
    setState(() {
      _fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
            tooltip: 'Refresh Data',
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: _buildUserList(
              context,
              'users',
              'Patients',
              _usersFuture,
              _patientSearchQuery,
              (query) => setState(() => _patientSearchQuery = query),
            ),
          ),
          Expanded(
            child: _buildUserList(
              context,
              'nurses',
              'Nurses',
              _nursesFuture,
              _nurseSearchQuery,
              (query) => setState(() => _nurseSearchQuery = query),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList(
    BuildContext context,
    String collection,
    String title,
    Future<List<DocumentSnapshot>> future,
    String searchQuery,
    Function(String) onSearch,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Search by name or email',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: onSearch,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Expanded(
          child: FutureBuilder<List<DocumentSnapshot>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No users found.'));
              }

              var users = snapshot.data!;

              if (searchQuery.isNotEmpty) {
                users = users.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final name = (data['name'] as String? ?? '').toLowerCase();
                  final email = (data['email'] as String? ?? '').toLowerCase();
                  final lowerCaseQuery = searchQuery.toLowerCase();

                  return name.contains(lowerCaseQuery) || email.contains(lowerCaseQuery);
                }).toList();
              }

              if (users.isEmpty) {
                return const Center(child: Text('No users match your search.'));
              }

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final userData = user.data() as Map<String, dynamic>;
                  final userName = userData['name'] ?? 'N/A';
                  final userEmail = userData['email'] ?? 'N/A';

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: ListTile(
                      title: Text(userName),
                      subtitle: Text(userEmail),
                      onTap: () => context.go('/user-detail/$collection/${user.id}'),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
