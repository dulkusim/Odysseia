import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  FriendsScreenState createState() => FriendsScreenState();
}

class FriendsScreenState extends State<FriendsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _friends = [];
  List<Map<String, dynamic>> _filteredFriends = [];
  List<Map<String, dynamic>> _friendRequests = [];

  List<Map<String, dynamic>> _globalUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchFriendsAndRequests();
  }

  /// Fetch friends and friend requests from Firestore
  Future<void> _fetchFriendsAndRequests() async {
    setState(() => _isLoading = true);

    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return;

      // Fetch user's friends
      final userDoc = await _firestore.collection('Users').doc(currentUser.uid).get();
      final friends = List<String>.from(userDoc.data()?['friends'] ?? []);
      final friendProfiles = await Future.wait(friends.map((id) async {
        final doc = await _firestore.collection('Users').doc(id).get();
        return {
          'id': id,
          'username': doc.data()?['username'] ?? 'Unknown',
          'profilepicture': doc.data()?['profilepicture'] ?? '',
        };
      }));

      // Fetch friend requests
      final friendRequests = List<String>.from(userDoc.data()?['friendRequests'] ?? []);
      final requestProfiles = await Future.wait(friendRequests.map((id) async {
        final doc = await _firestore.collection('Users').doc(id).get();
        return {
          'id': id,
          'username': doc.data()?['username'] ?? 'Unknown',
          'profilepicture': doc.data()?['profilepicture'] ?? '',
        };
      }));

      setState(() {
        _friends = friendProfiles;
        _filteredFriends = List.from(_friends);
        _friendRequests = requestProfiles;
      });
    } catch (e) {
      print('Error fetching friends and requests: $e');
    }

    setState(() => _isLoading = false);
  }

  /// Handle accepting a friend request
  Future<void> _acceptFriendRequest(String requesterId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      // Add to each other's friend list
      await _firestore.collection('Users').doc(currentUser.uid).update({
        'friends': FieldValue.arrayUnion([requesterId]),
        'friendRequests': FieldValue.arrayRemove([requesterId]),
      });
      await _firestore.collection('Users').doc(requesterId).update({
        'friends': FieldValue.arrayUnion([currentUser.uid]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request accepted!')),
      );

      // Refresh data
      await _fetchFriendsAndRequests();
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }

  /// Handle rejecting a friend request
  Future<void> _rejectFriendRequest(String requesterId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      // Remove the request
      await _firestore.collection('Users').doc(currentUser.uid).update({
        'friendRequests': FieldValue.arrayRemove([requesterId]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request rejected.')),
      );

      // Refresh data
      await _fetchFriendsAndRequests();
    } catch (e) {
      print('Error rejecting friend request: $e');
    }
  }

  /// Handle removing a friend
  Future<void> _removeFriend(String friendId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      // Remove from both users' friend lists
      await _firestore.collection('Users').doc(currentUser.uid).update({
        'friends': FieldValue.arrayRemove([friendId]),
      });
      await _firestore.collection('Users').doc(friendId).update({
        'friends': FieldValue.arrayRemove([currentUser.uid]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend removed.')),
      );

      // Refresh data
      await _fetchFriendsAndRequests();
    } catch (e) {
      print('Error removing friend: $e');
    }
  }

  /// Send a friend request
  Future<void> _sendFriendRequest(String userId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      await _firestore.collection('Users').doc(userId).update({
        'friendRequests': FieldValue.arrayUnion([currentUser.uid]),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Friend request sent!')),
      );
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }

  /// Show user profile
  void _viewProfile(String userId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing profile for user: $userId')),
    );
  }

  /// Triggered when the search query changes
  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFriends = List.from(_friends);
        _filteredUsers = [];
      });
    } else {
      _searchUsers(query);
    }
  }

  /// Search global users from Firestore
  Future<void> _searchUsers(String query) async {
    setState(() => _isLoading = true);

    try {
      final snapshot = await _firestore
          .collection('Users')
          .where('username', isGreaterThanOrEqualTo: query)
          .where('username', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      final users = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'username': doc['username'] ?? 'Unknown',
          'profilepicture': doc['profilepicture'] ?? '',
          'isFriend': _friends.any((friend) => friend['id'] == doc.id),
        };
      }).toList();

      setState(() {
        _globalUsers = users;
        _filteredUsers = List.from(_globalUsers);
      });
    } catch (e) {
      print('Error searching users: $e');
    }

    setState(() => _isLoading = false);
  }

  /// Helper function to handle avatar logic
  ImageProvider<Object> _buildAvatar(String? picUrl) {
    if (picUrl != null && picUrl.isNotEmpty) {
      try {
        return NetworkImage(picUrl);
      } catch (e) {
        print('Invalid URL for profile picture: $picUrl');
      }
    }
    return const AssetImage('assets/default_avatar.png');
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: _isSearching
          ? TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _onSearchChanged,
              decoration: const InputDecoration(
                hintText: 'Search users...',
                border: InputBorder.none,
              ),
            )
          : const Text('Friends'),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
                _onSearchChanged('');
              }
            });
          },
        ),
      ],
    );
  }

  Widget _buildPopupMenu(String userId, bool isFriend) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'view') {
          _viewProfile(userId);
        } else if (value == 'remove') {
          _removeFriend(userId);
        } else if (value == 'add') {
          _sendFriendRequest(userId);
        }
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 'view',
            child: Text('View Profile'),
          ),
          if (isFriend)
            const PopupMenuItem(
              value: 'remove',
              child: Text('Remove Friend'),
            ),
          if (!isFriend)
            const PopupMenuItem(
              value: 'add',
              child: Text('Add Friend'),
            ),
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_friendRequests.isNotEmpty) ...[
                  const Text(
                    'Friend Requests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._friendRequests.map((request) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: _buildAvatar(request['profilepicture']),
                      ),
                      title: Text(request['username']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.green),
                            onPressed: () => _acceptFriendRequest(request['id']),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => _rejectFriendRequest(request['id']),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                ],
                const Text(
                  'My Friends',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ..._filteredFriends.map((friend) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: _buildAvatar(friend['profilepicture']),
                    ),
                    title: Text(friend['username']),
                    trailing: _buildPopupMenu(friend['id'], true),
                  );
                }),
                if (_isSearching) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Global Users',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._filteredUsers.map((user) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: _buildAvatar(user['profilepicture']),
                      ),
                      title: Text(user['username']),
                      trailing: _buildPopupMenu(user['id'], user['isFriend']),
                    );
                  }),
                ],
              ],
            ),
    );
  }
}
