import 'package:hive/hive.dart';
import 'package:billify/core/constants/app_constants.dart';
import 'package:billify/data/models/invoice_item_model.dart';

class InvoiceModelAdapter extends TypeAdapter<InvoiceModel> {
  @override
  final int typeId = AppConstants.invoiceTypeId;

  @override
  InvoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return InvoiceModel(
      id: fields[0] as String,
      invoiceNumber: fields[1] as String,
      clientId: fields[2] as String,
      items: (fields[3] as List).cast<InvoiceItemModel>(),
      createdAt: fields[4] as DateTime,
      dueDate: fields[5] as DateTime,
      notes: fields[6] as String,
      isPaid: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceModel obj) {
    writer.writeByte(8);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.invoiceNumber);
    writer.writeByte(2);
    writer.write(obj.clientId);
    writer.writeByte(3);
    writer.write(obj.items);
    writer.writeByte(4);
    writer.write(obj.createdAt);
    writer.writeByte(5);
    writer.write(obj.dueDate);
    writer.writeByte(6);
    writer.write(obj.notes);
    writer.writeByte(7);
    writer.write(obj.isPaid);
  }
}

class InvoiceModel {
  final String id;
  final String invoiceNumber;
  final String clientId;
  final List<InvoiceItemModel> items;
  final DateTime createdAt;
  final DateTime dueDate;
  final String notes;
  final bool isPaid;

  InvoiceModel({
    required this.id,
    required this.invoiceNumber,
    required this.clientId,
    required this.items,
    DateTime? createdAt,
    DateTime? dueDate,
    this.notes = '',
    this.isPaid = false,
  })  : createdAt = createdAt ?? DateTime.now(),
        dueDate = dueDate ?? DateTime.now().add(const Duration(days: 30));

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalBeforeTax);

  double get taxAmount => items.fold(0.0, (sum, item) => sum + item.taxAmount);

  double get totalAmount => subtotal + taxAmount;

  InvoiceModel copyWith({
    String? id,
    String? invoiceNumber,
    String? clientId,
    List<InvoiceItemModel>? items,
    DateTime? createdAt,
    DateTime? dueDate,
    String? notes,
    bool? isPaid,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      clientId: clientId ?? this.clientId,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      isPaid: isPaid ?? this.isPaid,
    );
  }
}
