import 'package:flutter/material.dart';

import 'custom_dropdown_multiselect/custom_dropdown_multiselect.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Home Page"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width*0.9,
              child: DynamicDropdown(
                isMultiSelect: false,
                items: ["Hellow","World","Too","WWa","kdkfdj","kdf"],
                isSearchEnable: true,
              ),
            )
          ],
        ),
      ),

    );
  }
}
