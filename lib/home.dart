// home.dart - Modificado para buscar vídeos da API Pexels
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<VideoPlayerController> controllers;
  int currentIndex = 0;
  final PageController pageController = PageController();
  Map<String, dynamic>? _userData;
  bool _loadingUser = true;
  bool _loadingVideos = true;
  List<String> _videoUrls = [];
  String? _errorMessage;

  final String _apiKey =
      '02c0OTF5ofPOKZnuEFNhK7bvLvDCemTN5ven5LqxSCauR3cPLLgz4UAt';
  final String _apiUrl = 'https://api.pexels.com/v1/videos/popular?per_page=10';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _fetchVideosFromApi();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final name = prefs.getString('name');

    if (username != null && name != null) {
      setState(() {
        _userData = {'username': username, 'name': name};
        _loadingUser = false;
      });
    } else {
      setState(() {
        _loadingUser = false;
      });
    }
  }

  Future<void> _fetchVideosFromApi() async {
    try {
      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {'Authorization': _apiKey}, // 2. Envia a chave no cabeçalho
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> videos = data['videos'];

        // 3. Extrai a URL do arquivo de vídeo em qualidade HD
        List<String> videoUrls = [];
        for (var video in videos) {
          // Pega a primeira URL de vídeo em HD disponível
          String? videoUrl;
          List<dynamic> videoFiles = video['video_files'];
          for (var file in videoFiles) {
            if (file['quality'] == 'hd') {
              videoUrl = file['link'];
              break;
            }
          }
          // Fallback: pega a primeira URL se não encontrar HD
          videoUrl ??= videoFiles.isNotEmpty ? videoFiles[0]['link'] : null;
          if (videoUrl != null) {
            videoUrls.add(videoUrl);
          }
        }

        setState(() {
          _videoUrls = videoUrls;
          _loadingVideos = false;
        });

        _initializeVideosFromUrls(videoUrls);
      } else {
        setState(() {
          _errorMessage = "Erro na API: ${response.statusCode}";
          _loadingVideos = false;
        });
        log('Erro na API: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Erro de conexão: $e";
        _loadingVideos = false;
      });
    }
  }

  void _initializeVideosFromUrls(List<String> videoUrls) {
    if (videoUrls.isEmpty) {
      // Fallback para vídeos locais caso a API não retorne nada
      _useFallbackVideos();
      return;
    }

    // 4. Cria controllers para URLs de rede
    controllers = videoUrls
        .map((url) => VideoPlayerController.networkUrl(Uri.parse(url)))
        .toList();

    for (var controller in controllers) {
      controller
          .initialize()
          .then((_) {
            if (mounted) setState(() {});
          })
          .catchError((error) {
            log('Erro ao inicializar vídeo: $error');
          });
    }

    if (controllers.isNotEmpty) {
      controllers[0].setLooping(true);
      controllers[0].play();
    }
  }

  void _useFallbackVideos() {
    log('Usando vídeos locais como fallback');
    final fallbackPaths = [
      'assets/videos/cachorro.mp4',
      'assets/videos/metro.mp4',
      'assets/videos/praia.mp4',
    ];

    controllers = fallbackPaths
        .map((path) => VideoPlayerController.asset(path))
        .toList();

    for (var controller in controllers) {
      controller.initialize().then((_) {
        if (mounted) setState(() {});
      });
    }

    if (controllers.isNotEmpty) {
      controllers[0].setLooping(true);
      controllers[0].play();
    }

    setState(() {
      _loadingVideos = false;
    });
  }

  // ... (Os métodos dispose, _onPageChanged e _buildErrorView permanecem IDÊNTICOS aos fornecidos anteriormente)
  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (controllers.isEmpty) return;

    setState(() {
      controllers[currentIndex].pause();
      currentIndex = index;
      controllers[currentIndex].setLooping(true);
      controllers[currentIndex].play();
    });
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.white, size: 50),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? "Erro desconhecido",
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchVideosFromApi,
            child: const Text("Tentar novamente"),
          ),
        ],
      ),
    );
  }

  // ... (O método build permanece IDÊNTICO ao fornecido anteriormente)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _loadingUser
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _errorMessage != null
          ? _buildErrorView()
          : _loadingVideos
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _videoUrls.isEmpty
          ? const Center(
              child: Text(
                "Nenhum vídeo disponível",
                style: TextStyle(color: Colors.white),
              ),
            )
          : PageView.builder(
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
                          // Vídeo
                          FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: controller.value.size.width,
                              height: controller.value.size.height,
                              child: VideoPlayer(controller),
                            ),
                          ),

                          // Logo
                          Positioned(
                            top: 50,
                            left: 20,
                            child: Image.asset(
                              "assets/images/logo.png",
                              width: 120,
                            ),
                          ),

                          // Botão de play/pause
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

                          // Dados do usuário
                          Positioned(
                            bottom: 40,
                            left: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: AssetImage(
                                        "assets/images/user.png",
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _userData?['name'] ?? 'Usuário',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "@${_userData?['username'] ?? 'user'}",
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "olha esse videooo",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
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
