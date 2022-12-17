import 'package:email_auth/email_auth.dart';

class OtpManager{

  static EmailAuth _emailAuth =  EmailAuth(
  sessionName: "Sample session",
  );

/// Configuring the remote server


/// a void function to verify if the Data provided is true
/// Convert it into a boolean function to match your needs.
  static bool verify(String email,String otp) {
 return  _emailAuth.validateOtp(
      recipientMail: email,
      userOtp: otp);
}

/// a void funtion to send the OTP to the user
/// Can also be converted into a Boolean function and render accordingly for providers
  static void sendOtp(String email) async {
  bool result = await _emailAuth.sendOtp(
      recipientMail: email, otpLength: 5);
}


}