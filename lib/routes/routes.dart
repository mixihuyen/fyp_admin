class TRoutes {
  static const home = '/';
  static const responsiveDesign = '/responsiveDesign';
  static const login = '/login';
  static const forgetPassword = '/forget-password/';
  static const resetPassword = '/reset-password';
  static const station = '/station';
  static const province = '/province';
  static const trip = '/trip';
  static const booking = '/booking';
  static const categories = '/categories';
  static const userManagement= '/userManagement';
  static const customer = '/customer';
  static const createCustomer = '/createCustomer';

  static List sideBarMenuItems = [
    trip,
    station,
    categories,
    province,
    userManagement,
  ];

}