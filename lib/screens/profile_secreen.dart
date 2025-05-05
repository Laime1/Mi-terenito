import 'package:flutter/material.dart';
import 'home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Pedro Perez Pereira');
  final TextEditingController _phoneController =
      TextEditingController(text: '72345686');
  final TextEditingController _emailController =
      TextEditingController(text: 'pedropepere@gmail.com');

  bool _isEditingName = false;
  bool _isEditingPhone = false;
  bool _isEditingEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Perfil de usuario', style: TextStyle(fontStyle: FontStyle.italic)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, size: 80, color: Colors.white),
            ),
            const SizedBox(height: 24),
            _buildEditableField(
              label: 'Nombre de usuario: ',
              controller: _nameController,
              isEditing: _isEditingName,
              onEdit: () => setState(() => _isEditingName = !_isEditingName),
            ),
            const SizedBox(height: 16),
            _buildEditableField(
              label: 'Telefono o celular: ',
              controller: _phoneController,
              isEditing: _isEditingPhone,
              onEdit: () => setState(() => _isEditingPhone = !_isEditingPhone),
            ),
            const SizedBox(height: 16),
            _buildEditableField(
              label: 'Correo: ',
              controller: _emailController,
              isEditing: _isEditingEmail,
              onEdit: () => setState(() => _isEditingEmail = !_isEditingEmail),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        },
        backgroundColor: const Color.fromARGB(255, 107, 131, 150),
        child: const Icon(Icons.home),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildEditableField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEdit,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          enabled: isEditing,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                isEditing ? Icons.check : Icons.edit,
                size: 18,
                color: isEditing ? Colors.green : const Color.fromARGB(255, 83, 103, 119),
              ),
              onPressed: onEdit,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
