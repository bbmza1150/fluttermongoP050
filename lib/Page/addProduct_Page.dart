import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_mongo_lab1/Widget/customCliper.dart'; // Assuming you already have customClipper
import 'package:flutter_mongo_lab1/controllers/product_controller.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  final ProductController _productController =
      ProductController(); // Create ProductController instance
  String productName = '';
  String productType = '';
  double price = 0.00;
  String unit = '';

  // แยกฟังก์ชันสำหรับเพิ่มสินค้า
  void _addNewProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // บันทึกข้อมูลสินค้าใหม่โดยเรียกฟังก์ชัน insertProduct
      _productController.InsertProduct(
        context,
        productName,
        productType,
        price,
        unit,
      ).then((response) {
        // ตรวจสอบว่าการเพิ่มสินค้าสำเร็จหรือไม่
        if (response.statusCode == 201) {
          // Success action here (e.g. navigate back or show success message)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('เพิ่มสินค้าเรียบร้อยแล้ว')),
          );
          Navigator.pushReplacementNamed(context, '/admin');
        } else if (response.statusCode == 401) {
          // แสดงข้อความเมื่อเกิดข้อผิดพลาดในการเพิ่มสินค้า
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Refresh token expired. Please login again.')),
          );
        }
      }).catchError((error) {
        // แสดงข้อความเมื่อเกิดข้อผิดพลาด
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เกิดข้อผิดพลาด: $error')),
        );
      });
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
            // Form content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: height * .1),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'เพิ่ม',
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w900,
                          color: Color.fromARGB(255, 133, 225, 4),
                        ),
                        children: [
                          TextSpan(
                            text: 'สินค้าใหม่',
                            style: TextStyle(
                                color: Color.fromARGB(255, 51, 51, 51), fontSize: 35),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _buildTextField(
                            label: 'ชื่อสินค้า',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกชื่อสินค้า';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              productName = value!;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'ประเภทสินค้า',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกประเภทสินค้า';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              productType = value!;
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'ราคา',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกราคา';
                              }
                              if (int.tryParse(value) == null) {
                                return 'กรุณากรอกจำนวนเต็มที่ถูกต้อง';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              price = double.parse(value!);
                            },
                          ),
                          SizedBox(height: 16),
                          _buildTextField(
                            label: 'หน่วย',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'กรุณากรอกหน่วย';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              unit = value!;
                            },
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: _addNewProduct,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromARGB(255, 74, 234, 11),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'บันทึก',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: const Color.fromARGB(255, 88, 85, 85),
                                    ),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context,
                                      '/admin'); // เปลี่ยนไปยังหน้าแสดงสินค้า
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(70, 69, 69, 1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0, vertical: 12.0),
                                  child: Text(
                                    'ยกเลิก',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 17, 219, 17),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType? keyboardType,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        keyboardType: keyboardType,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }
}