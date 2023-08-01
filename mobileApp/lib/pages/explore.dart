import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the drawer icon
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.help)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),

        ],
        backgroundColor: Colors.blueAccent,
        title: ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              colors: [Colors.white70, Colors.white],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child:Text(
            "Explore",
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: Colors.blueAccent,
      body: Container(
        height: 800,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(left: 7.0, right: 7, top: 60),
                //   child: TextFormField(
                //     style: const TextStyle(
                //       color: Colors.white, // Set the desired text color
                //     ),
                //     decoration: const InputDecoration(filled: true,
                //         contentPadding: EdgeInsets.symmetric(vertical:0, horizontal:19),
                //         fillColor: Colors.black54, labelText: "Search", focusedBorder: OutlineInputBorder(
                //           borderSide: BorderSide(color: Color.fromRGBO(88, 101, 242, 0.9)),
                //         ), border: OutlineInputBorder(
                //           borderSide: BorderSide(color: Colors.orange),
                //         ), labelStyle: TextStyle(color: Colors.white60)),
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Please enter a vale';
                //       }
                //       return null;
                //     },
                //   ),
                // ),
                const SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.only(left: 7.0, right: 7,),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => GroupsAll()),
                            // );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color.fromRGBO(233, 230, 244,0.9),
                                  Color.fromRGBO(233, 230, 244,0.9),
                                ],
                              ),
                              borderRadius:
                              BorderRadius.circular(10.0), // Set the border radius value
                            ),
                            height: 130,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.groups, size: 40, color: Colors.green,),
                                  Text('Rooms', style: TextStyle(color: Colors.black54,fontFamily: 'Quicksand',
                                      fontWeight:FontWeight.bold, fontSize: 20 ),),
                                  SizedBox(height: 10,)
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.only(left: 7.0, right: 7,),
                  child:Row(
                    children: [
                      Expanded(child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromRGBO(233, 230, 244,0.9),
                                    Color.fromRGBO(233, 230, 244,0.9),
                                  ],
                                ),
                                borderRadius:
                                BorderRadius.circular(10.0), // Set the border radius value
                              ),
                              height: 130,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.menu_book_rounded, size: 30, color: Colors.orange,),
                                    Text('Study Materials', style: TextStyle(color: Colors.black54,fontFamily: 'Quicksand',
                                        fontWeight:FontWeight.bold, fontSize: 13),)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color.fromRGBO(233, 230, 244,0.9),
                                    Color.fromRGBO(233, 230, 244,0.9),

                                  ],
                                ),
                                borderRadius:
                                BorderRadius.circular(10.0), // Set the border radius value
                              ),
                              height: 130,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.stacked_bar_chart, size: 30, color: Colors.blueAccent,),
                                    Text('Discussion Forums', style: TextStyle(color: Colors.black54,fontFamily: 'Quicksand',
                                        fontWeight:FontWeight.bold, fontSize: 13),)
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ))
                    ],
                  ),
                ),
                SizedBox(height: 55,),
                Container(
                    width: 600,
                    child: Image.asset('Assets/5853.png')),

              ],
            ),
          ),
        ),
      ),

    );;
  }
}
