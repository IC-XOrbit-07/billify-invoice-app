import 'package:hive/hive.dart';
import 'package:billify/core/constants/app_constants.dart';

class InvoiceItemModelAdapter extends TypeAdapter<InvoiceItemModel> {
  @override
  final int typeId = AppConstants.invoiceItemTypeId;

  @override
  InvoiceItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return InvoiceItemModel(
      name: fields[0] as String,
      quantity: fields[1] as int,
      unitPrice: fields[2] as double,
      taxRate: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceItemModel obj) {
    writer.writeByte(4);
    writer.writeByte(0);
    writer.write(obj.name);
    writer.writeByte(1);
    writer.write(obj.quantity);
    writer.writeByte(2);
    writer.write(obj.unitPrice);
    writer.writeByte(3);
    writer.write(obj.taxRate);
  }
}

class InvoiceItemModel {
  final String name;
  final int quantity;
  final double unitPrice;
  final double taxRate;

  InvoiceItemModel({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.taxRate = 18.0,
  });

  double get totalBeforeTax => quantity * unitPrice;
  double get taxAmount => totalBeforeTax * (taxRate / 100);
  double get totalAmount => totalBeforeTax + taxAmount;

  InvoiceItemModel copyWith({
    String? name,
    int? quantity,
    double? unitPrice,
    double? taxRate,
  }) {
    return InvoiceItemModel(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      taxRate: taxRate ?? this.taxRate,
    );
  }
}
