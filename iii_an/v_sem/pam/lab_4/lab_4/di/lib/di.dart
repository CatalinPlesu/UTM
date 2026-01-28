import 'package:di/data_injection_container.dart';
import 'package:di/domain_injection_container.dart';

Future initDi() async {
  await initData();
  await initDomain();
}