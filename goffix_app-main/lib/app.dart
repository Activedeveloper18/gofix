// app.dart

// import 'package:Kare.ai/screens/home/home.dart';
// import 'package:Kare.ai/screens/otp/otp.dart';
// import 'package:Kare.ai/screens/profile/profile_screen.dart';
// import 'package:Kare.ai/screens/symtomchecker/demo.dart';
// import 'package:Kare.ai/screens/symtomchecker/demo1.dart';
// import 'package:Kare.ai/screens/symtomchecker/symtomchecker.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:goffix/screens/AdService/BookAdService.dart';
import 'package:goffix/screens/CauroselDemo.dart';
import 'package:goffix/screens/ForgotPassword/changePassword.dart';
import 'package:goffix/screens/ForgotPassword/forgotPassword.dart';
import 'package:goffix/screens/chat/chat.dart';
import 'package:goffix/screens/config/configScreen.dart';
import 'package:goffix/screens/home/providers/eventTicketProvider.dart';
import 'package:goffix/screens/home/providers/homeProvider.dart';
import 'package:goffix/screens/image/image.dart';
import 'package:goffix/screens/image/image_upload.dart';
import 'package:goffix/screens/layout/layout.dart';
import 'package:goffix/screens/login/login.dart';
import 'package:goffix/screens/login/screens/splash_screen.dart';
import 'package:goffix/screens/login/utils/app_theme.dart';
import 'package:goffix/screens/login/utils/route_generator.dart';
import 'package:goffix/screens/network/network_test.dart';
import 'package:goffix/screens/otp/otpScreen.dart';
import 'package:goffix/screens/profile/ProfileScreen.dart';
import 'package:goffix/screens/profile/ProfileScreenNew.dart';
import 'package:goffix/screens/profile/tab3.dart';
import 'package:goffix/screens/profile/tabs2.dart';
import 'package:goffix/screens/search/BookService.dart';
import 'package:goffix/screens/search/BookingStatus.dart';
import 'package:goffix/screens/search/SearchScreen.dart';
import 'package:goffix/screens/search/searchResult.dart';
import 'package:goffix/screens/settings/editProfile.dart';
// import 'package:goffix/screens/message/message.dart';
import 'package:goffix/screens/settings/settings.dart';
import 'package:goffix/screens/signup/signup.dart';
import 'package:goffix/screens/sliderButton.dart';
import 'package:goffix/screens/test_fetch.dart';
import 'package:goffix/screens/otp/otpScreen.dart';
import 'package:goffix/screens/test_popover.dart';
import 'package:goffix/screens/welcome/welcome.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

// import 'package:goffix/screens/chat/chat.dart';
// import 'package:goffix/screens/chat/chat_ui/chat.dart';
// import 'screens/login/login_screen.dart';
// import 'screens/login/login.dart';
import 'constants.dart';
import 'screens/eventBooking/eventListing.dart';
// import 'screens/welcome/welcome_screen.dart';
// import 'screens/signup/signup_screen.dart';
// import 'package:Kare.ai/screens/home/home.dart';
// import 'package:Kare.ai/screens/layout/layout.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return FirebasePhoneAuthProvider(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeProvider>(
            create: (context) => HomeProvider(),
          ),
          ChangeNotifierProvider<EventTicketProvider>(
              create: (context) => EventTicketProvider()),
        ],
        child: ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
          builder:  (_ , child){
            return MaterialApp(
                debugShowCheckedModeBanner: false,
                // theme: AppTheme.lightTheme,
                // darkTheme: AppTheme.darkTheme,
                onGenerateRoute: RouteGenerator.generateRoute,
                // initialRoute: SplashScreen.id,
                home:
                    // BookAdServiceScreen(
                    //   a_id: 3,
                    // )
                    WelcomeScreen()
                // EventListing() .
                );
          }
        ),
      ),
    );
  }
}

///Users/nikhil/Desktop/goffix_app/assets/images
