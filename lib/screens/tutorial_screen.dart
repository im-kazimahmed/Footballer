import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:footballer/constants.dart';

import 'login.dart';

class TutorialScreen extends StatefulWidget {
  static const route = 'tutorial';
  const TutorialScreen({Key key}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

class _TutorialScreenState extends State<TutorialScreen>
    with SingleTickerProviderStateMixin {
  final _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.page.round() != _currentIndex) {
        setState(() => _currentIndex = _controller.page.round());
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                children: const [
                  _TutorialPanel(
                    asset: "assets/images/preview1.jpg",
                    title: 'Realtime Score',
                    body: 'Enjoy soccer match score updates in real time without missing a moment',
                  ),
                  _TutorialPanel(
                    asset: "assets/images/preview1.jpg",
                    title: 'Full Match Schedule',
                    body: 'The most complete match schedule of every football league in the world',
                  ),
                  // _TutorialPanel(
                  //   asset: "assets/images/Champions_League.png",
                  //   title: 'Latest News Updates',
                  //   body: 'Enjoy the latest news from the world of football in real time',
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: DotsIndicator(
                dotsCount: 2,
                decorator: DotsDecorator(
                  activeColor: COLOR_BLUE,
                  color: COLOR_GREY.withOpacity(0.3),
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
                position: _currentIndex * 1.0,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(30))
              ),
              child: InkWell(
                onTap: () {
                  if (_currentIndex == 1) {
                    Navigator.of(context).pushReplacementNamed(LoginScreen.route);
                  } else {
                    _controller.animateToPage(
                      _currentIndex + 1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.decelerate,
                    );
                  }
                },
                child: Ink(
                  color: COLOR_BLUE,
                  child: Text(
                    _currentIndex == 1 ? "Let's go!" : 'Next',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}

class _TutorialPanel extends StatelessWidget {
  final String asset, title, body;

  const _TutorialPanel({
    Key key,
    @required this.asset,
    @required this.title,
    @required this.body,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 42),
            child: Image.asset(
              asset,
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
          Text(
            title,
            style: textTheme.headline4.copyWith(
              color: COLOR_BLUE,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            body,
            textAlign: TextAlign.center,
            style: textTheme.headline3.copyWith(fontSize: 18, height: 1.2),
          ),
        ],
      ),
    );
  }
}
