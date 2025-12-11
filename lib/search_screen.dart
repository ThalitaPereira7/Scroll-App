import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Discover',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  Icon(
                    Icons.search,
                    color: const Color.fromARGB(255, 88, 88, 88),
                    size: 30,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                "Seus Favoritos", style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/images/perfil1.png",
                    height: 61,
                    width: 61,
                  ),
                  SizedBox(width: 10),
                  Image.asset(
                    "assets/images/perfil2.png",
                    height: 61,
                    width: 61,
                  ),
                  SizedBox(width: 10),
                  Image.asset(
                    "assets/images/perfil3.png",
                    height: 61,
                    width: 61,
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 285,
                child:
                  SvgPicture.asset("assets/images/banner.svg", width: double.infinity, fit: BoxFit.cover,),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Text(
                    "Popular Videos",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Row(
                  
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/video1.png",
                      ),
                      SizedBox.fromSize(size: Size(10, 0)),
                      Text("Mostre seu prato favorito", style: TextStyle(color: Colors.white70, fontSize: 16),)
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/images/video2.png",
                     
                      ),
                      SizedBox.fromSize(size: Size(10, 0)),
                      Text("Se arrume-se comigo", style: TextStyle(color: Colors.white70, fontSize: 16),)
                    ],
                  ),

                ],
              )
              
            ],
          ),
        ),
      );
  }
}
