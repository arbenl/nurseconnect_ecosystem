import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailScreen extends StatefulWidget {
  final String userId;
  final String collectionName;

  const UserDetailScreen({
    super.key,
    required this.userId,
    required this.collectionName,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late Future<DocumentSnapshot> _userFuture;
  bool _isEditing = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUser();
  }

  Future<DocumentSnapshot> _fetchUser() {
    return FirebaseFirestore.instance
        .collection(widget.collectionName)
        .doc(widget.userId)
        .get();
  }

  void _initializeControllers(Map<String, dynamic> data) {
    _controllers = {
      for (var entry in data.entries)
        entry.key: TextEditingController(text: entry.value.toString()),
    };
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedData = {
        for (var entry in _controllers.entries)
          entry.key: entry.value.text,
      };

      // await FirebaseFunctions.instance.httpsCallable('updateNurseProfile').call({
      //   'uid': widget.userId,
      //   'data': updatedData,
      // });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      setState(() {
        _isEditing = false;
        _userFuture = _fetchUser(); // Refresh data
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleSuspendUser(bool isSuspended) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isSuspended ? 'Unsuspend User' : 'Suspend User'),
        content: Text(
            'Are you sure you want to ${isSuspended ? 'unsuspend' : 'suspend'} this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(isSuspended ? 'Unsuspend' : 'Suspend'),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // await FirebaseFunctions.instance.httpsCallable('suspendUser').call({
      //   'uid': widget.userId,
      //   'suspend': !isSuspended,
      // });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User ${!isSuspended ? 'suspended' : 'unsuspended'} successfully!')),
      );

      setState(() {
        _userFuture = _fetchUser(); // Refresh data
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user status: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () => setState(() => _isEditing = false),
            ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User not found.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          if (!_isEditing) {
            _initializeControllers(userData);
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isEditing
                ? _buildEditView(userData)
                : _buildReadOnlyView(userData),
          );
        },
      ),
    );
  }

  Widget _buildReadOnlyView(Map<String, dynamic> userData) {
    final userName = userData['name'] ?? 'N/A';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(userName, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(children: [
            ...userData.entries.map((entry) {
              return ListTile(
                title: Text(entry.key),
                subtitle: Text(entry.value.toString()),
              );
            }),
          ]),
        ),
        _buildActionButtons(userData),
      ],
    );
  }

  Widget _buildEditView(Map<String, dynamic> userData) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(children: [
              ..._controllers.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextFormField(
                    controller: entry.value,
                    decoration: InputDecoration(
                      labelText: entry.key,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a value';
                      }
                      return null;
                    },
                  ),
                );
              }),
            ]),
          ),
          _buildActionButtons(userData),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> userData) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    final isSuspended = userData['disabled'] ?? false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _isEditing
          ? [
              ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save),
                label: const Text('Save Changes'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              ),
            ]
          : [
              ElevatedButton.icon(
                onPressed: () => setState(() => _isEditing = true),
                icon: const Icon(Icons.edit),
                label: const Text('Edit'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              ),
              ElevatedButton.icon(
                onPressed: () => _toggleSuspendUser(isSuspended),
                icon: Icon(isSuspended ? Icons.play_arrow : Icons.block),
                label: Text(isSuspended ? 'Unsuspend' : 'Suspend'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSuspended ? Colors.green : Colors.orange,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement Reset Password
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password reset functionality not implemented yet.')),
                  );
                },
                icon: const Icon(Icons.lock_reset),
                label: const Text('Reset Password'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
