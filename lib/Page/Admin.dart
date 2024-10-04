import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mongo_lab1/Page/Editproduct_Page.dart';
import 'dart:math';
import 'package:flutter_mongo_lab1/Widget/customCliper.dart';
import 'package:flutter_mongo_lab1/controllers/auth_controller.dart';
import 'package:flutter_mongo_lab1/models/user_model.dart';
import 'package:flutter_mongo_lab1/providers/user_provider.dart';
import 'package:flutter_mongo_lab1/models/product_model.dart';
import 'package:flutter_mongo_lab1/controllers/product_controller.dart';
import 'package:provider/provider.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  _HomeAdminState createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  List<ProductModel> products = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _showLogoutConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการออกจากระบบ'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // close the dialog
              },
            ),
            TextButton(
              child: const Text('ออกจากระบบ'),
              onPressed: () {
                Provider.of<UserProvider>(context, listen: false)
                    .onLogout(); // เรียกฟังก์ชัน logout จาก controller

                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final productList = await ProductController().getProducts(context);
      setState(() {
        products = productList;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error fetching products: $error';
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching products: $error')));
    }
  }

  // ฟังก์ชันสำหรับการแก้ไขสินค้า
  void updateProduct(ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProductPage(product: product),
      ),
    );
  }

  Future<void> deleteProduct(ProductModel product) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // แสดงกล่องยืนยันก่อนทำการลบ
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบสินค้า'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการลบสินค้านี้?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(false); // ปิดกล่องและส่งค่ากลับ false
              },
            ),
            TextButton(
              child: const Text('ลบ'),
              onPressed: () {
                Navigator.of(context).pop(true); // ปิดกล่องและส่งค่ากลับ true
              },
            ),
          ],
        );
      },
    );

    // ถ้าผู้ใช้ยืนยันการลบ
    if (confirmDelete == true) {
      try {
        final response =
            await ProductController().deleteProduct(context, product.id);

        if (response.statusCode == 200) {
          Navigator.pushReplacementNamed(context, '/admin');
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('ลบสินค้าสำเร็จ')));
          // เรียกใช้งาน _fetchProducts เพื่อดึงข้อมูลสินค้าใหม่
          await _fetchProducts();
        } else if (response.statusCode == 401) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Refresh token expired. Please login again.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting product: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: [
            // Background
            Positioned(
              top: -height * .15,
              right: -width * .4,
              child: Transform.rotate(
                angle: -pi / 3.5,
                child: ClipPath(
                  clipper: ClipPainter(),
                  child: Container(
                    height: height * .5,
                    width: width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                         Color.fromARGB(255, 1, 197, 27),
                          Color.fromARGB(255, 232, 225, 13), 
                          Color.fromARGB(255, 232, 21, 21),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'จัดการ',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 64, 252, 2),
                        ),
                        children: [
                          TextSpan(
                            text: 'สินค้า',
                            style: TextStyle(
                                color: Color.fromARGB(255, 52, 51, 50), fontSize: 35),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    Consumer<UserProvider>(
                      builder: (context, UserProvider, _) {
                        return Column(
                          children: [
                            Text(
                              'Access Token : ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 126, 232, 20),
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${UserProvider.accessToken}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 241, 85, 129),
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              'Refresh Token : ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${UserProvider.refreshToken}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 150, 148, 146),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                AuthController().refreshToken(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 88, 88, 86),
                              ),
                              child: Text(
                                'Update Token',
                                style: TextStyle(color: Color.fromARGB(255, 106, 249, 29)),
                              ),
                            )
                          ],
                        );
                      },
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    // Button to add new product
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/add_product');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 105, 104, 104),
                      ),
                      child: Text(
                        'เพิ่มสินค้าใหม่',
                        style: TextStyle(color: Color.fromARGB(255, 108, 244, 24)),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Products List
                    // Display products or loading/error message
                    if (isLoading)
                      CircularProgressIndicator()
                    else if (errorMessage != null)
                      Text(errorMessage!)
                    else
                      _buildProductList(),
                  ],
                ),
              ),
            ),
            // LogOut Button
            Positioned(
              top: 50.0,
              right: 16.0,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
                child: Icon(
                  Icons.logout,
                  color: Color.fromARGB(255, 68, 68, 68),
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Column(
      children: List.generate(products.length, (index) {
        final product = products[index];
        return Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 13, 13, 13),
                width: 1.0,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 79, 108, 238)),
                    ),
                    Text(
                      'ประเภท: ${product.productType}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'ราคา: \$${product.price}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'หน่วย: ${product.unit}',
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              // Edit and Delete buttons (same as before)
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Color.fromARGB(255, 240, 244, 17),
                ),
                onPressed: () {
                  updateProduct(product); // เรียกฟังก์ชันแก้ไข
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 236, 15, 15),
                ),
                onPressed: () {
                  deleteProduct(product); // เรียกฟังก์ชันลบ
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}