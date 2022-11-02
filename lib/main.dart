import 'dart:io';

import '../common_methods/check_app_update.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './provider/app_data.dart';
import './provider/address.dart';
import './provider/shop.dart';
import './provider/supports.dart';
import './provider/status.dart';
import './provider/appointments.dart';
import './provider/auth.dart';
import './provider/services.dart';
import './provider/customer.dart';
import './provider/templates.dart';

import './values/app_routes.dart';
import './values/app_colors.dart';

import './screens/account/add_edit_address_screen.dart';
import './screens/account/change_password_screen.dart';
import './screens/account/edit_profile_screen.dart';
import './screens/account/manage_address_screen.dart';
import './screens/account/my_account_screen.dart';
import './screens/appointments/appointment_details.dart';
import './screens/appointments/add_edit_appointment_screen.dart';
import './screens/customers/add_edit_customer_address_screen.dart';
import './screens/customers/manage_customer_address_screen.dart';
import './screens/customers/add_edit_customer_screen.dart';
import './screens/customers/customer_details.dart';
import './screens/shop/brand/add_edit_brand_screen.dart';
import './screens/shop/brand/brand_details.dart';
import './screens/shop/category/add_edit_category_screen.dart';
import './screens/shop/category/category_details.dart';
import './screens/shop/product/add_edit_product_screen.dart';
import './screens/shop/product/product_details.dart';
import './screens/shop/shop_tab_screen.dart';
import './screens/Login_and_forgotPassword/forget_password_screen.dart';
import './screens/Login_and_forgotPassword/new_password_screen.dart';
import './screens/Login_and_forgotPassword/otp_screen.dart';
import './screens/Login_and_forgotPassword/login_screen.dart';
import './screens/Login_and_forgotPassword/signup_screen.dart';
import './screens/Login_and_forgotPassword/supports_screen.dart';

import './screens/template/add_edit_template.dart';
import './screens/template/templates_screen.dart';
import './screens/services/service_details.dart';
import './screens/services/add_edit_service_screen.dart';
import './screens/loading_screen.dart';
import './screens/tab_screen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    updateCheck();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Appointments>(
          update: (ctx, auth, previousAppointments) => Appointments(
            auth.token,
            previousAppointments == null
                ? []
                : previousAppointments.allAppointments,
          ),
          create: (ctx) => Appointments(null, []),
        ),
        ChangeNotifierProxyProvider<Auth, Customers>(
          update: (ctx, auth, previousCustomers) => Customers(
            auth.token,
            previousCustomers == null ? [] : previousCustomers.allCustomers,
          ),
          // create: null,
          create: (ctx) => Customers(null, []),
        ),
        ChangeNotifierProxyProvider<Auth, Services>(
          update: (ctx, auth, previousServices) => Services(
            auth.token,
            previousServices == null ? [] : previousServices.services,
          ),
          // create: null,
          create: (ctx) => Services(null, []),
        ),
        ChangeNotifierProxyProvider<Auth, StatusList>(
          update: (ctx, auth, previousStatusList) => StatusList(
            auth.token,
            previousStatusList == null ? [] : previousStatusList.status,
          ),
          // create: null,
          create: (ctx) => StatusList(null, []),
        ),
        ChangeNotifierProxyProvider<Auth, AddressList>(
          update: (ctx, auth, previousAddressList) => AddressList(
            auth.token,
            previousAddressList == null ? [] : previousAddressList.addressList,
          ),
          // create: null,
          create: (ctx) => AddressList(null, []),
        ),
        ChangeNotifierProxyProvider<Auth, TemplateList>(
          update: ((ctx, auth, previousTemplateList) => TemplateList(
                auth.token,
                previousTemplateList == null
                    ? []
                    : previousTemplateList.allTemplates,
              )),
          create: (ctx) => TemplateList(null, []),
        ),
        ChangeNotifierProxyProvider<Auth, Shop>(
          update: (ctx, auth, _) => Shop(
            auth.token,
            // previousBrandList == null ? [] : previousBrandList.brandList,
          ),
          // create: null,
          create: (ctx) => Shop(null),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Supports(),
        ),
        ChangeNotifierProxyProvider<Auth, AppData>(
          update: (ctx, auth, _) => AppData(
            auth.token,
          ),
          create: (ctx) => AppData(null),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: dotenv.get('APP_TITLE'),
          theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
              },
            ),

            primaryColor: primaryColor,
            //  accentColor: PRIMARY_COLOR,
            // buttonColor: PRIMARY_COLOR,
            scaffoldBackgroundColor: backgroundColor,
            backgroundColor: backgroundColor,
            primarySwatch:
                MaterialColor(appColorSwatch[900]!.value, appColorSwatch),
            shadowColor: Colors.grey[300],
            // unselectedWidgetColor: LABEL_COLOR,

            //text color
            textTheme: const TextTheme(
              bodyText2: TextStyle(
                color: textColor,
              ), //page title
              // tile title
              subtitle1: TextStyle(
                color: textColor,
              ),
              //subtitle list view
              caption: TextStyle(
                // color: Colors.orange,

                color: subtitleColor,
              ),
            ),
            appBarTheme: const AppBarTheme(
              foregroundColor: appBarTitleColor,
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(
                  buttonTextColor,
                ),
              ),
            ),
            // elevatedButtonTheme:
            //     ElevatedButtonThemeData(style: raisedButtonStyle),
            // outlinedButtonTheme:
            //     OutlinedButtonThemeData(style: outlineButtonStyle),
          ),
          home: auth.isAuth
              ? const TabScreen()
              : FutureBuilder(
                  future: auth.autoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? const LoadingScreen()
                          : const LoginScreen(),
                ),
          routes: {
            APP_ROUTE_LOGIN: (ctx) => const LoginScreen(),
            APP_ROUTE_FORGOT_PASSWORD: (ctx) => const ForgetPasswordScreen(),
            APP_ROUTE_OTP_SCREEN: (ctx) => const OtpScreen(),
            APP_ROUTE_SUPPORT_SCREEN: (ctx) => const SupportsScren(),
            APP_ROUTE_NEW_PASSWORD_SCREEN: (ctx) => const NewPasswordScreen(),
            /*------------------------------------------------------------*/
            APP_ROUTE_APPOINTMENT_DETAIL: (ctx) => const AppointmentDetails(),
            APP_ROUTE_CUSTOMER_DETAIL: (ctx) => const CustomerDetails(),
            APP_ROUTE_SERVICE_DETAIL: (ctx) => const ServiceDetails(),
            APP_ROUTE_ADD_EDIT_CUSTOMER: (ctx) => const AddEditCustomerScreen(),
            APP_ROUTE_ADD_EDIT_SERVICE: (ctx) => const AddEditServiceScreen(),
            APP_ROUTE_ADD_EDIT_APPOINTMENT: (ctx) =>
                const AddEditAppointmentScreen(),
            APP_ROUTE_EDIT_PROFILE: (ctx) => const EditProfileScreen(),
            APP_ROUTE_CHANGE_PASSWORD: (ctx) => const ChangePasswordScreen(),
            APP_ROUTE_MANAGE_ADDRESS: (ctx) => const ManageAddressScreen(),
            APP_ROUTE_ADD_EDIT_ADDRESS: (ctx) => const AddEditAddressScreen(),
            APP_ROUTE_ADD_EDIT_CUSTOMER_ADDRESS: (ctx) =>
                const AddEditCustomerAddressScreen(),
            APP_ROUTE_MANAGE_CUSTOMER_ADDRESS: (ctx) =>
                const ManageCustomerAddressScreen(),
            APP_ROUTE_SHOP: (ctx) => const ShopTabScreen(),
            APP_ROUTE_TEMPLATES: (ctx) => const TemplatesScreen(),
            APP_ROUTE_ADD_EDIT_TEMPLATE_SCREEN: (context) =>
                const AddEditTemplateScreen(),
            APP_ROUTE_MY_ACCOUNT: (ctx) => const MyAccountScreen(),
            APP_ROUTE_ADD_EDIT_BRAND: (ctx) => const AddEditBrandScreen(),
            APP_ROUTE_BRAND_DETAIL: (ctx) => const BrandDetails(),
            APP_ROUTE_CATEGORY_DETAIL: (ctx) => const CategoryDetails(),
            APP_ROUTE_ADD_EDIT_CATEGORY: (ctx) => const AddEditCategoryScreen(),
            APP_ROUTE_ADD_EDIT_PRODUCT: (ctx) => const AddEditProductScreen(),
            APP_ROUTE_PRODUCT_DETAIL: (ctx) => const ProductDetails(),

            // ----------test path------
            SignupScreen.routeName: (ctx) => const SignupScreen(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
