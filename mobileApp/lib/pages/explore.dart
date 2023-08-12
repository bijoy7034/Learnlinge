import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnlign/pages/cgatgpt.dart';
import 'package:learnlign/pages/connectionHome.dart';
import 'package:learnlign/pages/search_page.dart';
import 'package:learnlign/widgets/widgets.dart';

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
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the drawer icon
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.help)),
          IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),

        ],
        backgroundColor: Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Colors.white, Colors.white70],
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
      ),
      backgroundColor: Colors.black,
      body: Container(
        height: 800,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SearchPage()),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.grey.shade800,
                                  Colors.grey.shade800,
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
                                  Icon(Icons.groups, size: 40, color: Colors.amber,),
                                  Text('Rooms', style: TextStyle(color: Colors.white,fontFamily: 'Quicksand',
                                      fontWeight:FontWeight.bold, fontSize: 23 ),),
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
                            child: FadeIn(
                              child: InkWell(
                                onTap: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => UsersListScreen()),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.grey.shade800,
                                        Colors.grey.shade800,
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
                                        Icon(Icons.connect_without_contact_sharp, size: 40, color: Colors.green,),
                                        Text('Connect', style: TextStyle(color: Colors.white,fontFamily: 'Quicksand',
                                            fontWeight:FontWeight.bold, fontSize: 13),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 15,),
                          Expanded(
                            child: FadeIn(
                              child: InkWell(
                                onTap: (){

                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.grey.shade800,
                                        Colors.grey.shade800,

                                      ],
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(10.0), // Set the border radius value
                                  ),
                                  height: 130,
                                  child: InkWell(
                                    onTap: (){
                                      nextScreen(context, AlChatBox());
                                    },
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.chat_outlined, size: 35, color: Colors.blueAccent,),
                                          Text('AI Assistant', style: TextStyle(color: Colors.white,fontFamily: 'Quicksand',
                                              fontWeight:FontWeight.bold, fontSize: 13),)
                                        ],
                                      ),
                                    ),
                                  ),
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
                    width: 700,
                    child: SvgPicture.asset(
                      'Assets/undraw_scrum_board_re_wk7v.svg',
                      semanticsLabel: 'My SVG Image',
                      width: 230,
                    ),),

              ],
            ),
          ),
        ),
      ),

    );;
  }
}
