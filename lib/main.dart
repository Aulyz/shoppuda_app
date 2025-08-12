import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// Provider들 import (나중에 생성할 예정)
// import 'providers/auth_provider.dart';
// import 'providers/dashboard_provider.dart';
// import 'providers/notification_provider.dart';

// 화면들 import (나중에 생성할 예정)
// import 'screens/auth/splash_screen.dart';
// import 'routes/app_routes.dart';

void main() {
  runApp(const ShoppudaAdminApp());
}

class ShoppudaAdminApp extends StatelessWidget {
  const ShoppudaAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 나중에 Provider들을 여기에 추가할 예정
        // ChangeNotifierProvider(create: (_) => AuthProvider()),
        // ChangeNotifierProvider(create: (_) => DashboardProvider()),
        // ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: 'Shoppuda Admin',
        debugShowCheckedModeBanner: false, // 디버그 배너 제거

        // 테마 설정 (다크모드 우선)
        theme: _buildLightTheme(),
        darkTheme: _buildDarkTheme(),
        themeMode: ThemeMode.dark, // 다크모드 기본값

        // 시작 화면 (현재는 임시 화면)
        home: const TemporaryHomeScreen(),

        // 나중에 라우팅 설정 추가
        // initialRoute: '/splash',
        // routes: AppRoutes.routes,
      ),
    );
  }

  // 라이트 테마 (추후 사용할 수도 있음)
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1976D2), // 파란색 계열
        brightness: Brightness.light,
      ),
      textTheme: GoogleFonts.notoSansTextTheme(),
    );
  }

  // 다크 테마 (메인 테마)
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1976D2), // 파란색 계열
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.notoSansTextTheme(
        ThemeData.dark().textTheme,
      ),

      // 다크모드 전용 색상 커스터마이징
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),

      // AppBar 스타일
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),

      // Card 스타일
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),

      // 버튼 스타일
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1976D2),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
      ),
    );
  }
}

// 임시 홈 화면 (실제 화면 완성될 때까지 사용)
class TemporaryHomeScreen extends StatelessWidget {
  const TemporaryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로고 영역 (나중에 실제 로고로 교체)
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 32),

            // 앱 이름
            Text(
              'Shoppuda',
              style: GoogleFonts.notoSans(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Admin Dashboard',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 48),

            // 로딩 인디케이터
            const CircularProgressIndicator(),

            const SizedBox(height: 16),

            Text(
              '앱을 준비 중입니다...',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 32),

            // 임시 버튼들 (개발 진행 상황 확인용)
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('로그인 화면 준비 중...')),
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('로그인'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('대시보드 준비 중...')),
                    );
                  },
                  icon: const Icon(Icons.dashboard),
                  label: const Text('대시보드'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('주문 관리 준비 중...')),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text('주문 관리'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
