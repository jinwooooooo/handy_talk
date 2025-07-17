import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;
  final int _nicknameMaxLength = 12;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 300,
      maxHeight: 300,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _profileImage = null;
    });
  }

  Future<void> _saveProfile() async {
    final nickname = _nicknameController.text.trim();
    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임을 입력해 주세요.')),
      );
      return;
    }
    if (nickname.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('닉네임은 2글자 이상이어야 해요.')),
      );
      return;
    }
    setState(() {
      _isLoading = true;
    });
    // TODO: 닉네임/프로필 이미지 저장 로직 (Firebase 등)
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('프로필이 저장되었습니다!')),
    );
    // TODO: 메인 화면 등으로 이동
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lavender = const Color(0xFFA084E8);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              children: [
                // 상단 로고+멘트만 살짝 위로
                SizedBox(height: 80),
                Column(
                  children: [
                    Icon(
                      Icons.favorite,
                      color: lavender,
                      size: 56,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '따뜻한 손글씨로 오늘을 나눠보세요.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nanumPenScript(
                        color: lavender,
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 36),
                // 나머지 UI(프로필/닉네임/버튼 등)는 중앙에 유지
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: lavender.withOpacity(0.08),
                      backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                      child: _profileImage == null
                          ? Icon(Icons.person, size: 54, color: Colors.grey[300])
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Row(
                        children: [
                          if (_profileImage != null)
                            GestureDetector(
                              onTap: _removeImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(Icons.close, size: 18, color: Colors.grey),
                              ),
                            ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: lavender,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: lavender.withOpacity(0.15),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _nicknameController,
                  maxLength: _nicknameMaxLength,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: '닉네임을 입력해 주세요 (최대 12자)',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(color: lavender, width: 1),
                    ),
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                  ),
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 12),
                Text(
                  '닉네임은 친구와 손글씨를 주고받기 위해 사용돼요',
                  style: TextStyle(color: Colors.black45, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lavender,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text('저장', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 