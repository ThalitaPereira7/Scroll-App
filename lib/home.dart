import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
} 

class _HomeState extends State<Home> {
  final List<String> videoPaths = [
    'assets/videos/cachorro.mp4',
    'assets/videos/metro.mp4',
    'assets/videos/praia.mp4',
  ];

  late List<VideoPlayerController> controllers;
  int currentIndex = 0;
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    controllers = videoPaths
        .map((path) => VideoPlayerController.asset(path))
        .toList();

    // Inicializa os vídeos
    for (var controller in controllers) {
      controller.initialize().then((_) {
        setState(() {});
      });
    }

    // Começa o primeiro vídeo automaticamente
    controllers[0].setLooping(true);
    controllers[0].play();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      // Pausa o vídeo anterior
      controllers[currentIndex].pause();
      // Atualiza o índice atual
      currentIndex = index;
      // Inicia o novo vídeo
      controllers[currentIndex].setLooping(true);
      controllers[currentIndex].play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        scrollDirection: Axis.vertical,
        controller: pageController,
        itemCount: controllers.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final controller = controllers[index];
          return controller.value.isInitialized
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller.value.size.width,
                        height: controller.value.size.height,
                        child: VideoPlayer(controller),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: Image.asset(
                        "assets/images/logo.png",
                        width: 120,
                      ),
                    ),
                    Positioned(
                      bottom: 40,
                      right: 20,
                      child: IconButton(
                        iconSize: 40,
                        color: Colors.white,
                        icon: Icon(
                          controller.value.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                        ),
                        onPressed: () {
                          setState(() {
                            controller.value.isPlaying
                                ? controller.pause()
                                : controller.play();
                          });
                        },
                      ),
                    ),

                     Positioned(
                      bottom: 40,
                      left: 20,
                      child: Column(
                        children: [
                          Row(

                            children: [
                              Image.asset("assets/images/user.png",width: 50,),
                              SizedBox.fromSize(size: Size(10, 0)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                Text("Thalita", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                                Text("olha esse videooo", style: TextStyle(color: Colors.white),)

                              ],)
                            ],
                          )
                        ],
                      )
                    ),

                    
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
        },
      ),
      
    );
  }
}
