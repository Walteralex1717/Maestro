import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:math';

void main() {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String gender = '';
  String? username;
  String password = '';

  // Step 1: Registration Process
  print("Registration Process:");

  // Input First and Last Name with Validation
  firstName = getInput("Enter your first name:", validateName);
  lastName = getInput("Enter your last name:", validateName);

  // Gender Selection with Input Validation
  gender = selectGender();

  // Input Email with Validation
  email = getInput("Enter your email:", validateEmail);

  // Input Phone Number with Validation
  phoneNumber = getInput("Enter your phone number:", validatePhoneNumber);

  // Input Username with Validation
  username = getInput("Create your username:", validateUsername);

  // Input Password and Confirm Password with Hashing
  password = createAndConfirmPassword();

  // Simulate Email Verification
  print("\nA verification email has been sent to $email. Please verify your email to complete registration.");
  print("Type 'verified' to simulate email verification:");
  String? emailVerification = stdin.readLineSync();
  
  if (emailVerification != 'verified') {
    print("Email verification failed. Registration aborted.");
    exit(0);
  }

  print("\nCongratulations, you're successfully registered!");
  print("Name: $firstName $lastName");
  print("Gender: $gender");
  print("Email: $email");
  print("Phone Number: $phoneNumber");
  print("Username: $username");

  // Step 2: Login Page
  while (true) {
    print("\nLogin Page:");
    String? loginUsername = getInput("Enter your username:", validateNonEmpty);
    String? loginPassword = getInput("Enter your password:", validateNonEmpty);

    if (loginUsername == username && hashPassword(loginPassword!) == hashPassword(password)) {
      print("Login successful! Welcome, $username.");
      break;
    } else {
      print("Invalid username or password. Please try again.");

      // Password Reset Option
      if (offerPasswordReset(email, phoneNumber)) {
        password = createAndConfirmPassword();
        print("Password reset successful. You can now log in with your new password.");
      }
    }
  }
}

// Utility Functions

// Function to get validated input
String? getInput(String prompt, Function validator) {
  while (true) {
    print(prompt);
    String? input = stdin.readLineSync();
    if (validator(input)) {
      return input;
    } else {
      print("Invalid input. Please try again.");
    }
  }
}

// Name Validation
bool validateName(String? name) {
  return name != null && name.isNotEmpty && RegExp(r'^[a-zA-Z]+$').hasMatch(name);
}

// Gender Selection
String selectGender() {
  for (int i = 0; i < 3; i++) {
    print("Select your gender: (Type 1 for Male, 2 for Female)");
    String? genderChoice = stdin.readLineSync();

    if (genderChoice == '1') {
      return "Male";
    } else if (genderChoice == '2') {
      return "Female";
    } else {
      if (i < 2) {
        print("Invalid choice. Please select either 1 for Male or 2 for Female.");
      } else {
        print("Too many invalid attempts. Registration aborted.");
        exit(0);
      }
    }
  }
  return ''; // This line should never be reached
}

// Email Validation
bool validateEmail(String? email) {
  return email != null &&
      email.isNotEmpty &&
      RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(email);
}

// Phone Number Validation
bool validatePhoneNumber(String? phone) {
  return phone != null &&
      phone.isNotEmpty &&
      RegExp(r'^\d{10}$').hasMatch(phone); // Assuming 10-digit phone number
}

// Username Validation
bool validateUsername(String? username) {
  return username != null &&
      username.isNotEmpty &&
      username.length >= 3 &&
      RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username);
}

// Password Creation and Confirmation with Strong Hashing
String createAndConfirmPassword() {
  while (true) {
    String? tempPassword = getInput("Create your password (min 8 characters, including upper/lowercase, number, and special character):", validatePassword);

    print("Confirm your password:");
    String? confirmPassword = stdin.readLineSync();

    if (tempPassword == confirmPassword) {
      return tempPassword!;
    } else {
      print("Passwords do not match. Please try again.");
    }
  }
}

// Password Validation
bool validatePassword(String? password) {
  return password != null &&
      password.length >= 8 &&
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$')
          .hasMatch(password);
}

// Hashing Passwords using SHA-256 (Simulating stronger hashing)
String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

// Password Reset Option
bool offerPasswordReset(String? registeredEmail, String? registeredPhone) {
  print("Forgot your password? (yes/no)");
  String? resetChoice = stdin.readLineSync();

  if (resetChoice != null && resetChoice.toLowerCase() == 'yes') {
    print("Please provide your registered email or phone number to reset your password:");
    String? contactInfo = stdin.readLineSync();

    if (contactInfo == registeredEmail || contactInfo == registeredPhone) {
      return true;
    } else {
      print("The email or phone number provided does not match our records. Password reset denied.");
    }
  }
  return false;
}

// Non-Empty Input Validation
bool validateNonEmpty(String? input) {
  return input != null && input.isNotEmpty;
}
