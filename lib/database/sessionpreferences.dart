import 'package:shared_preferences/shared_preferences.dart';
import 'package:posapp/models/usermodels.dart';
import 'package:posapp/utils/config.dart';

class SessionPreferences {
  // final String _userId = 'userId';

  // final String _fullName = 'fullName';
  // final String _userName = 'userName';
  // final String _email = 'email';

  // final String _loggedIn = 'loggedIn';

  // final String _custId = 'financierEmail';
  // final String _custCode = 'financierEmail';
  // final String _company = 'financierEmail';
  // final String _priceList = 'financierEmail';
  // final String _custBalance = 'financierEmail';
  // final String _custAvailableCredit = 'custAvailableCredit';
  // final String _custCreditLimit = 'custCreditLimit';

  // final String _liveUrl = 'liveUrl';
  // final String _imageSelection = 'imageSelection';
  // final String _companyName = "_companyName";

  final String _userId = 'userId';
  final String _subscription = 'subscription';
  final String _custId = 'custId';
  final String _hrId = 'hrId';
  final String _fullName = 'fullName';
  final String _userName = 'userName';
  final String _memberno = 'memberno';
  final String _userPriceList = 'userPriceList';
  final String _active = 'active';
  final String _approved = 'approved';
  final String _email = 'email';
  final String _mobileno = 'mobileno';
  final String _branchName = 'branchname';
  final String _balance = 'balance';
  final String _availableCredit = 'availableCredit';
  final String _creditLimit = 'creditLimit';

  final String _loggedIn = 'loggedIn';

  final String _id = 'id';
  final String _name = 'company';
  final String _techId = 'empid';
  final String _techName = 'empname';
  final String _financierEmail = 'email';
  final String _mobile = 'mobile';

  final String _custCode = 'custcode';
  final String _company = 'company';
  final String _count = 'count';
  final String _priceList = 'pricelist';
  final String _invDescrip = 'invDescrip';
  final String _invQty = 'invQty';
  final String _invPrice = 'invPrice';
  final String _thermoPrint = 'thermoPrint';
  final String _btdAddress = 'btdAddress';
  final String _btdName = 'btdName';
  final String _custBalance = 'custBalance';
  final String _custAvailableCredit = 'custAvailableCredit';
  final String _custCreditLimit = 'custCreditLimit';
  final String _odInvCode = 'odInvCode';
  final String _odOriginalPrice = 'odOriginalPrice';
  final String _odInvDescrip = 'odInvDescrip';
  final String _odInvQty = 'odInvQty';
  final String _odInvPrice = 'odInvPrice';
  final String _odItemQty = 'odItemQty';
  final String _odInvDiscount = 'odInvDiscount';
  final String _odItemPrice = 'odItemPrice';
  final String _idInvId = 'idInvId';
  final String _idOriginalPrice = 'idOriginalPrice';
  final String _idItemDesc = 'idItemDesc';
  final String _idVat = 'idVat';
  final String _idDiscount = 'idDiscount';
  final String _idQtySold = 'idQtySold';
  final String _idTotal = 'idTotal';
  final String _pdamount = 'pdamount';
  final String _idRprice = 'idRprice';
  final String _idItemQty = 'idItemQty';
  final String _mrdInvid = 'mrdInvid';
  final String _mrdDesc = 'mrdDesc';
  final String _mrdQty = 'mrdQty';
  final String _mrdItemQty = 'mrdItemQty';
  final String _mrdTotal = 'mrdTotal';
  final String _mrdRprice = 'mrdRprice';
  final String _liveUrl = 'liveUrl';
  final String _imageSelection = 'imageSelection';
  final String _paybillno = "paybillno";
  final String _cashacc = "cashacc";
  final String _cashaccid = "cashaccid";
  final String _pinno = "pinno";
  final String _city = "city";
  final String _address = "address";
  final String _changePrice = "changePrice";
  final String _paymentMode = "paymentMode";
  final String _apiCustomer = "_apiCustomer";
  final String _apiNewCustomer = "_apiNewCustomer";
  final String _companyName = "_companyName";
  Future<void> setCompanySettings(CompanySettings settings) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(_liveUrl, settings.baseUrl!);
    sharedPreferences.setString(_imageSelection, settings.imageName!);
  }

  Future<void> setLoggedInUser(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(_userId, user.id!);
    // sharedPreferences.setInt(_subscription, user.subscription!);
    sharedPreferences.setInt(_hrId, user.hrid!);

    // sharedPreferences.setString(_email, user.email!);
    // sharedPreferences.setString(_mobileno, user.mobileno!);
    // sharedPreferences.setString(_branchName, user.branchname!);
    // // sharedPreferences.setn(_custBalance, user.balance!);
    // sharedPreferences.setString(_fullName, user.fullname!);
    // sharedPreferences.setString(_userName, user.username!);
    // // sharedPreferences.setString(_memberno, user.memberno!);
    // sharedPreferences.setString(_companyName, user.companyname!);
  }

  Future<User> getLoggedInUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return User(
        id: sharedPreferences.getInt(_userId),
        hrid: sharedPreferences.getInt(_hrId),
        // fullname: sharedPreferences.getString(_fullName),
        // username: sharedPreferences.getString(_userName),
        // mobileno: sharedPreferences.getString(_mobileno),
        // // subscription: sharedPreferences.getInt(_subscription),
        // email: sharedPreferences.getString(_email),
        // // custid: sharedPreferences.getInt(_custId),
        // // balance: sharedPreferences.getInt(_custBalance),
        // // memberno: sharedPreferences.getString(_memberno),
        // companyname: sharedPreferences.getString(_companyName)
    );
  }

  Future<CompanySettings> getCompanySettings() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return CompanySettings(
        baseUrl: sharedPreferences.getString(_liveUrl),
        imageName: sharedPreferences.getString(_imageSelection));
  }

  void setLoggedInStatus(bool loggedIn) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool(_loggedIn, loggedIn);
  }

  Future<bool?> getLoggedInStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(_loggedIn);
  }
}
