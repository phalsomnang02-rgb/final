// ==========================================
// FILE: user_detail_screen.dart
// Detail Screen - ព័ត៌មានលម្អិតរបស់ User
// ==========================================

import 'package:flutter/material.dart';
import 'user_model.dart';

class UserDetailScreen extends StatelessWidget {
  final UserModel user;

  const UserDetailScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          'User Detail',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildCard(
                    title: 'Personal Info',
                    icon: Icons.person_outline,
                    children: [
                      _buildRow(Icons.tag, 'ID', '${user.id}'),
                      _buildRow(Icons.badge_outlined, 'Full Name',
                          '${user.name.firstname} ${user.name.lastname}'),
                      _buildRow(Icons.alternate_email, 'Username', ' ${user.username}'),
                      _buildRow(Icons.phone_outlined, 'Phone', user.phone),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    title: 'Contact Info',
                    icon: Icons.contact_mail_outlined,
                    children: [
                      _buildRow(Icons.email_outlined, 'Email', user.email),
                      _buildRow(Icons.lock_outline, 'Password', user.password),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    title: 'Address Info',
                    icon: Icons.location_on_outlined,
                    children: [
                      _buildRow(Icons.home_outlined, 'Street',
                          '${user.address.number} ${user.address.street}'),
                      _buildRow(Icons.location_city, 'City', user.address.city),
                      _buildRow(Icons.markunread_mailbox_outlined, 'Zipcode',
                          user.address.zipcode),
                      _buildRow(Icons.my_location, 'Lat', user.address.geolocation.lat),
                      _buildRow(Icons.my_location, 'Long', user.address.geolocation.long),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Color(0xFF5C6BC0)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: Text(
              user.name.firstname[0].toUpperCase(),
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '${user.name.firstname} ${user.name.lastname}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '@${user.username}',
            style: const TextStyle(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(fontSize: 13, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: Colors.indigo, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
            ]),
            const Divider(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17, color: Colors.grey),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}