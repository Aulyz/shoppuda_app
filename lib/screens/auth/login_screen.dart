import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (_usernameController.text == 'admin' &&
          _passwordController.text == 'admin123') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('로그인 성공! 대시보드로 이동합니다.'),
              backgroundColor: Color(0xFF667EEA),
              duration: Duration(seconds: 1),
            ),
          );

          await Future.delayed(const Duration(milliseconds: 500));

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('아이디 또는 비밀번호가 올바르지 않습니다.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 중 오류가 발생했습니다: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2D3A),
      body: Container(
        decoration: const BoxDecoration(
          // 배경 이미지
          image: DecorationImage(
            image: AssetImage('assets/images/world_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          // 그라디언트 오버레이 - 여기서 효과 조절
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.0, 0.3, 0.7, 1.0],
              colors: [
                const Color(0xFF1A1D29).withOpacity(0.7), // 상단 다크
                const Color(0xFF2A2D3A).withOpacity(0.4), // 중간 상단 투명
                const Color(0xFF2A2D3A).withOpacity(0.6), // 중간 하단 약간 다크
                const Color(0xFF1A1D29).withOpacity(0.9), // 하단 진한 다크
              ],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 60),

                        // 로고 및 타이틀
                        _buildHeader(),

                        const SizedBox(height: 60),

                        // 로그인 폼
                        _buildLoginForm(),

                        const SizedBox(height: 24), // 간격 조정

                        // Remember Me & Forgot Password
                        _buildOptionsRow(),

                        const SizedBox(height: 32),

                        // 로그인 버튼
                        _buildLoginButton(),

                        const SizedBox(height: 32),

                        // Or login with
                        _buildDivider(),

                        const SizedBox(height: 24),

                        // 소셜 로그인 버튼들
                        _buildSocialLoginButtons(),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // 앱 로고/아이콘
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)], // 보라-파랑 그라디언트
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667EEA).withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.admin_panel_settings_outlined,
            size: 40,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 32),

        // Login 타이틀
        Text(
          'Login',
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Shoppuda Admin Dashboard',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Email 레이블
        Text(
          'Email',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 8),

        // Email 입력 필드
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _usernameController,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500, // 폰트 굵기 증가
              color: const Color(0xFF1F2937), // 더 진한 텍스트 색상
            ),
            decoration: InputDecoration(
              hintText: 'ID',
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280), // 더 선명한 힌트 색상
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB), // 더 밝은 배경색
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF667EEA), // 보라-파랑으로 변경
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '아이디를 입력해주세요';
              }
              return null;
            },
            textInputAction: TextInputAction.next,
          ),
        ),

        const SizedBox(height: 20),

        // Password 레이블
        Text(
          'Password',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 8),

        // Password 입력 필드
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500, // 폰트 굵기 증가
              color: const Color(0xFF1F2937), // 더 진한 텍스트 색상
            ),
            decoration: InputDecoration(
              hintText: 'Password',
              hintStyle: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7280), // 더 선명한 힌트 색상
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB), // 더 밝은 배경색
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF667EEA), // 보라-파랑으로 변경
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: const Color(0xFF6B7280), // 더 선명한 아이콘 색상
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return '비밀번호를 입력해주세요';
              }
              if (value.length < 6) {
                return '비밀번호는 6자리 이상이어야 합니다';
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => _handleLogin(),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0), // 좌우 패딩 추가
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center, // 세로 정렬 추가
        children: [
          // Remember me
          Flexible(
            // Flexible로 감싸서 오버플로우 방지
            child: Row(
              mainAxisSize: MainAxisSize.min, // 최소 크기로 설정
              children: [
                Transform.scale(
                  scale: 0.8, // 스위치 크기 줄이기
                  child: Switch(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value;
                      });
                    },
                    activeColor: const Color(0xFF667EEA), // 보라-파랑으로 변경
                    inactiveThumbColor: const Color(0xFF6B7280),
                    inactiveTrackColor: const Color(0xFF374151),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                const SizedBox(width: 4), // 간격 줄이기
                Flexible(
                  // 텍스트도 Flexible로 감싸기
                  child: Text(
                    'Remember me',
                    style: GoogleFonts.inter(
                      fontSize: 13, // 폰트 크기 약간 줄이기
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF9CA3AF),
                    ),
                    overflow: TextOverflow.ellipsis, // 텍스트 오버플로우 처리
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8), // 중간 간격

          // Forgot password
          Flexible(
            // Flexible로 감싸기
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('비밀번호 찾기 기능 준비 중입니다.'),
                    backgroundColor: Color(0xFF00C896), // 🔄 초록색으로 복원
                  ),
                );
              },
              child: Text(
                'Forgot password?',
                style: GoogleFonts.inter(
                  fontSize: 13, // 폰트 크기 통일
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF9CA3AF),
                  decoration: TextDecoration.underline,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00C896).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleLogin,
        style: ElevatedButton.styleFrom(
          // 🎨 세련된 그라디언트 버튼
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ).copyWith(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            return Colors.transparent;
          }),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667EEA), Color(0xFF764BA2)], // 보라-파랑 그라디언트
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    'Login',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFF4B5563),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Or login with',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: const Color(0xFF4B5563),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Google 로그인
        _buildSocialButton(
          icon: 'G',
          backgroundColor: const Color(0xFF4B5563),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Google 로그인 준비 중입니다.'),
                backgroundColor: Color(0xFF667EEA), // 보라-파랑으로 변경
              ),
            );
          },
        ),

        // Apple 로그인
        _buildSocialButton(
          icon: '',
          iconWidget: const Icon(
            Icons.apple,
            color: Colors.white,
            size: 24,
          ),
          backgroundColor: const Color(0xFF4B5563),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Apple 로그인 준비 중입니다.'),
                backgroundColor: Color(0xFF667EEA), // 보라-파랑으로 변경
              ),
            );
          },
        ),

        // 카카오 로그인
        _buildSocialButton(
          icon: 'K',
          backgroundColor: const Color(0xFFFEE500),
          textColor: const Color(0xFF191919),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('카카오 로그인 준비 중입니다.'),
                backgroundColor: Color(0xFF667EEA), // 보라-파랑으로 변경
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String icon,
    Widget? iconWidget,
    required Color backgroundColor,
    Color textColor = Colors.white,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: iconWidget ??
              Text(
                icon,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
        ),
      ),
    );
  }
}
