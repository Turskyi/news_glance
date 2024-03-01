import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:news_glance/di/injector.config.dart';

@InjectableInit(initializerName: 'initDependencyInjection')
void injectDependencies() => GetIt.I.initDependencyInjection();
