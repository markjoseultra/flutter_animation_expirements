import 'package:flutter/material.dart';
import 'package:flutter_animations_expirement/basic_parallax_animation.dart';
import 'package:flutter_animations_expirement/custom_explicit_animation.dart';
import 'package:flutter_animations_expirement/custom_implicit_animation.dart';
import 'package:flutter_animations_expirement/explicit_animation.dart';
import 'package:flutter_animations_expirement/implicit_animation_page.dart';
import 'package:flutter_animations_expirement/lottie_animation.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _mainpageScaffold = GlobalKey();

  final PageController _pageController = PageController();

  String textTitle = "Animation Expirement";

  void handleOnSelectMenu(
      {required int newPageIndex, required String newTextTitle}) {
    _mainpageScaffold.currentState?.closeDrawer();

    setState(() {
      textTitle = newTextTitle;
      _pageController.jumpToPage(newPageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _mainpageScaffold,
      drawer: Container(
        height: double.infinity,
        width: MediaQuery.of(context).size.width * 0.75,
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    child: const Text("Custom Explicit Animations"),
                    onPressed: () {
                      handleOnSelectMenu(
                        newPageIndex: 0,
                        newTextTitle: "Custom Explicit Animations",
                      );
                    },
                  ),
                  TextButton(
                    child: const Text("Implicit Animations"),
                    onPressed: () {
                      handleOnSelectMenu(
                        newPageIndex: 1,
                        newTextTitle: "Implicit Animations",
                      );
                    },
                  ),
                  TextButton(
                    child: const Text("Custom Implicit Animations"),
                    onPressed: () {
                      handleOnSelectMenu(
                        newPageIndex: 2,
                        newTextTitle: "Custom Implicit Animations",
                      );
                    },
                  ),
                  TextButton(
                    child: const Text("Explicit Animations"),
                    onPressed: () {
                      handleOnSelectMenu(
                        newPageIndex: 3,
                        newTextTitle: "Explicit Animations",
                      );
                    },
                  ),
                  TextButton(
                    child: const Text("Lottie  Animations"),
                    onPressed: () {
                      handleOnSelectMenu(
                        newPageIndex: 4,
                        newTextTitle: "Lottie Animations",
                      );
                    },
                  ),
                  TextButton(
                    child: const Text("Basic Parallax Animation"),
                    onPressed: () {
                      handleOnSelectMenu(
                        newPageIndex: 5,
                        newTextTitle: "Basic Parallax Animation",
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _mainpageScaffold.currentState?.openDrawer();
          },
        ),
        title: Text(textTitle),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: const [
          CustomExplicitAnimation(),
          ImplicitAnimationPage(),
          CustomImplicitAnimation(),
          ExplicitAnimation(),
          LottieAnimation(),
          BasicParallaxAnimation(),
        ],
      ),
    );
  }
}
