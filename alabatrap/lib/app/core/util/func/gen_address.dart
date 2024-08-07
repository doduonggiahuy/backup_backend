import '../../../data/models/user.dart';

String generateAddressDetail(Address? address) {
  if (address == null) return "";
  String addressDetail = "";
  if (address.detail != null) {
    addressDetail += address.detail!;
  }
  if (address.ward != null) {
    addressDetail += ", ${address.ward!}";
  }
  if (address.district != null) {
    addressDetail += ", ${address.district!}";
  }
  if (address.city != null) {
    addressDetail += ", ${address.city!}";
  }
  return addressDetail;
}
