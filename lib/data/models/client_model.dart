import 'package:hive/hive.dart';
import 'package:billify/core/constants/app_constants.dart';

class ClientModelAdapter extends TypeAdapter<ClientModel> {
  @override
  final int typeId = AppConstants.clientTypeId;

  @override
  ClientModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (int i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return ClientModel(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String,
      phone: fields[3] as String,
      address: fields[4] as String,
      gstNumber: fields[5] as String,
      createdAt: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ClientModel obj) {
    writer.writeByte(7);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.name);
    writer.writeByte(2);
    writer.write(obj.email);
    writer.writeByte(3);
    writer.write(obj.phone);
    writer.writeByte(4);
    writer.write(obj.address);
    writer.writeByte(5);
    writer.write(obj.gstNumber);
    writer.writeByte(6);
    writer.write(obj.createdAt);
  }
}

class ClientModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String gstNumber;
  final DateTime createdAt;

  ClientModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.gstNumber = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  ClientModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? gstNumber,
    DateTime? createdAt,
  }) {
    return ClientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      gstNumber: gstNumber ?? this.gstNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
