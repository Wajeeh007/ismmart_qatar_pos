import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:window_manager/window_manager.dart';
import '../../helper/api_base_helper.dart';
import '../../helper/constants.dart';
import '../../helper/global_variables.dart';
import '../../helper/theme_helper.dart';
import '../../helper/urls.dart';
import '../../models/cart_model.dart';
import '../../models/inventory_item_model.dart';
import '../../models/order.dart';
import '../../models/product_model.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_textfield.dart';

class HomeViewModel extends GetxController with WindowListener {
  String invoiceNumber = '';
  RxInt productQuantity = 1.obs;
  RxList<String> productVariantStrings = <String>[].obs;
  RxString productVariant = ''.obs;
  RxBool isCashPayment = false.obs;
  RxList<ProductItem> productsToShow = <ProductItem>[].obs;
  RxList<ProductItem> allProducts = <ProductItem>[].obs;
  RxList<CartModel> productsInCart = <CartModel>[].obs;
  RxString productSKU = ''.obs;
  Rx<CartModel> productToAdd = CartModel().obs;
  RxInt locationId = 0.obs;
  RxList<InventoryLevels> inventoryLevels = <InventoryLevels>[].obs;
  RxDouble cartSubTotal = 0.0.obs;
  RxDouble cartTax = 0.0.obs;
  RxInt customerPhone = 0.obs;
  RxString customerFirstName = ''.obs;
  RxString customerLastName = ''.obs;
  RxString customerEmail = ''.obs;
  RxDouble cartTotal = 0.0.obs;
  int variantIndexForBarcode = -1;
  RxList<String> statusListt = <String>[].obs;
  RxInt orderIdFrmShpfy = 0.obs;
  RxBool showLoader = false.obs;
  TextEditingController cashInHandController = TextEditingController();
  TextEditingController searchTextController = TextEditingController();
  TextEditingController cashReceivedController = TextEditingController();
  FocusNode focusNode = FocusNode();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> cashInHandFormKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  RxInt productAvailableStock = 0.obs;
  RxInt paymentChange = 0.obs;
  RxInt payment = 0.obs;
  late pw.MemoryImage qrImage;
  late pw.Font arabic;
  late pw.Font arabicBold;

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      showDialog(
        context: Get.context!,
        builder: (_) {
          return AlertDialog(
            title: const Text('Are you sure you want to close this window?'),
            actions: [
              TextButton(
                child: const Text('No'),
                onPressed: () {
                  Navigator.of(Get.context!).pop();
                },
              ),
              TextButton(
                child: const Text('Yes'),
                onPressed: () async {
                  Navigator.of(Get.context!).pop();
                  await windowManager.destroy();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void onInit() {
    windowManager.addListener(this);
    _init();
    super.onInit();
  }

  @override
  void onReady() {
    cashInHandDialog();
    super.onReady();
  }

  @override
  void onClose() {
    windowManager.removeListener(this);
    super.onClose();
  }

  void _init() async {
    // Add this line to override the default close handler
    await windowManager.setPreventClose(true);

    arabic =
        pw.Font.ttf(await rootBundle.load("assets/fonts/arabic-Regular.ttf"));
    arabicBold =
        pw.Font.ttf(await rootBundle.load("assets/fonts/arabic-Bold.ttf"));

    getProducts();
  }

  getProducts() {
    showLoader.value = true;
    ApiBaseHelper()
        .getMethodFrmCustomApi(
            url:
                'pos/products?sort=product[created_at][1]&location=${GlobalVariables.locationId.value}&fields[title]=1&fields[variants][barcode]&fields[id]=1&fields[variants][sku]=1&fields[variants][price]=1&fields[variants][title]=1&fields[variants][inventory_item_id]=1&fields[variants][inventory_quantity]=1&fields[options][name]=1&fields[options][values]=1&fields[image][src]=1&fields[variants][product_id]=1&fields[variants][id]=1&limit=0')
        .then((parsedJson) {
      if (parsedJson['success'] == true) {
        final products = parsedJson['data']['items'] as List;
        allProducts.addAll(products.map((e) => ProductItem.fromJson(e)));
        productsToShow.addAll(products.map((e) => ProductItem.fromJson(e)));
        showLoader.value = false;
      }
    }).catchError((e) {
      print('Error in Get Products: $e');
    });
  }

  quantityIncrement(int index) {
    if (productVariant.value == '') {
      if (productVariantStrings.isNotEmpty) {
        productVariantStrings.forEach((element) {
          if (element == productVariantStrings.first) {
            productVariant.value = element;
          } else {
            productVariant.value = "${productVariant.value} / $element";
          }
          if (element == productVariantStrings.last) {
            int variantIndex = allProducts[index]
                .product!
                .variants!
                .indexWhere((p0) => p0.title == productVariant.value);
            if (allProducts[index]
                    .product!
                    .variants![variantIndex]
                    .inventoryQuantity! >
                productQuantity.value) {
              productQuantity.value++;
            }
          }
        });
      } else {
        if (allProducts[index].product!.variants![0].inventoryQuantity! >
            productQuantity.value) {
          productQuantity.value++;
        } else {
          AppConstants.displaySnackBar(
              'Error', 'No more stock available in inventory');
        }
      }
    } else {
      int variantIndex = allProducts[index]
          .product!
          .variants!
          .indexWhere((p0) => p0.title == productVariant.value);
      if (allProducts[index]
              .product!
              .variants![variantIndex]
              .inventoryQuantity! >
          productQuantity.value) {
        productQuantity.value++;
      } else {
        AppConstants.displaySnackBar(
            'Error', 'No more stock available in inventory');
      }
    }
  }

  quantityIncrementFrmCart(int index) {
    if (productsInCart[index].quantity! <
        productsInCart[index].quantityInStock!) {
      productsInCart[index].quantity = productsInCart[index].quantity! + 1;
      productsInCart.refresh();
      calculatePrice(
          index: index,
          tax: 0,
          price: productsInCart[index].price!,
          add: true);
    } else {
      AppConstants.displaySnackBar(
          'Error', 'No more stock available in inventory');
    }
    productsInCart.refresh();
  }

  quantityDecrement() {
    if (productQuantity.value > 1) {
      productQuantity.value--;
    } else {
      return;
    }
  }

  calculatePrice(
      {required double? tax,
      int? quantity,
      required int index,
      required double price,
      required bool add}) {
    if (add) {
      if (quantity == null) {
        String subTotal =
            (cartSubTotal.value + productsInCart[index].price!)
                .toStringAsFixed(2);
        cartSubTotal.value = double.parse(subTotal);
        String tax = (productsInCart[index].price! -
                productsInCart[index].price!)
            .toStringAsFixed(0);
        cartTax.value += double.parse(tax);
        cartTotal.value = cartSubTotal.value + cartTax.value;
      } else {
        String subTotal = (cartSubTotal.value +
                productsInCart[index].price! * quantity)
            .toStringAsFixed(2);
        cartSubTotal.value = double.parse(subTotal);
        String tax = ((productsInCart[index].price! -
                    productsInCart[index].price!) *
                quantity)
            .toStringAsFixed(0);
        cartTax.value += double.parse(tax);
        cartTotal.value = cartSubTotal.value + cartTax.value;
      }
    } else {
      if (cartTotal.value == 0.0) {
        return;
      } else {
        if (quantity == null) {
          String subTotal =
              (cartSubTotal.value - productsInCart[index].price!)
                  .toStringAsFixed(2);
          cartSubTotal.value = double.parse(subTotal);
          String tax = (productsInCart[index].price! -
                  productsInCart[index].price!)
              .toStringAsFixed(0);
          cartTax.value -= double.parse(tax);
          cartTotal.value = cartSubTotal.value + cartTax.value;
        } else {
          String subTotal = (cartSubTotal.value -
                  productsInCart[index].price! * quantity)
              .toStringAsFixed(2);
          cartSubTotal.value = double.parse(subTotal);
          String tax = ((productsInCart[index].price! -
                      productsInCart[index].price!) *
                  quantity)
              .toStringAsFixed(0);
          cartTax.value -= double.parse(tax);
          cartTotal.value = cartSubTotal.value + cartTax.value;
        }
      }
    }
  }

  addToCart(int index) {
    productToAdd.value.name = allProducts[index].product?.title;
    productToAdd.value.imageSrc = allProducts[index].product?.image?.src;
    productToAdd.value.productId = allProducts[index].product?.id;
    productToAdd.value.quantity = productQuantity.value;
    if (productVariant.value == '') {
      if (productVariantStrings.isNotEmpty) {
        for (var element in productVariantStrings) {
          if (element == productVariantStrings.first) {
            productVariant.value = element;
          } else {
            productVariant.value = "${productVariant.value} / $element";
          }
          if (element == productVariantStrings.last) {
            int variantIndex = allProducts[index]
                .product!
                .variants!
                .indexWhere((p0) => p0.title == productVariant.value);
            productToAdd.value.variantId =
                allProducts[index].product!.variants![variantIndex].id;
            productToAdd.value.quantityInStock = allProducts[index]
                .product!
                .variants![variantIndex]
                .inventoryQuantity;
            productToAdd.value.variantTitle =
                allProducts[index].product!.variants![variantIndex].title;
            // productToAdd.value.price = allProducts[index]
            //     .product!
            //     .variants![variantIndex]
            //     .priceWithoutTax!;
            productToAdd.value.price = allProducts[index]
                .product!
                .variants![variantIndex]
                .price;
            // productToAdd.value.productTax = allProducts[index]
            //         .product!
            //         .variants![variantIndex]
            //         .price! -
            //     allProducts[index]
            //         .product!
            //         .variants![variantIndex]
            //         .priceWithoutTax!;
            productToAdd.value.inventoryItemId = allProducts[index]
                .product!
                .variants![variantIndex]
                .inventoryItemId;
            productToAdd.value.taxLines = <TaxLines>[
              // TaxLines(
              //     title: 'VAT',
              //     price: productToAdd.value.productTax?.toStringAsFixed(2),
              //     rate: 0.05)
            ];
            productToAdd.value.properties = <Properties>[
              Properties(name: 'Inventory Item ID', value: allProducts[index].product!.variants![variantIndex].inventoryItemId)
            ];
            int checkProductIndex = productsInCart.indexWhere(
                (element) => element.variantId == productToAdd.value.variantId);
            if (checkProductIndex == -1) {
              productsInCart.add(productToAdd.value);
              calculatePrice(
                  add: true,
                  price: productToAdd.value.price!,
                  quantity: productToAdd.value.quantity,
                  index: productsInCart.length - 1,
                  tax: 0);
              productSKU.value = '';
              productVariant.value = '';
              productQuantity.value = 1;
              productVariantStrings.value = [];
              productToAdd.value = CartModel();
              productsInCart.refresh();
              Get.back();
            } else {
              if (productsInCart[checkProductIndex].quantity! +
                      productToAdd.value.quantity! <
                  allProducts[index]
                      .product!
                      .variants![variantIndex]
                      .inventoryQuantity!) {
                productsInCart[checkProductIndex].quantity =
                    productsInCart[checkProductIndex].quantity! +
                        productToAdd.value.quantity!;
                calculatePrice(
                    add: true,
                    tax: 0,
                    price: productToAdd.value.price!,
                    index: checkProductIndex,
                    quantity: productToAdd.value.quantity);
                productSKU.value = '';
                productVariant.value = '';
                productQuantity.value = 1;
                productVariantStrings.value = [];
                productToAdd.value = CartModel();
                productsInCart.refresh();
                Get.back();
              } else {
                AppConstants.displaySnackBar('Error',
                    'Product already exists in cart and additional quantity exceeds stock in inventory');
              }
            }
          }
        }
      } else {
        productToAdd.value.variantTitle =
            allProducts[index].product!.variants?[0].title;
        productToAdd.value.variantId =
            allProducts[index].product!.variants?[0].id;
        productToAdd.value.quantityInStock =
            allProducts[index].product!.variants![0].inventoryQuantity;
        productToAdd.value.price =
            allProducts[index].product!.variants![0].price;
        // productToAdd.value.priceWithoutTax =
        //     allProducts[index].product!.variants![0].priceWithoutTax!;
        // productToAdd.value.productTax =
        //     allProducts[index].product!.variants![0].price! -
        //         allProducts[index].product!.variants![0].priceWithoutTax!;
        productToAdd.value.inventoryItemId =
            allProducts[index].product!.variants![0].inventoryItemId;
        productToAdd.value.taxLines = <TaxLines>[
          // TaxLines(
          //     title: 'VAT',
          //     price: productToAdd.value.productTax?.toStringAsFixed(2),
          //     rate: 0.05)
        ];
        productToAdd.value.properties = <Properties>[
          Properties(name: 'Inventory Item ID', value: allProducts[index].product!.variants![0].inventoryItemId)
        ];
        int checkProductIndex = productsInCart.indexWhere(
            (element) => element.variantId == productToAdd.value.variantId);
        if (checkProductIndex == -1) {
          productsInCart.add(productToAdd.value);
          calculatePrice(
              add: true,
              tax: 0,
              price: productToAdd.value.price!,
              quantity: productToAdd.value.quantity,
              index: productsInCart.length - 1);
          productSKU.value = '';
          productVariant.value = '';
          productQuantity.value = 1;
          productVariantStrings.value = [];
          productToAdd.value = CartModel();
          productsInCart.refresh();
          Get.back();
        } else {
          if (productsInCart[checkProductIndex].quantity! +
                  productToAdd.value.quantity! <
              allProducts[index]
                  .product!
                  .variants![0]
                  .inventoryQuantity!) {
            productsInCart[checkProductIndex].quantity =
                productsInCart[checkProductIndex].quantity! +
                    productToAdd.value.quantity!;
            calculatePrice(
                add: true,
                tax: 0,
                price: productToAdd.value.price!,
                index: checkProductIndex,
                quantity: productToAdd.value.quantity);
            productSKU.value = '';
            productVariant.value = '';
            productQuantity.value = 1;
            productVariantStrings.value = [];
            productToAdd.value = CartModel();
            productsInCart.refresh();
            Get.back();
          } else {
            AppConstants.displaySnackBar('Error',
                'Product already exists in cart and additional quantity exceeds stock in inventory');
          }
        }
      }
    } else {
      int variantIndex = allProducts[index]
          .product!
          .variants!
          .indexWhere((p0) => p0.title == productVariant.value);
      productToAdd.value.variantId =
          allProducts[index].product!.variants?[variantIndex].id;
      productToAdd.value.variantTitle =
          allProducts[index].product!.variants?[variantIndex].title;
      productToAdd.value.quantityInStock = allProducts[index]
          .product!
          .variants![variantIndex]
          .inventoryQuantity;
      // productToAdd.value.priceWithoutTax = allProducts[index]
      //     .product!
      //     .variants![variantIndex]
      //     .priceWithoutTax!;
      // productToAdd.value.productTax = allProducts[index]
      //         .product!
      //         .variants![variantIndex]
      //         .price! -
      //     allProducts[index]
      //         .product!
      //         .variants![variantIndex]
      //         .priceWithoutTax!;
      productToAdd.value.price =
          allProducts[index].product!.variants![variantIndex].price;
      productToAdd.value.inventoryItemId = allProducts[index]
          .product!
          .variants![variantIndex]
          .inventoryItemId;
      productToAdd.value.taxLines = <TaxLines>[
        // TaxLines(
        //     title: 'VAT',
        //     price: productToAdd.value.productTax?.toStringAsFixed(2),
        //     rate: 0.05)
      ];
      productToAdd.value.properties = <Properties>[
        Properties(name: 'Inventory Item ID', value: allProducts[index].product!.variants![variantIndex].inventoryItemId)
      ];
      int checkProductIndex = productsInCart.indexWhere(
          (element) => element.variantId == productToAdd.value.variantId);
      if (checkProductIndex == -1) {
        productsInCart.add(productToAdd.value);
        calculatePrice(
            add: true,
            tax: 0,
            index: productsInCart.length - 1,
            price: productToAdd.value.price!,
            quantity: productToAdd.value.quantity);
        productSKU.value = '';
        productVariant.value = '';
        productQuantity.value = 1;
        productVariantStrings.value = [];
        productToAdd.value = CartModel();
        productsInCart.refresh();
        Get.back();
      } else {
        if (productsInCart[checkProductIndex].quantity! +
                productToAdd.value.quantity! <
            allProducts[index]
                .product!
                .variants![variantIndex]
                .inventoryQuantity!) {
          productsInCart[checkProductIndex].quantity =
              productsInCart[checkProductIndex].quantity! +
                  productToAdd.value.quantity!;
          calculatePrice(
              add: true,
              tax: 0,
              price: productToAdd.value.price!,
              index: checkProductIndex,
              quantity: productToAdd.value.quantity);
          productSKU.value = '';
          productVariant.value = '';
          productQuantity.value = 1;
          productVariantStrings.value = [];
          productToAdd.value = CartModel();
          productsInCart.refresh();
          Get.back();
        } else {
          AppConstants.displaySnackBar('Error',
              'Product already exists in cart and additional quantity exceeds stock in inventory');
        }
      }
    }
  }

  removeItemFrmCart(int index) {
    calculatePrice(
        index: index,
        tax: 0,
        price: productsInCart[index].price!,
        add: false,
        quantity: productsInCart[index].quantity);
    productsInCart.remove(productsInCart[index]);
  }

  placeOrder() {
    GlobalVariables.showLoader.value = true;
    List orderItemsList = [];
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    final String formatted = formatter.format(now);
    for (var i in productsInCart) {
      orderItemsList.add(i.toJson());
    }

    Map<String, dynamic> param = {
      "order": {
        "taxes_included": true,
        "location_id": GlobalVariables.locationId.value,
        "current_subtotal_price": cartSubTotal.value,
        "current_total_price": cartTotal.value,
        // "current_total_tax": cartTax.value,
        "email": emailController.text != ""
            ? emailController.text
            : "empty@gmail.com",
        "currency": "QAR",
        "phone":
            "+974${phoneController.text == "" ? "55446611" : phoneController.text}",
        "send_fulfillment_receipt": true,
        "send_receipt": true,
        "fulfillment_status": "fulfilled",
        "created_at": formatted, //btw it been calculated by default.
        "fulfillments": [
          {
            "location_id": GlobalVariables.locationId.value,
            "line_items": orderItemsList
          }
        ],
        "line_items": orderItemsList,
        "customer": {
          "first_name": firstNameController.text != ""
              ? firstNameController.text
              : "empty",
          "last_name":
              lastNameController.text != "" ? lastNameController.text : "empty",
          "email": emailController.text != ""
              ? emailController.text
              : "empty@gmail.com",
          // "phone"
        },
        "transactions": [
          {"kind": "sale", "status": "success", "amount": cartTotal.value}
        ],
        "inventory_behaviour": "decrement_obeying_policy",
        "financial_status": "paid",
        "note": isCashPayment.value ? 1 : 2,
      }
    };

    ApiBaseHelper()
        .postMethod(url: Urls.createOrder, body: param)
        .then((parsedJson) async {
      GlobalVariables.showLoader.value = false;

      if (parsedJson['order'] != null) {
        Get.back();
        orderIdFrmShpfy.value = parsedJson['order']['id'];
        AppConstants.displaySnackBar("Success", 'Order Confirmed Successfully');
        await invoiceData();
        cartTotal.value = 0.0;
        cartTax.value = 0;
        cartSubTotal.value = 0.0;
        productQuantity.value = 0;
        productSKU.value = '';
      } else {
        GlobalVariables.showLoader.value = false;
        AppConstants.displaySnackBar(
          'Error',
          'Order couldn\'t be placed. Try Again.',
        );
      }
    }).catchError((e) {
      AppConstants.displaySnackBar(
        'Error',
        e,
      );
      GlobalVariables.showLoader.value = false;
    });
  }

  Future<void> invoiceData() async {
    var allProductQuantity = 0.0;
    var grandVAT = 0.0;
    var grandTotal = 0.0;
    var grandSaleValue = 0.0;

    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss');
    final String formatted = formatter.format(now);

    List<Map<String, dynamic>> items = [];
    for (var i in productsInCart) {
      // var itemSalePrice = i.price! * i.quantity!;
      // var itemVat = (i.price! * i.quantity!) * 0.05;
      var itemTotal = i.price! * i.quantity!;
      // grandVAT += itemVat;
      grandTotal += itemTotal;
      // grandSaleValue += itemSalePrice;
      allProductQuantity += i.quantity!; // total quantity of all products

      Map<String, dynamic> item = {
        "ItemCode": i.variantId,
        "ItemName": i.name,
        "Quantity": i.quantity!,
        "TaxRate": 0,
        "SaleValue": i.price?.toStringAsFixed(2), //actual price
        "TotalAmount": itemTotal.toStringAsFixed(2),
        "InvoiceType": 1,
        // "item_vat": itemVat.toStringAsFixed(2),
      };
      items.add(item);
    }

    Map<String, dynamic> jsonData = {
      "payment": isCashPayment.value ? payment.value : grandTotal,
      "paymentChange": paymentChange.value,
      "POSID": 803010,
      "USIN": orderIdFrmShpfy.value.toString(),
      "DateTime": formatted,
      "BuyerName": customerFirstName.value,
      "BuyerPhoneNumber": customerPhone.value,
      "TotalSaleValue": grandSaleValue.toStringAsFixed(2),
      "TotalTaxCharged": grandVAT.toStringAsFixed(2),
      // "Discount": 0.0, //optional field might add later
      "TotalBillAmount": grandTotal.toStringAsFixed(2),
      "TotalQuantity": allProductQuantity.toString(),
      "PaymentMode": isCashPayment.value ? 1 : 2,
      "vat": grandVAT.toStringAsFixed(2),
      "Items": items.toList(),
    };

    resetAllValues();
    await getProducts();
    createQr(jsonData);
  }

  resetAllValues() {
    productSKU.value = '';
    productToAdd.value = CartModel();
    productVariant.value = '';
    productQuantity.value = 1;
    productVariantStrings.value = [];
    paymentChange.value = 0;
    payment.value = 0;
    emailController.clear();
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    cashReceivedController.clear();
    allProducts.clear();
    productsToShow.clear();
    productsInCart.clear();
    Get.back();
  }

  resetBasicValues() {
    productSKU.value = '';
    productToAdd.value = CartModel();
    productVariant.value = '';
    productQuantity.value = 1;
    productVariantStrings.value = [];
    Get.back();
  }

  createQr(Map<String, dynamic> invoiceData) async {
    final image = await QrPainter(
      data: invoiceNumber,
      version: QrVersions.auto,
    ).toImageData(300);

    Uint8List bytes = image!.buffer.asUint8List();
    qrImage = pw.MemoryImage(bytes);

    receiptDialog(invoiceData);
  }

  Future receiptDialog(Map<String, dynamic> invoiceData) async {
    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ThemeHelper.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: SizedBox(
            width: 400,
            child: Scaffold(
              appBar: AppBar(),
              body: PdfPreview(
                canDebug: false,
                canChangeOrientation: false,
                canChangePageFormat: false,
                initialPageFormat: const PdfPageFormat(100, double.minPositive),
                build: (format) => createPDF(invoiceData),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<Uint8List> createPDF(Map<String, dynamic> receiptData) async {
    // final arabic = pw.Font.ttf(await rootBundle.load("assets/fonts/arabic-Regular.ttf"));
    // final arabicBold = pw.Font.ttf(await rootBundle.load("assets/fonts/arabic-Bold.ttf"));

    final backgroundLogo = pw.MemoryImage(
        (await rootBundle.load('assets/images/logo_black.png'))
            .buffer
            .asUint8List());

    final DateTime now = DateTime.now();
    final DateFormat formatter1 = DateFormat('dd-MM-yyyy');
    final DateFormat formatter2 = DateFormat('hh:mm:ss a');
    final String date = formatter1.format(now);
    final String time = formatter2.format(now);

    var pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageTheme: const pw.PageTheme(
          // theme: pw.ThemeData.withFont(base: arabic),
          pageFormat: PdfPageFormat.roll80,
        ),
        build: (context) {
          return pw.Column(
            children: [
              pw.Image(
                backgroundLogo,
                width: 70,
                height: 70,
              ),
              pw.Text(
                'ISMMART GENERAL TRADING L.L.C',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'اي اس ام مارت للتجارة العامة ذ.م.م',
                textAlign: pw.TextAlign.center,
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  font: arabicBold,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'Address: ${GlobalVariables.locationAddress.value}',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 7,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'For inquiries call ${'+97470241050'}',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 7,
                ),
              ),
              pw.Text(
                ' للاستفسار اتصل ${'+97470241050'}',
                textAlign: pw.TextAlign.center,
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(
                  fontSize: 7,
                  font: arabic,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'www.ismmartindustries.com',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 7,
                ),
              ),
              pw.SizedBox(height: 10),
              // pw.Text(
              //   'TAX INVOICE',
              //   textAlign: pw.TextAlign.center,
              //   style: pw.TextStyle(
              //     fontSize: 9,
              //     fontWeight: pw.FontWeight.bold,
              //   ),
              // ),
              // pw.Text(
              //   'فاتورة ضريبية',
              //   textAlign: pw.TextAlign.center,
              //   textDirection: pw.TextDirection.rtl,
              //   style: pw.TextStyle(
              //     fontSize: 9,
              //     font: arabicBold,
              //   ),
              // ),
              // pw.SizedBox(height: 5),
              // pw.Text(
              //   'TRN No : 356556156156',
              //   textAlign: pw.TextAlign.center,
              //   style: const pw.TextStyle(
              //     fontSize: 7,
              //   ),
              // ),
              // pw.Text(
              //   'رقم التسجيل الضريبي : 356556156156',
              //   textAlign: pw.TextAlign.center,
              //   textDirection: pw.TextDirection.rtl,
              //   style: pw.TextStyle(
              //     fontSize: 7,
              //     font: arabic,
              //   ),
              // ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 6, bottom: 3),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    infoItem(date),
                    infoItem(time),
                  ],
                ),
              ),
              pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                width: double.infinity,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(width: 0.5),
                ),
                child: pw.Column(
                  children: [
                    pw.Row(
                      children: [
                        headingItem('Item'),
                        headingItem('Price'),
                        headingItem('Qty'),
                        headingItem('Total'),
                        // headingItem("Vat"),
                      ],
                    ),
                    pw.Row(
                      children: [
                        headingItemArabic('غرض'),
                        headingItemArabic('سعر'),
                        headingItemArabic('الكمية'),
                        headingItemArabic('المجموع'),
                        // headingItemArabic("ضريبة"),
                      ],
                    ),
                    pw.Divider(thickness: 0.5),
                    pw.ListView.separated(
                      itemCount: receiptData['Items'].length,
                      itemBuilder: (context, index) {
                        final itemName =
                            receiptData['Items'][index]['ItemName'];
                        return pw.Row(
                          children: [
                            // pw.Text(
                            //   itemName,
                            //   textAlign: pw.TextAlign.center,
                            //   maxLines: 2,
                            //   style: pw.TextStyle(
                            //     fontSize: 5.5,
                            //     fontWeight: pw.FontWeight.normal,
                            //   ),
                            // ),
                            productItem2(
                              itemName,
                            ),
                            // productItem2(
                            //   receiptData['Items'][index]['SaleValue'],
                            // ),
                            productItem2(
                              receiptData['Items'][index]['Quantity'],
                            ),
                            productItem2(
                              receiptData['Items'][index]['TotalAmount'],
                            ),
                            // productItem2(
                            //   receiptData['Items'][index]['item_vat'],
                            // ),
                          ],
                        );
                      },
                      separatorBuilder: (context, int index) {
                        return pw.SizedBox(height: 10);
                      },
                    ),
                    pw.Divider(thickness: 0.5),
                    // calculationItem(
                    //   title: 'Sub Total',
                    //   value: receiptData['TotalSaleValue'],
                    //   arabicTitle: 'المجموع الفرعي',
                    // ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 5),
                      child: calculationItem(
                        title: 'Discount:',
                        value: '0.0',
                        arabicTitle: 'تخفيض',
                      ),
                    ),
                    // calculationItem(
                    //   title: 'Total VAT (5%)',
                    //   value: receiptData['vat'],
                    //   arabicTitle: 'ضريبة القيمة المضافة 5% ',
                    // ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 5),
                      child: calculationItem(
                        title: 'Total',
                        value: receiptData['TotalBillAmount'],
                        arabicTitle: 'المجموع',
                      ),
                    ),
                    calculationItem(
                      title: 'Paid Amount',
                      value: receiptData['payment'],
                      arabicTitle: 'المبلغ المدفوع',
                    ),
                    pw.SizedBox(height: 5),
                    calculationItem(
                      title: 'Balance:',
                      value: receiptData['paymentChange'],
                      arabicTitle: 'مقدار وسطي',
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Image(
                qrImage,
                width: 50,
                height: 50,
              ),
              pw.SizedBox(height: 10),
              // pw.Text(
              //   'Tax invoice no : 104111945200003',
              //   textAlign: pw.TextAlign.center,
              //   style: const pw.TextStyle(
              //     fontSize: 7,
              //   ),
              // ),
              // pw.SizedBox(height: 1),
              // pw.Text(
              //   'رقم الفاتورة الضريبية : 104111945200003',
              //   textAlign: pw.TextAlign.center,
              //   textDirection: pw.TextDirection.rtl,
              //   style: pw.TextStyle(
              //     fontSize: 7,
              //     font: arabic,
              //   ),
              // ),
              pw.SizedBox(height: 10),
              pw.Text(
                'REFUND POLICY',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 7.5,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'NO REFUND\n ONLY EXCHANGE WITH IN 14 DAYS WITH ORIGINAL RECEIPT.',
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(
                  fontSize: 7,
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Text(
                'سياسه الأستبدال و الاسترجاع',
                textAlign: pw.TextAlign.center,
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(
                  fontSize: 7.5,
                  font: arabicBold,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'خلال ١٤ من الشراء يمكن الاستبدال بالايصال',
                textAlign: pw.TextAlign.center,
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(
                  fontSize: 7,
                  font: arabic,
                ),
              ),
              pw.SizedBox(height: 15),
              pw.Text(
                'THANK YOU, HAPPY TO SEE YOU AGAIN',
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(
                  fontSize: 7.5,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                'شكرا لك، سعيد برؤيتك مرة أخرى',
                textAlign: pw.TextAlign.center,
                textDirection: pw.TextDirection.rtl,
                style: pw.TextStyle(
                  fontSize: 7.5,
                  font: arabicBold,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Text infoItem(String value) {
    return pw.Text(
      value,
      textAlign: pw.TextAlign.right,
      style: const pw.TextStyle(
        fontSize: 7,
      ),
    );
  }

  pw.Row calculationItem(
      {required String title, required String arabicTitle, required value}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          child: pw.Text(
            title,
            style: const pw.TextStyle(
              fontSize: 7,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value.toString(),
            style: const pw.TextStyle(
              fontSize: 7,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            arabicTitle,
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
              fontSize: 7,
              font: arabic,
            ),
          ),
        ),
      ],
    );
  }

  pw.Expanded headingItem(String value) {
    return pw.Expanded(
      child: pw.Align(
        alignment: pw.Alignment.center,
        child: pw.Text(
          value,
          style: const pw.TextStyle(
            fontSize: 6.5,
          ),
        ),
      ),
    );
  }

  pw.Expanded headingItemArabic(String value) {
    return pw.Expanded(
      child: pw.Align(
        alignment: pw.Alignment.center,
        child: pw.Text(
          value,
          textAlign: pw.TextAlign.center,
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(
            fontSize: 6.5,
            font: arabicBold,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ),
    );
  }

  pw.Expanded productItem2(receiptData) {
    return pw.Expanded(
      child: pw.Align(
        alignment: pw.Alignment.center,
        child: pw.Text(
          receiptData.toString(),
          style: pw.TextStyle(
            fontSize: 6,
            fontWeight: pw.FontWeight.normal,
          ),
        ),
      ),
    );
  }

  pw.Expanded productItem2Arabic(receiptData) {
    return pw.Expanded(
      child: pw.Align(
        alignment: pw.Alignment.center,
        child: pw.Text(
          receiptData.toString(),
          textDirection: pw.TextDirection.rtl,
          style: pw.TextStyle(
            fontSize: 6,
            fontWeight: pw.FontWeight.normal,
            font: arabic,
          ),
        ),
      ),
    );
  }

  Future cashInHandDialog() async {
    return showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ThemeHelper.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: SizedBox(
            width: 450,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: cashInHandFormKey,
                // Use a Form with a GlobalKey for validation.
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Day Start Cash Declaration',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'Please input the initial cash amount\nfor the start of your shift.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 35, bottom: 25),
                      child: CustomTextField1(
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        controller: cashInHandController,
                        hint: 'Cash In-Hand',
                        suffixIcon: Icons.payments_rounded,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Day Start Balance';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    // const SizedBox(height: 30),
                    CustomTextBtn(
                      title: 'Next',
                      onPressed: () async {
                        if (cashInHandFormKey.currentState!.validate()) {
                          GlobalVariables.startingBalance.value =
                              int.parse(cashInHandController.text);
                          Get.back();
                          focusNode.requestFocus();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}