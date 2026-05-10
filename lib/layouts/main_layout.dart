import 'package:buraq_enterprise_employee/core/config/extensions/app_colors_extension.dart';
import 'package:buraq_enterprise_employee/core/constants/app_constants.dart';
import 'package:buraq_enterprise_employee/utils/widgets/app_text.dart';
import 'package:buraq_enterprise_employee/utils/widgets/buttons/theme_toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MainLayout extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const MainLayout({super.key, required this.navigationShell});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String _heading = '';
  String? _subHeading;
  bool _isNestedRoute = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTitles();
  }

  @override
  void didUpdateWidget(covariant MainLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateTitles();
  }

  void _updateTitles() {
    final location = GoRouterState.of(context).uri.toString();
    final mainRoutes = ['/home', '/add-expense', '/returns', '/profile'];
    _isNestedRoute = !mainRoutes.contains(location);

    final titles = {
      mainRoutes[0]: {
        "heading": "Welcome Back",
        "subHeading": "Here's your expense overview",
      },
      mainRoutes[1]: {
        "heading": "Add Expense",
        "subHeading": "Record your purchase details",
      },
      mainRoutes[2]: {
        "heading": "Returns & Refunds",
        "subHeading": "Return unused materials to shopkeeper",
      },
      mainRoutes[3]: {
        "heading": "Profile & Settings",
        "subHeading": "Manage your account preferences",
      },
    };

    // Handle dynamic titles for nested routes
    if (location.startsWith('/projects/manage/')) {
      final projectId = location.split('/').last;
      _heading = 'Manage $projectId';
      _subHeading = null;
    } else {
      _heading = titles[location]?["heading"] ?? "";
      _subHeading = titles[location]?["subHeading"];
    }
  }

  @override
  Widget build(BuildContext context) {
    void onItemTapped(int index) {
      widget.navigationShell.goBranch(
        index,
        initialLocation: index == widget.navigationShell.currentIndex,
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: AppConstants.appBarHight,
        leading: _isNestedRoute
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  if (GoRouter.of(context).canPop()) {
                    context.pop();
                  }
                },
              )
            : null,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextHeading(
              text: _heading,
              fontSize: AppConstants.mainHeadingFontSize,
            ),
            _subHeading != null
                ? const SizedBox(height: 2.5)
                : const SizedBox.shrink(),
            _subHeading != null
                ? AppTextBody(
                    text: _subHeading!,
                    color: context.appColors.secondary,
                  )
                : const SizedBox.shrink(),
          ],
        ),
        actions: const [ThemeToggleButton()],
      ),
      body: Padding(
        padding: EdgeInsets.all(AppConstants.padding),
        child: widget.navigationShell,
      ),
      bottomNavigationBar: bottomNavBar(context, onItemTapped),
    );
  }

  BottomNavigationBar bottomNavBar(
    BuildContext context,
    void Function(int index) onItemTapped,
  ) {
    return BottomNavigationBar(
      selectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontWeight: FontWeight.w600),
      currentIndex: widget.navigationShell.currentIndex,
      onTap: onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.maps_home_work_outlined),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Add Expense',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.refresh), label: 'Returns'),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Profile',
        ),
      ],
    );
  }
}
