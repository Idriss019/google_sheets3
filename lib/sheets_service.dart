import 'dart:convert';
import 'dart:io';
import 'package:gsheets/gsheets.dart';

class SheetsService {
  static String? _spreadsheetId;
  static GSheets? _gsheets;
  static Spreadsheet? _spreadsheet;

  static Future<void> init() async {
    try {
      _spreadsheetId = await File('assets/googleSheetId.txt').readAsString();
      if (_spreadsheetId == null) {
        throw Exception('SPREADSHEET_ID не найден в переменных окружения!');
      }
    } catch (e) {
      print('Ошибка получения SPREADSHEET_ID: $e');
      rethrow;
    }
    try {
      final jsonString = await File('assets/credentials.json').readAsString();
      final credentials = jsonDecode(jsonString);
      _gsheets = GSheets(credentials);
      _spreadsheet = await _gsheets!.spreadsheet(_spreadsheetId!.trim());
    } catch (e) {
      print('Ошибка инициализации SheetsService: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, String>>> getData() async {
    if (_spreadsheet == null) {
      throw Exception(
        'SheetsService не инициализирован. Вызовите SheetsService.init() перед использованием getData()',
      );
    }
    const sheetName = 'Лист1';
    final sheet = _spreadsheet!.worksheetByTitle(sheetName);
    if (sheet == null) {
      throw Exception('Страница "$sheetName" не найдена в таблице!');
    }
    final data = await sheet.values.map.allRows();
    return data ?? [];
  }
}
