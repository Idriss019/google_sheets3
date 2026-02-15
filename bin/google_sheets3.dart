import 'package:google_sheets3/sheets_service.dart';

void main(List<String> arguments) async{
  await SheetsService.init();
  final sheetData = await SheetsService.getData();
  sheetData.forEach((row) {
    print(row['имя']);
  });
}
