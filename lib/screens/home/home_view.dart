import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../helper/constants.dart';
import '../../helper/theme_helper.dart';
import '../../models/cart_model.dart';
import '../../models/order.dart';
import '../../widgets/custom_buttons.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_textfield.dart';
import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final HomeViewModel viewModel = Get.put(HomeViewModel());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const CustomDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    topMenu(context),
                    categoryProductList(context),
                  ],
                ),
              ),
              SizedBox(
                width: 350,
                child: Column(
                  children: [
                    cartProductListView(),
                    const SizedBox(height: 8),
                    cartCalculation(),
                    // viewModel.loadMore.value == true
                    //     ? Center(
                    //         child: const Padding(
                    //           padding: EdgeInsets.only(top: 10, bottom: 40),
                    //           child: Center(
                    //             child: CircularProgressIndicator(
                    //               color: Colors.white,
                    //             ),
                    //           ),
                    //         ),
                    //       )
                    //     : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topMenu(BuildContext context) {
    return Row(
      children: [
        Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu_outlined,
              color: Colors.white,
            ),
          );
        }),
        const SizedBox(width: 10),
        const Image(
          height: 50,
          width: 50,
          image: AssetImage('assets/images/logo_old.png'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            // autofocus: true,
            focusNode: viewModel.focusNode,
            controller: viewModel.searchTextController,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: ThemeHelper.white,
            ),
            onFieldSubmitted: (value) {
              viewModel.productsToShow.addAll(viewModel.allProducts.map((element) => element));
              for (var element in viewModel.allProducts) {
                int variantIndex = element.product!.variants!
                    .indexWhere((variant) => variant.barcode == value);
                if(element == viewModel.allProducts.last && variantIndex == -1){
                  AppConstants.displaySnackBar('Error', 'No item associated with this barcode');
                  viewModel.searchTextController.clear();
                  viewModel.focusNode.requestFocus();
                  return;
                }
                if (variantIndex == -1) {
                  continue;
                } else {
                  int productIndex = viewModel.productsInCart.indexWhere(
                          (element1) =>
                      element1.productId == element.product?.id);
                  if (productIndex == -1) {
                    viewModel.productsInCart.add(
                      CartModel(
                        name: element.product?.title,
                        price: element.product?.variants![variantIndex].price,
                        variantTitle:
                        element.product?.variants?[variantIndex].title,
                        quantity: 1,
                        productId: element.product?.id,
                        imageSrc: element.product?.image?.src,
                        sku: element.product?.variants?[variantIndex].sku,
                        variantId:
                        element.product?.variants?[variantIndex].id,
                        quantityInStock: element.product
                            ?.variants?[variantIndex].inventoryQuantity,
                        inventoryItemId: element
                            .product?.variants?[variantIndex].inventoryItemId,
                        properties: <Properties>[
                          Properties(name: 'Inventory Item ID',
                              value: element.product!.variants![variantIndex]
                                  .inventoryItemId)
                        ],
                      ),
                    );
                    viewModel.calculatePrice(
                        index: viewModel.productsInCart.length - 1,
                        price: viewModel.productsInCart.last.price!,
                        tax: 0,
                        add: true);
                    viewModel.searchTextController.clear();
                    viewModel.focusNode.requestFocus();
                  } else {
                    viewModel.quantityIncrementFrmCart(productIndex);
                    viewModel.searchTextController.clear();
                    viewModel.focusNode.requestFocus();
                  }
                }
              }
            },
            onChanged: (value) {
              if (value == '' ||
                  value.isEmpty ||
                  viewModel.searchTextController.text.isEmpty) {
                viewModel.productsToShow.clear();
                for (var element in viewModel.allProducts) {
                  viewModel.productsToShow.add(element);
                }
              } else {
                final valueSplitted = value.split("-");
                if (valueSplitted.length > 2) {
                  if (int.tryParse(valueSplitted[2]).runtimeType == int) {
                    return;
                  }
                } else {
                  viewModel.productsToShow.clear();
                  for (var element in viewModel.allProducts) {
                    if (element.product!.title!
                        .toLowerCase()
                        .contains(value.toLowerCase())) {
                      viewModel.productsToShow.add(element);
                    }
                  }
                }
              }
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(
                CupertinoIcons.search,
                size: 18,
                color: ThemeHelper.white,
              ),
              //suffixIconConstraints: BoxConstraints.tight(const Size(100, 40)),
              contentPadding: const EdgeInsets.only(left: 200),
              fillColor: Colors.white.withOpacity(0.1),
              filled: true,
              hintText: 'Search menu here...',
              isDense: true,
              hintStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: ThemeHelper.white,
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget categoryProductList(BuildContext context) {
    return Obx(
      () => Expanded(
        child: viewModel.showLoader.value == true
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : ResponsiveGridList(
                desiredItemWidth: 150,
                minSpacing: 10,
                children: List.generate(
                    viewModel.productsToShow.length, (index) => index).map((i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: InkWell(
                      onTap: () {
                        productDetailDialog(i);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.blue.withOpacity(0.03),
                        ),
                        child: Column(
                          children: [
                            CachedNetworkImage(
                              height: 100,
                              width: double.infinity,
                              imageUrl: viewModel.productsToShow[i].product
                                          ?.image?.src ==
                                      null
                                  ? ''
                                  : viewModel
                                      .productsToShow[i].product!.image!.src
                                      .toString(),
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/no_image_found.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              placeholder: (context, url) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                      strokeWidth: 0.5),
                                );
                              },
                            ),
                            const SizedBox(height: 15),
                            Column(
                              children: [
                                Text(
                                  '${viewModel.productsToShow[i].product?.title}',
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${viewModel.productsToShow[i].product?.variants?[0].price} QAR',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }

  Widget sideMenu(BuildContext context) {
    return Container(
      color: Colors.orange,
      width: 70,
      padding: const EdgeInsets.only(top: 24, right: 12, left: 12),
      child: Column(
        children: [
          _itemMenu(menu: 'Home', icon: Icons.home),
        ],
      ),
    );
  }

  Widget _itemMenu({required String menu, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: GestureDetector(
        onTap: () {
          //_setPage(menu);
        },
        child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.deepOrangeAccent,
              ),
              duration: const Duration(milliseconds: 300),
              curve: Curves.slowMiddle,
              child: Column(
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    menu,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget cartProductListView() {
    return Expanded(
      child: Obx(
        () => viewModel.productsInCart.isEmpty
            ? const Center(
                child: Text(
                  'No Items in Cart',
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Obx(
                () => ListView.builder(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 50),
                  itemCount: viewModel.productsInCart.length,
                  itemBuilder: (context, index) {
                    return listViewItem(index);
                  },
                ),
              ),
      ),
    );
  }

  Widget listViewItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.blue.withOpacity(0.1),
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            height: 70,
            width: 70,
            imageUrl: viewModel.productsInCart[index].imageSrc.toString(),
            imageBuilder: (context, imageProvider) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/no_image_found.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            placeholder: (context, url) {
              return const Center(
                child: CircularProgressIndicator(strokeWidth: 0.5),
              );
            },
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        viewModel.productsInCart[index].name.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    CustomIconButton(
                      onPressed: () {
                        viewModel.removeItemFrmCart(index);
                        // viewModel.productsInCart
                        //     .remove(viewModel.productsInCart[index]);
                      },
                      icon: Icons.close,
                    ),
                  ],
                ),
                viewModel.productsInCart[index].variantTitle != "Default Title"
                    ? Text(
                        "Variant: ${viewModel.productsInCart[index].variantTitle}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w300),
                      )
                    : const SizedBox(),
                Text(
                  '${viewModel.productsInCart[index].price} QAR',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    Obx(
                      () => Text(
                        'Qty : ${viewModel.productsInCart[index].quantity}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    CustomIconButton(
                      onPressed: () {
                        if (viewModel.productsInCart[index].quantity! > 1) {
                          viewModel.productsInCart[index].quantity =
                              viewModel.productsInCart[index].quantity! - 1;
                          viewModel.productsInCart.refresh();
                          viewModel.calculatePrice(
                              index: index,
                              tax: 0,
                              price: viewModel
                                  .productsInCart[index].price!,
                              add: false);
                        } else {
                          return;
                        }
                      },
                      icon: Icons.remove_circle_outline_outlined,
                    ),
                    Obx(
                      () => Text(
                        '${viewModel.productsInCart[index].quantity}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    CustomIconButton(
                      onPressed: () {
                        viewModel.quantityIncrementFrmCart(index);
                      },
                      icon: Icons.add_circle_outline_rounded,
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cartCalculation() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: ThemeHelper.green1.withOpacity(0.05),
      ),
      child: Column(
        children: [
          // Obx(() => item(
          //     title: 'Sub Total',
          //     value: '${viewModel.cartSubTotal.value} QAR')),
          // const SizedBox(height: 5),
          // Obx(() => item(
          //     title: 'Tax (VAT 5%)', value: '${viewModel.cartTax.value} QAR')),
          const Divider(
            color: Colors.white,
            thickness: 0.8,
          ),
          Obx(() => item(
              title: 'Total',
              value: '${viewModel.cartTotal.value} QAR',
              fontSize: 18)),
          const Divider(),
          const SizedBox(height: 20),
          CustomTextBtn(
            height: 55,
            backgroundColor: ThemeHelper.green1,
            title: 'PAY BILL',
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.payments_outlined),
                SizedBox(width: 15),
                Text('Proceed to Payment')
              ],
            ),
            onPressed: () {
              //viewModel1.cashierShiftReport();
              if (viewModel.productsInCart.isEmpty) {
                AppConstants.displaySnackBar(
                    'Error', 'Please add items to cart first');
              } else {
                Get.back();
                customerInfoDialog();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget item({
    required String title,
    required String value,
    double fontSize = 14,
  }) {
    return Row(
      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: fontSize,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: fontSize,
            ),
          ),
        ),
      ],
    );
  }

  Future customerInfoDialog() async {
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
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 35, bottom: 20, left: 20, right: 20),
                  child: Form(
                    key: viewModel
                        .formKey, // Use a Form with a GlobalKey for validation.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Customer Info',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          'Please enter Customer\'s Name and Phone No below.',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30, bottom: 18),
                          child: CustomTextField1(
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                            ],
                            controller: viewModel.firstNameController,
                            hint: 'First Name',
                            suffixIcon: CupertinoIcons.person,
                            validator: null,
                            // validator: (value) {
                            //   if (value == null || value.isEmpty) {
                            //     return 'Please enter first name';
                            //   }
                            //   viewModel.customerFirstName.value = value;
                            //   return null;
                            // },
                          ),
                        ),
                        CustomTextField1(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]')),
                          ],
                          controller: viewModel.lastNameController,
                          hint: 'Last Name',
                          suffixIcon: CupertinoIcons.person,
                          validator: null,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter last name';
                          //   }
                          //   viewModel.customerLastName.value = value;
                          //   return null;
                          // },
                        ),
                        const SizedBox(height: 20),
                        CustomTextField1(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: viewModel.phoneController,
                          hint: '123xxxxxx',
                          suffixIcon: CupertinoIcons.phone,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length != 8) {
                              return 'Please enter a valid phone number';
                            }
                            String phoneText = viewModel.phoneController.text;
                            viewModel.customerPhone.value =
                                int.parse(phoneText);
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        //add email address
                        CustomTextField1(
                          controller: viewModel.emailController,
                          hint: 'Email',
                          suffixIcon: CupertinoIcons.mail,
                          validator: (value) {
                            if (value == null || value.isEmpty || value == '') {
                              return null;
                            } else if(value.isNotEmpty && !value.isEmail){
                              return 'Enter correct email';
                            } else {
                              viewModel.customerEmail.value = value;
                              return null;
                            }
                          },
                        ),

                        const SizedBox(height: 30),
                        CustomTextBtn(
                          title: 'Next',
                          onPressed: () {
                            if (viewModel.formKey.currentState!.validate()) {
                              Get.back();
                              paymentMethodDialog();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: ExcludeFocus(
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                        viewModel.firstNameController.clear();
                        viewModel.lastNameController.clear();
                        viewModel.phoneController.clear();
                        viewModel.emailController.clear();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future paymentMethodDialog() async {
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
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 35, bottom: 20, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Payment Method',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Please select one of the below methods.',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              paymentDialogItem(
                                title: 'Cash',
                                icon: Icons.payments_outlined,
                                onTap: () {
                                  viewModel.isCashPayment.value = true;
                                },
                                selected: viewModel.isCashPayment.value == true
                                    ? true
                                    : false,
                              ),
                              const SizedBox(width: 20),
                              paymentDialogItem(
                                title: 'Credit Card',
                                icon: Icons.payment_rounded,
                                onTap: () {
                                  viewModel.isCashPayment.value = false;
                                },
                                selected: viewModel.isCashPayment.value == false
                                    ? true
                                    : false,
                              ),
                            ],
                          ),
                        ),
                      ),
                      CustomTextBtn(
                        title: 'Next',
                        onPressed: () {
                          if (viewModel.isCashPayment.isTrue) {
                            Get.back();
                            customerCashDialog();
                          } else {
                            viewModel.placeOrder();
                            viewModel.firstNameController.clear();
                            viewModel.lastNameController.clear();
                            viewModel.phoneController.clear();
                            viewModel.emailController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: ExcludeFocus(
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: ExcludeFocus(
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                        customerInfoDialog();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget paymentDialogItem({
    required String title,
    required IconData icon,
    required final GestureTapCallback? onTap,
    required bool selected,
  }) {
    return Expanded(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 35, bottom: 20, left: 20, right: 20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              border: selected
                  ? null
                  : Border.all(color: Colors.white54, width: 0.5),
              borderRadius: BorderRadius.circular(12),
              color: selected ? ThemeHelper.primaryColor : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 15),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future productDetailDialog(int index) async {
    viewModel.productSKU.value =
        "${viewModel.productsToShow[index].product?.variants?[0].sku}";
    viewModel.productAvailableStock.value = viewModel
        .productsToShow[index].product!.variants![0].inventoryQuantity!;

    if (viewModel.productAvailableStock.value > 0) {
      viewModel.productQuantity.value = 1;
    } else {
      viewModel.productQuantity.value = 0;
    }

    return showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: ThemeHelper.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          child: SizedBox(
            width: 800,
            child: Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      top: 16, bottom: 30, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Product Detail',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 0.3,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          CachedNetworkImage(
                            height: 300,
                            width: 300,
                            imageUrl:
                                '${viewModel.productsToShow[index].product?.image?.src}',
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            errorWidget: (context, url, error) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/no_image_found.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                            placeholder: (context, url) {
                              return const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 0.5),
                              );
                            },
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${viewModel.productsToShow[index].product?.title}',
                                  maxLines: 2,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Obx(
                                    () => Text(
                                      'Product SKU: ${viewModel.productSKU.value}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'QAR. ${viewModel.productsToShow[index].product?.variants?[0].price}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Obx(
                                      () => Text(
                                        'Available: ${viewModel.productAvailableStock.value}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ],
                                ),
                                viewModel.productsToShow[index].product!
                                            .options!.isEmpty ||
                                        viewModel.productsToShow[index].product!
                                                .variants!.first.title ==
                                            "Default Title"
                                    ? const SizedBox()
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: viewModel.productsToShow[index].product?.options?.length,
                                        itemBuilder: (context, index1) {
                                          List<String> optionsList = <String>[];
                                          viewModel.productsToShow[index].product?.options?[index1].values?.forEach((element) {
                                            optionsList.add(element);
                                          });
                                          RxString selectedValue = viewModel.productsToShow[index].product!.options![index1].values!.first.obs;
                                          viewModel.productVariantStrings
                                              .add(selectedValue.value);
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0),
                                            child: CustomDropDownList1(
                                                list: optionsList,
                                                value: selectedValue,
                                                onChanged: (value) {
                                                  int optionIndex = viewModel.productsToShow[index].product!.options![index1].values!.indexWhere((element) => element == value);
                                                  selectedValue.value = value;
                                                  viewModel.productVariantStrings[index1] = value;
                                                  viewModel.productVariantStrings.refresh();
                                                  viewModel.productVariant.value = '';
                                                  for (var element in viewModel.productVariantStrings) {
                                                    if (element == viewModel.productVariantStrings.first) {
                                                      viewModel.productVariant.value = element;
                                                    } else {
                                                      viewModel.productVariant.value = "${viewModel.productVariant.value} / $element";
                                                    }
                                                    if (element == viewModel.productVariantStrings.last) {
                                                      int variantIndex = viewModel.productsToShow[index].product!.variants!.indexWhere((element) => element.title == viewModel.productVariant.value);
                                                      if (variantIndex == -1) {
                                                        AppConstants.displaySnackBar('Error', 'This variant doesn\'t exist in inventory');
                                                        viewModel.productQuantity.value = 0;
                                                      } else {
                                                        if (viewModel.productsToShow[index].product!.variants![variantIndex].inventoryQuantity! > 0) {
                                                          viewModel.productAvailableStock.value = viewModel.productsToShow[index].product!.variants![variantIndex].inventoryQuantity!;
                                                          viewModel.productQuantity.value = 1;
                                                          viewModel.productSKU.value = viewModel.productsToShow[index].product!.variants![optionIndex].sku.toString();
                                                          viewModel.productAvailableStock.value = viewModel.productsToShow[index].product!.variants![optionIndex].inventoryQuantity!;
                                                        } else {
                                                          viewModel.productAvailableStock.value = 0;
                                                          viewModel.productQuantity.value = 0;
                                                          viewModel.productSKU.value = viewModel.productsToShow[index].product!.variants![optionIndex].sku.toString();
                                                          viewModel.productAvailableStock.value = viewModel.productsToShow[index].product!.variants![optionIndex].inventoryQuantity!;
                                                          AppConstants.displaySnackBar('Error','Variant not available in stock');
                                                        }
                                                      }
                                                    }
                                                  }
                                                }),
                                          );
                                        },
                                      ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    CustomIconButton2(
                                      onPressed: () {
                                        viewModel.quantityDecrement();
                                      },
                                      icon:
                                          Icons.remove_circle_outline_outlined,
                                    ),
                                    Obx(
                                      () => Text(
                                        "${viewModel.productQuantity.value}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    CustomIconButton2(
                                      onPressed: () {
                                        viewModel.quantityIncrement(index);
                                      },
                                      icon: Icons.add_circle_outline_rounded,
                                    ),
                                    const SizedBox(width: 20),
                                    CustomTextBtn(
                                      width: 300,
                                      title: 'Add To Cart',
                                      child: const Row(
                                        children: [
                                          Icon(Icons.shopping_cart_rounded),
                                          SizedBox(width: 12),
                                          Text(
                                            'Add To Cart',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        if (viewModel.productQuantity.value >
                                            0) {
                                          viewModel.addToCart(index);
                                        } else {
                                          AppConstants.displaySnackBar('Error',
                                              'Product cannot be added to cart');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: ExcludeFocus(
                    child: IconButton(
                      onPressed: () {
                        viewModel.resetBasicValues();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future customerCashDialog() async {
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
            width: 400,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 35, bottom: 20, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Customer Cash',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Please enter the cash received from Customer',
                        style: TextStyle(
                          color: Colors.white38,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 15),
                      cashDialogItem(
                          title: 'Total',
                          value: 'QAR ${viewModel.cartTotal.value}'),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Obx(() => cashDialogItem(
                            title: 'Payment',
                            value: 'QAR ${viewModel.payment.value}')),
                      ),
                      Obx(() => cashDialogItem(
                          title: 'Change',
                          value: 'QAR ${viewModel.paymentChange.value}')),
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 25),
                        child: CustomTextField1(
                          controller: viewModel.cashReceivedController,
                          hint: 'Cash Received',
                          suffixIcon: Icons.payments_rounded,
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter amount received';
                          //   } else if(double.parse(viewModel.cashReceivedController.text) < viewModel.cartTotal.value){
                          //     return AppConstants.displaySnackBar('Error', 'Received amount is less than total cart amount');
                          //   } else{
                          //     return null;
                          //   }
                          // },
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextBtn(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              title: 'Calculate',
                              onPressed: () {
                                if (viewModel
                                    .cashReceivedController.text.isEmpty) {
                                  return;
                                } else {
                                  viewModel.payment.value = int.parse(
                                      viewModel.cashReceivedController.text);
                                  viewModel.paymentChange.value =
                                      viewModel.payment.value -
                                          viewModel.cartTotal.value.toInt();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: CustomTextBtn(
                              title: 'Checkout',
                              onPressed: () {
                                if (viewModel
                                        .cashReceivedController.text.isEmpty ||
                                    viewModel.cashReceivedController.text ==
                                        '') {
                                  AppConstants.displaySnackBar(
                                      'Error', 'Enter received amount');
                                } else if (double.parse(
                                        viewModel.cashReceivedController.text) <
                                    viewModel.cartTotal.value) {
                                  AppConstants.displaySnackBar('Error',
                                      'Received amount is less than total cart amount');
                                } else {
                                  viewModel.placeOrder();
                                  viewModel.firstNameController.clear();
                                  viewModel.lastNameController.clear();
                                  viewModel.phoneController.clear();
                                  viewModel.emailController.clear();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 0,
                  child: ExcludeFocus(
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                        paymentMethodDialog();
                        //clear all values
                        viewModel.payment.value = 0;
                        viewModel.paymentChange.value = 0;
                        viewModel.cashReceivedController.clear();
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget cashDialogItem({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
