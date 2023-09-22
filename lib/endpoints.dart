import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> fetchCardInfo(String cardName, Function(String) callback) async {
  final response = await http
      .get(Uri.parse('https://api.scryfall.com/cards/named?exact=$cardName'));

  if (response.statusCode == 200) {
    Map<String, dynamic> cardData = json.decode(response.body);

    //String cardName = cardData['name'];
    String imageUrl = cardData['image_uris']['normal'];

    callback(imageUrl);

    //print('Nome da Carta: $cardName');
    //print('URL da Imagem: $imageUrl');
  } else {
    // ignore: avoid_print
    print(
        'Erro ao buscar informações da carta. Status Code: ${response.statusCode}');
  }
}

Future<void> fetcRandonCard(Function(String) callback) async {
  final response =
      await http.get(Uri.parse('https://api.scryfall.com/cards/random'));

  if (response.statusCode == 200) {
    Map<String, dynamic> cardData = json.decode(response.body);

    //String cardName = cardData['name'];
    String imageUrl = cardData['image_uris']['normal'];

    callback(imageUrl);
  } else {
    // ignore: avoid_print
    print(
        'Erro ao buscar informações da carta. Status Code: ${response.statusCode}');
  }
}
