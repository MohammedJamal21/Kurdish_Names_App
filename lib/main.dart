import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kurdish_names_app/models/names_model.dart';

void main(List<String> args) {
  runApp(const KurdishNames());
}

class KurdishNames extends StatefulWidget {
  const KurdishNames({Key? key}) : super(key: key);

  @override
  State<KurdishNames> createState() => _KurdishNamesState();
}

class _KurdishNamesState extends State<KurdishNames> {
  Future<Names> getNames() async {
    Uri namesUri = Uri(
      scheme: 'https',
      host: 'nawikurdi.com',
      path: '/api',
      queryParameters: {
        'limit': limit,
        'offset': '0',
        'gender': gender,
        'sort': sort,
      },
    );

    http.Response response = await http.get(namesUri);
    Names kurdishNames = Names.fromJson(response.body);

    return kurdishNames;
  }

  String dropdownValue = 'Neutral';
  String gender = 'O';

  String dropdownValue2 = 'Positive';
  String sort = 'positive';

  String dropdownValue3 = '10';
  String limit = '10';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ناوی کوردی'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    elevation: 8,
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == "Neutral") {
                          gender = 'O';
                        } else if (newValue == "Male") {
                          gender = 'M';
                        } else if (newValue == "Female") {
                          gender = 'F';
                        }
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['Neutral', 'Male', 'Female']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue2,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    elevation: 8,
                    onChanged: (String? newValue) {
                      setState(() {
                        if (newValue == "Positive") {
                          sort = 'positive';
                        } else if (newValue == "Negative") {
                          sort = 'negative';
                        }
                        dropdownValue2 = newValue!;
                      });
                    },
                    items: <String>['Positive', 'Negative']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: dropdownValue3,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    elevation: 8,
                    onChanged: (String? newValue) {
                      setState(() {
                        limit = newValue!;
                        dropdownValue3 = newValue;
                      });
                    },
                    items: <String>['5', '10', '20', '50', '100', '150']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            FutureBuilder<Names>(
              future: getNames(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.data == null) {
                  return const Text('There is no data');
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.names.length,
                    itemBuilder: ((context, index) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: ExpansionTile(
                          leading: Text(snapshot
                              .data!.names[index].positive_votes
                              .toString()),
                          title: Text(snapshot.data!.names[index].name),
                          children: [
                            Text(snapshot.data!.names[index].desc),
                          ],
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
