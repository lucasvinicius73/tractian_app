import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/LOGOTRACTIAN.png'),
        backgroundColor: const Color(0xFF17192D),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildButtonHome("Jaguar Unit", context),
            buildButtonHome("Tobias Unit", context),
            buildButtonHome("Apex Unit", context),
          ],
        ),
      ),
    );
  }

  Widget buildButtonHome(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox(
        width: 317,
        height: 76,
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7))),
              backgroundColor:
                  const MaterialStatePropertyAll(Color(0xFF2188FF))),
          child: Row(
            children: [
              Image.asset('assets/icons/homeicon.png'),
              const SizedBox(
                width: 20,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontSize: 18, color: Colors.white, fontFamily: 'Roboto'),
              ),
            ],
          ),
          onPressed: () {
            Navigator.of(context).pushNamed('/assets_page');
          },
        ),
      ),
    );
  }
}
