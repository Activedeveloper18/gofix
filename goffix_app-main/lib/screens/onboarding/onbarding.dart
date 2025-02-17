import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:goffix/constants.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../signup/sign_in.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SignInScreen()),
    );
  }

  Widget _buildFullscreenImage() {
    return Image.asset(
      'assets/fullscreen.jpg',
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 1000]) {
    return Center(
        child: Image.asset(
      'assets/$assetName',
      width: width,
      fit: BoxFit.contain,
    ));
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      imageFlex: 2,
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,

      globalFooter: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style:
                ButtonStyle(backgroundColor: MaterialStateProperty.all(mainBlue)),
            child: const Text(
              'Let\'s go right away!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () => _onIntroEnd(context),
          ),
        ),
      ),
      pages: [
        PageViewModel(
            titleWidget: SizedBox(),
            bodyWidget:  Image.asset("assets/images/slide1.png",fit: BoxFit.fill,),
           ),
        // PageViewModel(
        //   title: "Easy Connect",
        //   body:
        //       "Easy Connect provides seeker and offeror to fulfill service and product need with the best customer experience",
        //   image: _buildImage('../assets/images/pic3.png'),
        //   decoration: pageDecoration,
        // ),
        PageViewModel(
          titleWidget: SizedBox(),
          bodyWidget:  Image.asset("assets/images/slide2.png"),
        ),
        // PageViewModel(
        //   title: "choose your service",
        //   body:
        //       "choose your service for the job,repair work,and medical services",
        //   image:Image.asset("assets/images/slide1.png",fit: BoxFit.fill,),
        //   decoration: pageDecoration,
        // ),
        PageViewModel(
          titleWidget: SizedBox(),
          bodyWidget:  Image.asset("assets/images/slide3.png"),
        ),
        // PageViewModel(
        //   title: "looking for products",
        //   body:
        //       "looking for products around your location with contact to purchase",
        //   image: _buildImage('images/pic2.png'),
        //   decoration: pageDecoration,
        // ),

        // PageViewModel(
        //   title: "convert to digital ad",
        //   body: "covert to digital ads with one-stop solutions",
        //   image: _buildImage('images/gdial.png'),
        //   decoration: pageDecoration,
        // ),
        // PageViewModel(
        //   title: "convert to digital ad",
        //   body: "covert to digital ads with one-stop solutions",
        //   image: _buildImage('images/pic4.png'),
        //   decoration: pageDecoration,
        // ),

        PageViewModel(
          titleWidget: SizedBox(),
          bodyWidget:  Image.asset("assets/images/slide4.png"),
        ),
        PageViewModel(
          titleWidget: SizedBox(),
          bodyWidget:  Image.asset("assets/images/slide5.png"),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text("This is the screen after Introduction")),
    );
  }
}
