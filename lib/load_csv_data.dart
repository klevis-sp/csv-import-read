import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class LoadCsvDataScreen extends StatelessWidget {
  const LoadCsvDataScreen({super.key, required this.filePath});

  final String filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CSV Data"),
      ),
      // Future Builder which shows the data from the csv file
      body: FutureBuilder(
        future: loadCsvData(filePath),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            final data = snapshot.data as List<List<dynamic>>;
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (_, index) {
                final tagName = data[index][1].toString();
                final split = tagName.split(',');
                final Map<int, String> values = {
                  for (int i = 0; i < split.length; i++) i: split[i]
                };
                print(values);

                values.forEach((key, value) {
                  print(value);
                });

                //print(data[index][1].toString().replaceAll(",", " -- "));
                // check if there is data for [index][1] and show error if not
                return Card(
                  margin: const EdgeInsets.all(3),
                  color: index == 0 ? Colors.amber : Colors.white,
                  child: ListTile(
                    leading: index == 0
                        ? const Icon(Icons.check_box)
                        : Checkbox(
                            value: data[index][2] == 6,
                            onChanged: (value) {},
                          ),
                    title: Text(data[index][0].toString()),
                    subtitle: Text(data[index][1].toString()),
                    trailing: Text(data[index][2].toString()),
                  ),
                );
              },
              // itemBuilder: (context, index) {
              //   return ListTile(
              //     title: Text(snapshot.data![index][0].toString()),
              //     subtitle: Text(snapshot.data![index][1].toString()),
              //     trailing: Text(snapshot.data![index][2].toString()),
              //     // checkbox as leading widget
              //     leading: Checkbox(
              //       value: snapshot.data![index][2] == 2,
              //       onChanged: (value) {},
              //     ),
              //   );
              // },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error while loading the csv file",
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<List<List<dynamic>>> loadCsvData(String filePath) async {
    // Load the csv file from the storage
    // The file path is from the file picker
    final csvFile = File(filePath).openRead();

    // return the transformed data from the csv file
    return await csvFile
        .transform(utf8.decoder)
        .transform(
          // eol: end of line
          // fieldDelimiter: the delimiter of the csv file
          const CsvToListConverter(eol: '\r\n', fieldDelimiter: ';'),
        )
        .toList();
  }
}
