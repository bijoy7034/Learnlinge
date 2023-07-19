import 'package:flutter/material.dart';
import 'package:learnlinge/Screens/AddPost.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [Colors.blue, Color.fromRGBO(88, 101, 242, 0.9)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds);
                      },
                      child:Text(
                        "Explore",
                        style: TextStyle(
                            color: Color.fromRGBO(88, 101, 242, 0.9),
                            fontSize: 30,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
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
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color.fromRGBO(88, 101, 242, 0.9),
                              Colors.grey.shade900,
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
                              Icon(Icons.groups, size: 40, color: Colors.white,),
                              Text('Groups', style: TextStyle(color: Colors.white,fontFamily: 'Quicksand',
                                  fontWeight:FontWeight.bold, fontSize: 20 ),),
                              SizedBox(height: 10,)
                            ],
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
                                  Colors.green,
                                  Colors.blueAccent,
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
                                  Icon(Icons.menu_book_rounded, size: 30, color: Colors.white,),
                                  Text('Study Materials', style: TextStyle(color: Colors.white,fontFamily: 'Quicksand',
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
                                  Colors.blue,
                                  Colors.green,

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
                                  Icon(Icons.stacked_bar_chart, size: 30, color: Colors.white,),
                                  Text('Discussion Forums', style: TextStyle(color: Colors.white,fontFamily: 'Quicksand',
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
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          colors: [Colors.blue, Color.fromRGBO(88, 101, 242, 0.9)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ).createShader(bounds);
                      },
                      child:Text(
                        "Feeds",
                        style: TextStyle(
                            color: Color.fromRGBO(88, 101, 242, 0.9),
                            fontSize: 30,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Spacer(),
                    IconButton(onPressed: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return PostNewDialog();
                        },
                      );
                    }, icon: Icon(Icons.add_box_outlined, color: Colors.white,)),
                    IconButton(onPressed: (){}, icon: Icon(Icons.more_vert, color: Colors.white,))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
