import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  O3DController controller = O3DController();
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    var _cameras = await availableCameras();
    cameraController = CameraController(_cameras[0], ResolutionPreset.max);
    cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => controller.cameraOrbit(20, 20, 5),
            icon: const Icon(Icons.change_circle),
          ),
          IconButton(
            onPressed: () => controller.cameraTarget(1.2, 1, 4),
            icon: const Icon(Icons.change_circle_outlined),
          ),
        ],
      ),
      body: cameraController != null
          ? Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(cameraController!),
                O3D(
                  controller: controller,
                  src: 'assets/Humanskeleton.glb',
                  cameraControls: true,
                ),
              ],
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
