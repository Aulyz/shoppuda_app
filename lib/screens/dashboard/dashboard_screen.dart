import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../auth/login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedNavIndex = 0;

  // 임시 더미 데이터 (나중에 API에서 가져올 예정)
  final Map<String, dynamic> _dashboardData = {
    'total_sales': 2847000,
    'total_orders': 156,
    'total_products': 1247,
    'low_stock_count': 23,
    'connected_platforms': 3,
    'daily_sales': [
      {'date': '8/6', 'amount': 380000},
      {'date': '8/7', 'amount': 420000},
      {'date': '8/8', 'amount': 350000},
      {'date': '8/9', 'amount': 480000},
      {'date': '8/10', 'amount': 520000},
      {'date': '8/11', 'amount': 390000},
      {'date': '8/12', 'amount': 460000},
    ],
    'category_sales': [
      {'name': '전자제품', 'value': 35, 'color': 0xFF2196F3},
      {'name': '의류', 'value': 28, 'color': 0xFF4CAF50},
      {'name': '홈&리빙', 'value': 22, 'color': 0xFFFF9800},
      {'name': '기타', 'value': 15, 'color': 0xFF9C27B0},
    ],
    'recent_orders': [
      {
        'id': 'ORD-001',
        'customer': '노종환',
        'amount': 89000,
        'status': 'SHIPPED',
        'time': '2시간 전'
      },
      {
        'id': 'ORD-002',
        'customer': '박민우',
        'amount': 125000,
        'status': 'PROCESSING',
        'time': '3시간 전'
      },
      {
        'id': 'ORD-003',
        'customer': '우지민',
        'amount': 67000,
        'status': 'CONFIRMED',
        'time': '5시간 전'
      },
    ],
    'recent_notifications': [
      {
        'type': 'LOW_STOCK',
        'message': '아이폰 케이스 재고 부족 (5개 남음)',
        'time': '10분 전'
      },
      {
        'type': 'NEW_ORDER',
        'message': '새로운 주문이 접수되었습니다 (ORD-001)',
        'time': '2시간 전'
      },
      {
        'type': 'PLATFORM_SYNC',
        'message': '쿠팡 상품 동기화가 완료되었습니다',
        'time': '3시간 전'
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshDashboard,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 헤더 섹션
                _buildHeaderSection(),

                const SizedBox(height: 24),

                // 핵심 지표 카드들
                _buildMetricsCards(),

                const SizedBox(height: 24),

                // 차트 섹션
                _buildChartsSection(),

                const SizedBox(height: 24),

                // 최근 활동 섹션
                _buildRecentActivitySection(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.admin_panel_settings,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Text(
            'Shoppuda',
            style: GoogleFonts.notoSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      actions: [
        // 알림 아이콘
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () {
                // TODO: 알림 화면으로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('알림 기능 준비 중입니다.')),
                );
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '3',
                    style: GoogleFonts.notoSans(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // 프로필 아이콘
        PopupMenuButton<String>(
          icon: const Icon(Icons.account_circle_outlined),
          onSelected: (String value) {
            if (value == 'logout') {
              _showLogoutDialog();
            } else if (value == 'profile') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('프로필 기능 준비 중입니다.')),
              );
            }
          },
          itemBuilder: (BuildContext context) => [
            PopupMenuItem<String>(
              value: 'profile',
              child: Row(
                children: [
                  const Icon(Icons.person, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    '프로필',
                    style: GoogleFonts.notoSans(fontSize: 14),
                  ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'logout',
              child: Row(
                children: [
                  const Icon(Icons.logout, size: 20, color: Colors.red),
                  const SizedBox(width: 12),
                  Text(
                    '로그아웃',
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '안녕하세요, 관리자님! 👋',
          style: GoogleFonts.notoSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '오늘 하루 쇼핑몰 현황을 확인해보세요',
          style: GoogleFonts.notoSans(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsCards() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.4,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        _buildMetricCard(
          title: '총 매출 (30일)',
          value:
              '₩${(_dashboardData['total_sales'] / 1000).toStringAsFixed(0)}K',
          subtitle: '전월 대비 +12%',
          icon: Icons.trending_up,
          color: Colors.green,
          backgroundColor: Colors.green.withOpacity(0.1),
        ),
        _buildMetricCard(
          title: '총 주문',
          value: '${_dashboardData['total_orders']}',
          subtitle:
              '평균 ${(_dashboardData['total_sales'] / _dashboardData['total_orders'] / 1000).toStringAsFixed(0)}K원',
          icon: Icons.shopping_cart,
          color: Colors.blue,
          backgroundColor: Colors.blue.withOpacity(0.1),
        ),
        _buildMetricCard(
          title: '총 상품',
          value: '${_dashboardData['total_products']}',
          subtitle: '${_dashboardData['low_stock_count']}개 재고 부족',
          icon: Icons.inventory,
          color: Colors.orange,
          backgroundColor: Colors.orange.withOpacity(0.1),
        ),
        _buildMetricCard(
          title: '연동 플랫폼',
          value: '${_dashboardData['connected_platforms']}',
          subtitle: '실시간 동기화',
          icon: Icons.sync,
          color: Colors.purple,
          backgroundColor: Colors.purple.withOpacity(0.1),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.notoSans(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Column(
      children: [
        // 매출 차트
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '최근 7일 매출 추이',
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 200,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${(value / 1000).toStringAsFixed(0)}K',
                              style: GoogleFonts.notoSans(
                                  fontSize: 10, color: Colors.grey),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final salesData =
                                _dashboardData['daily_sales'] as List;
                            if (value.toInt() < salesData.length) {
                              return Text(
                                salesData[value.toInt()]['date'],
                                style: GoogleFonts.notoSans(
                                    fontSize: 10, color: Colors.grey),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: (_dashboardData['daily_sales'] as List)
                            .asMap()
                            .entries
                            .map((e) => FlSpot(
                                e.key.toDouble(), e.value['amount'].toDouble()))
                            .toList(),
                        isCurved: true,
                        color: Theme.of(context).primaryColor,
                        barWidth: 3,
                        belowBarData: BarAreaData(
                          show: true,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.1),
                        ),
                        dotData: FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) {
                            return FlDotCirclePainter(
                              radius: 4,
                              color: Theme.of(context).primaryColor,
                              strokeColor: Colors.white,
                              strokeWidth: 2,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 카테고리 차트
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '카테고리별 판매 비율',
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  // 파이 차트
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: PieChart(
                      PieChartData(
                        sections: (_dashboardData['category_sales'] as List)
                            .map((category) => PieChartSectionData(
                                  value: category['value'].toDouble(),
                                  color: Color(category['color']),
                                  title: '${category['value']}%',
                                  radius: 50,
                                  titleStyle: GoogleFonts.notoSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ))
                            .toList(),
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),

                  const SizedBox(width: 24),

                  // 범례
                  Expanded(
                    child: Column(
                      children: (_dashboardData['category_sales'] as List)
                          .map((category) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Color(category['color']),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        category['name'],
                                        style: GoogleFonts.notoSans(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${category['value']}%',
                                      style: GoogleFonts.notoSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      children: [
        // 최근 주문
        _buildActivityCard(
          title: '최근 주문',
          icon: Icons.shopping_cart_outlined,
          color: Colors.blue,
          items: (_dashboardData['recent_orders'] as List)
              .map((order) => _buildOrderItem(order))
              .toList(),
        ),

        const SizedBox(height: 16),

        // 최근 알림
        _buildActivityCard(
          title: '최근 알림',
          icon: Icons.notifications_outlined,
          color: Colors.orange,
          items: (_dashboardData['recent_notifications'] as List)
              .map((notification) => _buildNotificationItem(notification))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> items,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    Color statusColor;
    String statusText;

    switch (order['status']) {
      case 'SHIPPED':
        statusColor = Colors.green;
        statusText = '배송중';
        break;
      case 'PROCESSING':
        statusColor = Colors.blue;
        statusText = '처리중';
        break;
      case 'CONFIRMED':
        statusColor = Colors.orange;
        statusText = '주문확인';
        break;
      default:
        statusColor = Colors.grey;
        statusText = '대기중';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order['id'],
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      order['time'],
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order['customer']} • ₩${(order['amount'] / 1000).toStringAsFixed(0)}K',
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.notoSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    Color typeColor;
    IconData typeIcon;

    switch (notification['type']) {
      case 'LOW_STOCK':
        typeColor = Colors.red;
        typeIcon = Icons.warning;
        break;
      case 'NEW_ORDER':
        typeColor = Colors.blue;
        typeIcon = Icons.shopping_cart;
        break;
      case 'PLATFORM_SYNC':
        typeColor = Colors.green;
        typeIcon = Icons.sync;
        break;
      default:
        typeColor = Colors.grey;
        typeIcon = Icons.info;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(typeIcon, size: 16, color: typeColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['message'],
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification['time'],
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _selectedNavIndex,
      onTap: (index) {
        setState(() {
          _selectedNavIndex = index;
        });

        // TODO: 각 탭에 맞는 화면으로 이동
        String message = '';
        switch (index) {
          case 0:
            message = '대시보드입니다';
            break;
          case 1:
            message = '주문 관리 화면으로 이동';
            break;
          case 2:
            message = '상품 관리 화면으로 이동';
            break;
          case 3:
            message = '재고 관리 화면으로 이동';
            break;
          case 4:
            message = '더보기 메뉴';
            break;
        }

        if (index != 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).cardColor,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey[400],
      selectedLabelStyle:
          GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.notoSans(fontSize: 12),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_outlined),
          activeIcon: Icon(Icons.dashboard),
          label: '대시보드',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          activeIcon: Icon(Icons.shopping_cart),
          label: '주문',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_outlined),
          activeIcon: Icon(Icons.inventory),
          label: '상품',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.warehouse_outlined),
          activeIcon: Icon(Icons.warehouse),
          label: '재고',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.more_horiz_outlined),
          activeIcon: Icon(Icons.more_horiz),
          label: '더보기',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // TODO: 빠른 작업 메뉴 표시
        _showQuickActionMenu();
      },
      backgroundColor: Theme.of(context).primaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  void _showQuickActionMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '빠른 작업',
              style: GoogleFonts.notoSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionItem(Icons.add_box, '상품 추가', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('상품 추가 기능 준비 중입니다.')),
                  );
                }),
                _buildQuickActionItem(Icons.inventory, '재고 조정', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('재고 조정 기능 준비 중입니다.')),
                  );
                }),
                _buildQuickActionItem(Icons.sync, '동기화', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('동기화를 시작합니다.')),
                  );
                }),
                _buildQuickActionItem(Icons.assessment, '보고서', () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('보고서 기능 준비 중입니다.')),
                  );
                }),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
      IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  // 대시보드 새로고침 함수
  Future<void> _refreshDashboard() async {
    // TODO: 실제 API 호출로 데이터 새로고침
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('대시보드가 새로고침되었습니다.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  // 로그아웃 확인 다이얼로그
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                '로그아웃',
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
          content: Text(
            '정말로 로그아웃 하시겠습니까?',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
              child: Text(
                '취소',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  color: Colors.grey[400],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
                _handleLogout(); // 로그아웃 실행
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '로그아웃',
                style: GoogleFonts.notoSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // 로그아웃 처리 함수
  void _handleLogout() {
    // TODO: 실제 로그아웃 로직 (토큰 삭제, 상태 초기화 등)

    // 로그아웃 성공 메시지
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('로그아웃되었습니다.'),
        backgroundColor: Color(0xFF35C2C1),
        duration: Duration(seconds: 1),
      ),
    );

    // 로그인 화면으로 이동 (모든 스택 제거)
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // 모든 이전 루트 제거
    );
  }
}
