import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stability_image_generation/stability_image_generation.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _AiTextToImageGeneratorState();
}

class _AiTextToImageGeneratorState extends State<homescreen> {
  final TextEditingController _queryController = TextEditingController();
  final StabilityAI _ai = StabilityAI();
  final ImageAIStyle imageAIStyle = ImageAIStyle.digitalPainting;
  bool isGenerating = false;
  Future<Uint8List>? generatedImageFuture;

  Future<Uint8List> _generate(String query) async {
    try {
      return await _ai.generateImage(
        apiKey: "sk-Rxgj0ASNoEZXINeSMjtit55892DZRqbztI5ECLdIvYCMOPLd",
        imageAIStyle: imageAIStyle,
        prompt: query,
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error generating image: $e");
      }
      return Uint8List(0);
    }
  }

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0070),
      appBar: AppBar(
        title: const Text("ImagineX - AI Image Generator"),
        backgroundColor: const Color(0xFF1A0070),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _queryController,
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    hintText: 'Enter your prompt',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty && !isGenerating) {
                      _startGeneration(value.trim());
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isGenerating
                    ? null
                    : () {
                  final query = _queryController.text.trim();
                  if (query.isNotEmpty) {
                    _startGeneration(query);
                  }
                },
                child: isGenerating
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  "Generate Photo",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              if (generatedImageFuture == null)
                const Text(
                  "No image generated yet",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )
              else
                FutureBuilder<Uint8List>(
                  future: generatedImageFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.memory(snapshot.data!),
                      );
                    } else {
                      return const Text(
                        "Failed to generate photo",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      );
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _startGeneration(String prompt) {
    setState(() {
      isGenerating = true;
      generatedImageFuture = _generate(prompt);
    });

    generatedImageFuture!.then((_) {
      setState(() {
        isGenerating = false;
      });
    });
  }
}
