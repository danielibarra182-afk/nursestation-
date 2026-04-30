import 'package:flutter/material.dart';

class MasterLayout extends StatelessWidget {
  final Widget child;
  final Widget? floatingActionButton;
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color primaryColor;
  final PreferredSizeWidget? bottom;
  final Widget? expandedWidget;
  final double expandedHeight;
  final Widget? leading;

  const MasterLayout({
    super.key,
    required this.child,
    this.floatingActionButton,
    required this.title,
    this.subtitle,
    this.icon,
    this.primaryColor = const Color(0xFF1B5AE6),
    this.bottom,
    this.expandedWidget,
    this.expandedHeight = 200.0,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      floatingActionButton: floatingActionButton,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: expandedHeight + (bottom?.preferredSize.height ?? 0.0),
              floating: true,
              pinned: true,
              snap: true,
              backgroundColor: primaryColor,
              bottom: bottom,
              leading: leading,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  var top = constraints.biggest.height;
                  var statusBarHeight = MediaQuery.of(context).padding.top;
                  
                  var expandedHeightValue = expandedHeight + (bottom?.preferredSize.height ?? 0.0);
                  var collapsedHeight = kToolbarHeight + (bottom?.preferredSize.height ?? 0.0);
                  
                  double t = (top - collapsedHeight) / (expandedHeightValue - collapsedHeight);
                  t = t.clamp(0.0, 1.0);

                  return FlexibleSpaceBar(
                    centerTitle: true,
                    titlePadding: EdgeInsets.only(bottom: 16.0 + (bottom?.preferredSize.height ?? 0.0)),
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: t < 0.5 ? 1.0 : 0.0,
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(color: primaryColor),
                        Opacity(
                          opacity: t,
                          child: expandedWidget != null
                              ? SafeArea(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: expandedWidget,
                                  ),
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: bottom != null ? 0 : 20),
                                    if (icon != null)
                                      Container(
                                        width: 70,
                                        height: 70,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 10,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          icon,
                                          color: primaryColor,
                                          size: 40,
                                        ),
                                      ),
                                    if (icon != null) const SizedBox(height: 12),
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    if (subtitle != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        subtitle!,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.white.withOpacity(0.8),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                    if (bottom != null) SizedBox(height: bottom!.preferredSize.height),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ];
        },
        body: child,
      ),
    );
  }
}
