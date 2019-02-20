import 'package:json_annotation/json_annotation.dart';
import '../interface/JsonObject.dart';
import 'Product.dart';

part 'ProductResult.g.dart';

@JsonSerializable()
class ProductResult extends JsonObject {

  final int status;
  @JsonKey(name: "code", nullable: false)
  final String barcode;
  @JsonKey(name: "status_verbose")
  final String statusVerbose;
  final Product product;

  const ProductResult({
    this.status,
    this.barcode,
    this.statusVerbose,
    this.product
  });

  factory ProductResult.fromJson(Map<String, dynamic> json) => _$ProductResultFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ProductResultToJson(this);
}
