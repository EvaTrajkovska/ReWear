import 'package:flutter/material.dart';

class SingleUserProfileHeader extends StatelessWidget {
  final String username;

  SingleUserProfileHeader({required this.username});

  @override
  Widget build(BuildContext context) {
    String initial = username.isNotEmpty ? username[0].toUpperCase() : '?';
    return Column(

      //  mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            Row(
              children: [
                const Divider(),
                Text(username, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                 const Divider()
              ],
            )
          ],
        ),
        SizedBox(height: 20),

        Row(
          children: [
          CircleAvatar(
          backgroundColor:
          const Color.fromARGB(255, 1, 25, 45),
          child: Text(initial, style: TextStyle(color: Colors.white, fontSize: 50)),
            radius: 60,
        ),
            SizedBox(width: 50,),
            const Row(
              children: [
            Column(
                children: [
                  Text('Следбеници', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                ]
            ),
            ]),
            const SizedBox(width: 50,),
            Column(
                children: [
                  Text('Оцена', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
                ]
            ),
            SizedBox(width: 50,),

          ]
        ),
          SizedBox(height: 50),


        Column(
          children: [
            Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add),
                      label: Text('Види оцени'),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 7, 139, 86),
                        onPrimary: Color.fromARGB(255, 1, 68, 41),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding:
                        EdgeInsets.symmetric(horizontal: 70, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: BorderRadius.only,
                    ),
                  ),
                ]
            ),
            Row(
              children: [
                const Divider(),
                Text('Моја продавница', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)),
              ],
            )
          ],
        ),
      ],
    );
  }
}
