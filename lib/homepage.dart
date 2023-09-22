import 'package:flutter/material.dart';
import 'package:magic_app/endpoints.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _nomeCartaController = TextEditingController();
  String _nomeCarta = "";
  String _imageUrl = "";
  bool returnStatus = false;
  String type = "start";

  void updateImageUrl(String imageUrl) {
    setState(() {
      _imageUrl = imageUrl;
      returnStatus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 89, 74, 74),
                Color.fromARGB(255, 140, 10, 10)
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    (!returnStatus && type == 'start')
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(8, 10, 8, 20),
                            child: Column(
                              children: [
                                const Text(
                                  'Let\'s check some Magic Cards!',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 248, 216, 122),
                                  ),
                                ),
                                const SizedBox(
                                  height: 60,
                                ),
                                Image.asset(
                                  'assets/images/Elesh_Norn.png',
                                  height: 200,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          )
                        : Container(),
                    (returnStatus || type != 'start')
                        ? Column(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    type = 'start';
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                    returnStatus = false;
                                    _nomeCarta = "";
                                    _imageUrl = "";
                                    _nomeCartaController.text = '';
                                  });
                                },
                                child: const Text('Back to begin'),
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          )
                        : Container(),
                    (type == 'start' || type == 'search')
                        ? searchCard()
                        : Container(),
                    (type == 'start' || type == 'random')
                        ? randomCard()
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column randomCard() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            type = 'random';
            fetcRandonCard(updateImageUrl);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 115, 132, 155),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(200, 50),
          ),
          child: const Text('Pick a Random Card'),
        ),
        const SizedBox(height: 10),
        _imageUrl.isNotEmpty
            ? Image.network(
                _imageUrl,
                height: 500,
                width: 357,
                fit: BoxFit.contain,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          strokeWidth: 5,
                          color: Colors.amber,
                        ),
                      ),
                    );
                  }
                },
              )
            : Container(),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  Column searchCard() {
    return Column(
      children: [
        SizedBox(
          width: 380,
          child: TextField(
            controller: _nomeCartaController,
            onChanged: (value) {
              setState(() {
                _nomeCarta = value;
              });
            },
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color.fromARGB(
                        95, 183, 68, 237)), // Cor da borda quando focado
                borderRadius: BorderRadius.circular(14.0),
              ),
              labelStyle: const TextStyle(
                color: Color.fromARGB(255, 49, 53, 55),
                fontSize: 16.0,
              ),
              labelText: 'Card name',
              hintText: 'Ex: Plasma Elemental',
              hintStyle: const TextStyle(
                color: Colors.grey,
                fontSize: 14.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.all(10.0),
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_nomeCarta != '') {
              type = 'search';
              fetchCardInfo(_nomeCarta, updateImageUrl);
              setState(() {});
            }
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color.fromARGB(255, 115, 132, 155),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: const Size(200, 50),
          ),
          child: const Text('Search Card by Name'),
        ),
        const SizedBox(height: 10),
        _imageUrl.isNotEmpty
            ? Image.network(
                height: 500,
                width: 357,
                _imageUrl,
                fit: BoxFit.contain,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                          strokeWidth: 5,
                          color: Colors.amber,
                        ),
                      ),
                    );
                  }
                },
              )
            : Container(),
      ],
    );
  }
}
