import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../constants/env/env_constants.dart';
import '../../constants/request_constants/request_constants.dart';
import '../../constants/request_constants/request_constants_endpoints.dart';
import '../service/env_service.dart';

part 'app_api.g.dart';

@RestApi()
abstract class AppService {
  factory AppService(Dio dio) {
    return _AppService(
      dio,
      baseUrl: EnvService.getString(
        key: EnvConstants.apiUrl,
      ),
    );
  }

  // Login Request
  // @POST(RequestConstantsEndpoints.login)
  // Future<LoginResponse> login(
  //   @Field(RequestConstants.email) String email,
  //   @Field(RequestConstants.password) String password,
  // );
}
