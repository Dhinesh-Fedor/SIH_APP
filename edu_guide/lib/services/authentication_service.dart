import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ApiService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);

      // Check for email verification before allowing login
      if (!userCredential.user!.emailVerified) {
        await _auth.signOut();
        return {
          'success': false,
          'message': 'Please verify your email address to log in.',
        };
      }

      if (userCredential.user != null) {
        return {'success': true, 'user': userCredential.user};
      } else {
        return {'success': false, 'message': 'Login failed'};
      }
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': e.message};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  Future<Map<String, dynamic>> signup(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Send email verification link after successful signup
      await userCredential.user!.sendEmailVerification();

      // Create an initial profile entry in the Realtime Database
      final uid = userCredential.user!.uid;
      final DatabaseReference userRef = FirebaseDatabase.instance.ref(
        'users/$uid',
      );
      await userRef.set({'email': email, 'createdAt': ServerValue.timestamp});

      return {'success': true, 'user': userCredential.user};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': e.message};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred'};
    }
  }

  Future<Map<String, dynamic>> logout() async {
    try {
      await _auth.signOut();
      return {'success': true};
    } catch (e) {
      return {'success': false, 'message': 'Logout failed'};
    }
  }

  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {
        'success': true,
        'message': 'Password reset email sent to $email',
      };
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': e.message};
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to send password reset email',
      };
    }
  }
}
