import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ismmart_dubai_pos/helper/constants.dart';
import 'package:ismmart_dubai_pos/helper/urls.dart';
import 'errors.dart';

class ApiBaseHelper {
  String customApiToken = GetStorage().read('token') ?? "";
  Future<dynamic> postMethod({
    required String url,
    Object? body,
    bool withBearer = false,
    bool withAuthorization = false,
  }) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'X-Shopify-Access-Token': Urls.token
      };
      if (body != null) {
        body = jsonEncode(body);
      }
      Uri urlValue = Uri.parse(Urls.baseUrl + url);
      print('*********************** Request ********************************');
      print(urlValue);
      print(body);

      http.Response response = await http
          .post(urlValue, headers: header, body: body)
          .timeout(Duration(seconds: 30));

      print(
          '*********************** Response ********************************');
      print(urlValue);
      print(response.body);

      Map<String, dynamic> parsedJSON = jsonDecode(response.body);
      return parsedJSON;
    } on SocketException catch (_) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.noInternetError);
    } on TimeoutException catch (_) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.timeOutException);
      throw Errors.timeOutException;
    } on FormatException catch (_) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.formatException);
      throw Errors.formatException;
    } catch (e) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.generalApiError);
      throw e.toString();
    }
  }

  Future<dynamic> putMethod({
    required String url,
    Object? body,
    bool withBearer = false,
    bool withAuthorization = false,
  }) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'X-Shopify-Access-Token': Urls.token
      };
      if (body != null) {
        body = jsonEncode(body);
      }
      Uri urlValue = Uri.parse(Urls.baseUrl + url);
      // print('*********************** Request ********************************');
      // print(urlValue);
      // print(body);

      http.Response response = await http
          .put(urlValue, headers: header, body: body)
          .timeout(Duration(seconds: 30));

      // print(
      //     '*********************** Response ********************************');
      // print(urlValue);
      // print(response.body);

      Map<String, dynamic> parsedJSON = jsonDecode(response.body);
      return parsedJSON;
    } on SocketException catch (_) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.noInternetError);
    } on TimeoutException catch (_) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.timeOutException);
      throw Errors.timeOutException;
    } on FormatException catch (_) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.formatException);
      throw Errors.formatException;
    } catch (e) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.generalApiError);
      throw e.toString();
    }
  }

  // Future<dynamic> putMethod({
  //   required String url,
  //   Object? body,
  //   bool withBearer = false,
  //   bool withAuthorization = false,
  // }) async {
  //   try {
  //     Map<String, String> header = {'Content-Type': 'application/json'};
  //     if (withAuthorization) {
  //       header['Authorization'] = withBearer ? 'Bearer ${GlobalVariables.token}' : GlobalVariables.token.toString();
  //     }
  //     if (body != null) {
  //       body = jsonEncode(body);
  //     }
  //     Uri urlValue = Uri.parse(Urls.baseURL + url);
  //     print('*********************** Request ********************************');
  //     print(urlValue);
  //     print(body);
  //
  //     http.Response response = await http
  //         .put(urlValue, headers: header, body: body)
  //         .timeout(Duration(seconds: 30));
  //
  //     print(
  //         '*********************** Response ********************************');
  //     print(urlValue);
  //     print(response.body);
  //
  //     Map<String, dynamic> parsedJSON = jsonDecode(response.body);
  //     return parsedJSON;
  //   } on SocketException catch (_) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.noInternetError);
  //     throw Errors.noInternetError;
  //   } on TimeoutException catch (_) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.timeOutException);
  //     throw Errors.timeOutException;
  //   } on FormatException catch (_) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.formatException);
  //     throw Errors.formatException;
  //   } catch (e) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.generalApiError);
  //     throw e.toString();
  //   }
  // }

  // Future<dynamic> patchMethod({
  //   required String url,
  //   Object? body,
  //   bool withBearer = false,
  //   bool withAuthorization = false,
  // }) async {
  //   try {
  //     Map<String, String> header = {'Content-Type': 'application/json'};
  //     if (withAuthorization) {
  //       header['Authorization'] = withBearer ? 'Bearer ${GlobalVariables.token}' : GlobalVariables.token.toString();
  //     }
  //     if (body != null) {
  //       body = jsonEncode(body);
  //     }
  //     Uri urlValue = Uri.parse(Urls.baseURL + url);
  //     print('*********************** Request ********************************');
  //     print(urlValue);
  //     print(body);
  //
  //     http.Response response = await http
  //         .patch(urlValue, headers: header, body: body)
  //         .timeout(Duration(seconds: 30));
  //
  //     print(
  //         '*********************** Response ********************************');
  //     print(urlValue);
  //     print(response.body);
  //
  //     Map<String, dynamic> parsedJSON = jsonDecode(response.body);
  //     return parsedJSON;
  //   } on SocketException catch (_) {
  //     GlobalVariables.showLoader.value = false;
  //      AppConstant.displaySnackBar('Errors', Errors.noInternetError);
  //      throw Errors.noInternetError;
  //   } on TimeoutException catch (_) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.timeOutException);
  //     throw Errors.timeOutException;
  //   } on FormatException catch (_) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.formatException);
  //     throw Errors.formatException;
  //   } catch (e) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.generalApiError);
  //     throw e.toString();
  //   }
  // }

  Future<dynamic> getMethod({
    required String url,
    bool withBearer = false,
    bool withAuthorization = false,
  }) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json',
        'X-Shopify-Access-Token': Urls.token
      };
/////
      Uri urlValue = Uri.parse(Urls.baseUrl + url);
      print('*********************** Request ********************************');
      print(urlValue);

      http.Response response = await http
          .get(urlValue, headers: header)
          .timeout(const Duration(seconds: 50));

      print(
          '*********************** Response ********************************');
      print(urlValue);
      print(response.body);

      Map<String, dynamic> parsedJSON = jsonDecode(response.body);
      return parsedJSON;
    } on SocketException {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.noInternetError);
      throw Errors.noInternetError;
    } on TimeoutException {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.timeOutException);
      throw Errors.timeOutException + url;
    } catch (e) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', e.toString());
      throw e.toString();
    }
  }

  Future<dynamic> getMethodFrmCustomApi({
    required String url,
    bool withBearer = false,
    bool withAuthorization = false,
  }) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json',
      };
      String customApiToken = GetStorage().read('token');
      if (withAuthorization) {
        header['Authorization'] =
            withBearer ? 'Bearer $customApiToken' : customApiToken;
      }
      Uri urlValue = Uri.parse(Urls.liveCustomBaseUrl + url);
      print('*********************** Request ********************************');
      print(urlValue);

      http.Response response = await http
          .get(urlValue, headers: header)
          .timeout(Duration(seconds: 50));

      print(
          '*********************** Response ********************************');
      print(urlValue);
      print(response.body);

      Map<String, dynamic> parsedJSON = jsonDecode(response.body);
      return parsedJSON;
    } on SocketException {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.noInternetError);
      throw Errors.noInternetError;
    } on TimeoutException {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.timeOutException);
      throw Errors.timeOutException + url;
    } catch (e) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', e.toString());
      throw e.toString();
    }
  }

  //Custom POST Method-------

  Future<dynamic> customPostMethod({
    required String url,
    Object? body,
    bool withBearer = false,
    bool withAuthorization = false,
  }) async {
    try {
      Map<String, String> header = {
        'Content-Type': 'application/json',
      };
      if (body != null) {
        body = jsonEncode(body);
      }
      // String customApiToken = GetStorage().read('token');
      // if (withAuthorization) {
      //   header['authorization'] =
      //       withBearer ? 'Bearer $customApiToken' : customApiToken;
      // }

      Uri urlValue = Uri.parse(Urls.liveCustomBaseUrl + url);
      // print('*********************** Request ********************************');
      // print(urlValue);

      // print(body);

      http.Response response = await http
          .post(urlValue, headers: header, body: body)
          .timeout(Duration(seconds: 30));

      // print(
      //     '*********************** Response ********************************');
      // print(urlValue);
      // print(response.body);

      Map<String, dynamic> parsedJSON = jsonDecode(response.body);
      return parsedJSON;
    } on SocketException catch (_) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.noInternetError);
    } on TimeoutException catch (_) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.timeOutException);
      throw Errors.timeOutException;
    } on FormatException catch (_) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.formatException);
      throw Errors.formatException;
    } catch (e) {
      // GlobalVariables.showLoader.value = false;
      AppConstants.displaySnackBar('Error', Errors.generalApiError);
      throw e.toString();
    }
  }

  // Future<dynamic> deleteMethod({
  //   required String url,
  //   bool withBearer = false,
  //   bool withAuthorization = false,
  // }) async {
  //   try {
  //     Map<String, String> header = {'Content-Type': 'application/json'};
  //     if (withAuthorization) {
  //       header['Authorization'] = withBearer ? 'Bearer ${GlobalVariables.token}' : GlobalVariables.token.toString();
  //     }
  //     Uri urlValue = Uri.parse(Urls.baseURL + url);
  //     print('*********************** Request ********************************');
  //     print(urlValue);
  //
  //     http.Response response = await http
  //         .delete(urlValue, headers: header)
  //         .timeout(Duration(seconds: 50));
  //
  //     print(
  //         '*********************** Response ********************************');
  //     print(urlValue);
  //     print(response.body);
  //
  //     Map<String, dynamic> parsedJSON = jsonDecode(response.body);
  //     return parsedJSON;
  //   } on SocketException {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.noInternetError);
  //     throw Errors.noInternetError;
  //   } on TimeoutException {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.timeOutException);
  //     throw Errors.timeOutException + url;
  //   } catch (e) {
  //     GlobalVariables.showLoader.value = false;
  //     print(e);
  //     AppConstant.displaySnackBar('Error', e.toString());
  //     throw e.toString();
  //   }
  // }

  // Future<dynamic> postMethodForImage({
  //   required String url,
  //   required List<http.MultipartFile> files,
  //   required Map<String, String> fields,
  //   bool withBearer = false,
  //   bool withAuthorization = false,
  // }) async {
  //   try {
  //     Map<String, String> header = {'Content-Type': 'multipart/form-data'};
  //     if (withAuthorization) {
  //       header['Authorization'] = withBearer ? 'Bearer ${GlobalVariables.token}' : GlobalVariables.token.toString();
  //     }
  //     Uri urlValue = Uri.parse(Urls.baseURL + url);
  //     print('*********************** Request ********************************');
  //     print(urlValue);
  //
  //     http.MultipartRequest request = http.MultipartRequest('POST', urlValue);
  //     request.headers.addAll(header);
  //     request.fields.addAll(fields);
  //     request.files.addAll(files);
  //     http.StreamedResponse response = await request.send();
  //     Map<String, dynamic> parsedJson =
  //     await jsonDecode(await response.stream.bytesToString());
  //
  //     print(
  //         '*********************** Response ********************************');
  //     print(urlValue);
  //     print(parsedJson.toString());
  //     return parsedJson;
  //   } on SocketException catch (_) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.noInternetError);
  //     throw Errors.noInternetError;
  //   } on TimeoutException catch (_) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.timeOutException);
  //     throw Errors.timeOutException;
  //   } on FormatException catch (_) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.formatException);
  //     throw Errors.formatException;
  //   } catch (e) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.generalApiError);
  //     throw e.toString();
  //   }
  // }
  //
  // Future<dynamic> patchMethodForImage({
  //   required String url,
  //   required List<http.MultipartFile> files,
  //   required Map<String, String> fields,
  //   bool withBearer = false,
  //   bool withAuthorization = false,
  // }) async {
  //   try {
  //     Map<String, String> header = {'Content-Type': 'multipart/form-data'};
  //
  //     if (withAuthorization) {
  //       header['Authorization'] = withBearer ? 'Bearer ${GlobalVariables.token}' : GlobalVariables.token.toString();
  //     }
  //     Uri urlValue = Uri.parse(Urls.baseURL + url);
  //     print('*********************** Request ********************************');
  //     print(urlValue);
  //
  //     http.MultipartRequest request = http.MultipartRequest('PATCH', urlValue);
  //
  //     request.headers.addAll(header);
  //     request.fields.addAll(fields);
  //     request.files.addAll(files);
  //     http.StreamedResponse response = await request.send();
  //     Map<String, dynamic> parsedJson =
  //     await jsonDecode(await response.stream.bytesToString());
  //
  //     print(
  //         '*********************** Response ********************************');
  //     print(urlValue);
  //     print(parsedJson.toString());
  //     return parsedJson;
  //   } on SocketException catch (_) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.noInternetError);
  //     throw Errors.noInternetError;
  //   } on TimeoutException catch (_) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.timeOutException);
  //     throw Errors.timeOutException;
  //   } on FormatException catch (_) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.formatException);
  //     throw Errors.formatException;
  //   } catch (e) {
  //     GlobalVariables.showLoader.value = false;
  //     AppConstant.displaySnackBar('Error', Errors.generalApiError);
  //     throw e.toString();
  //   }
//  }
}
