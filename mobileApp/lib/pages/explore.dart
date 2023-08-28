import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:learnlign/pages/cgatgpt.dart';
import 'package:learnlign/pages/connectionHome.dart';
import 'package:learnlign/pages/duscusionForum.dart';
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
      body: SlideInUp(
        child: Container(
          height: 800,
          decoration: BoxDecoration(
            color: Color.fromRGBO(27, 28, 28, 1),
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
                  const SizedBox(height: 12,),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0, right: 7,),
                    child:Row(
                      children: [
                        Expanded(child: Row(
                          children: [
                            Expanded(
                              child: FadeInUp(
                                child: InkWell(
                                  onTap: (){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  DiscussionForum()),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromRGBO(47, 48, 48, 1),
                                          Color.fromRGBO(47, 48, 48, 1),
                                        ],
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(10.0), // Set the border radius value
                                    ),
                                    height: 110,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.library_books, size: 30, color: Colors.redAccent,),
                                          Text('Discussion Forum', style: TextStyle(color: Colors.white,fontFamily: 'Quicksand',
                                              fontWeight:FontWeight.bold, fontSize: 13),)
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12,),
                            Expanded(
                              child:FadeInUp(
                                child: InkWell(
                                  onTap: (){

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromRGBO(47, 48, 48, 1),
                                          Color.fromRGBO(47, 48, 48, 1),

                                        ],
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(10.0), // Set the border radius value
                                    ),
                                    height: 110,
                                    child: InkWell(
                                      onTap: (){
                                        //nextScreen(context, AlChatBox());
                                      },
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.menu_book_outlined, size: 35, color: Colors.orange,),
                                            Text('Study Materials', style: TextStyle(color: Colors.white,fontFamily: 'Quicksand',
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
                  SizedBox(height: 12,),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0, right: 7,),
                    child: Row(
                      children: [
                        Expanded(
                          child: FadeInUp(
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
                                      Color.fromRGBO(47, 48, 48, 1),
                                      Color.fromRGBO(47, 48, 48, 1),
                                    ],
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(10.0), // Set the border radius value
                                ),
                                height: 110,
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
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 12,),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0, right: 7,),
                    child:Row(
                      children: [
                        Expanded(child: Row(
                          children: [
                            Expanded(
                              child: FadeInUp(
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
                                          Color.fromRGBO(47, 48, 48, 1),
                                          Color.fromRGBO(47, 48, 48, 1),
                                        ],
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(10.0), // Set the border radius value
                                    ),
                                    height: 110,
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
                            SizedBox(width: 12,),
                            Expanded(
                              child: FadeInUp(
                                child: InkWell(
                                  onTap: (){

                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color.fromRGBO(47, 48, 48, 1),
                                          Color.fromRGBO(47, 48, 48, 1),

                                        ],
                                      ),
                                      borderRadius:
                                      BorderRadius.circular(10.0), // Set the border radius value
                                    ),
                                    height: 110,
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
                  SizedBox(height: 35,),
                  SlideInUp(
                    child: Container(
                        width: 600,
                        child: SvgPicture.asset(
                          'Assets/undraw_scrum_board_re_wk7v.svg',
                          semanticsLabel: 'My SVG Image',
                          width: 200,
                        ),),
                  ),
                  SlideInUp(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text('Unlocking Minds, Empowering Futures' , textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Quicksand', color: Colors.white70),)),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),

    );;
  }
}
