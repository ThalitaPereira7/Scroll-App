import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

  @override
  void initState() {
    super.initState();
    controllers = videoPaths
        .map((path) => VideoPlayerController.asset(path)..initialize())
        .toList();
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/logo.png", width: 400,),
            SizedBox(height: 24),
            CarouselSlider(
              options: CarouselOptions(
                height: 300,
                enlargeCenterPage: true,
                autoPlay: false,
              ),
              items: controllers.map((controller) {
                return Builder(
                  builder: (BuildContext context) {
                    return controller.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: VideoPlayer(controller),
                          )
                        : Container(
                            color: Colors.black,
                            child: Center(child: CircularProgressIndicator()),
                          );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Play/Pause o vídeo atual do carrossel
          final current = controllers.firstWhere(
            (c) => c.value.isInitialized && c.value.isPlaying,
            orElse: () => controllers[0],
          );
          setState(() {
            current.value.isPlaying ? current.pause() : current.play();
          });
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }
}