import 'package:flutter/material.dart';
import 'package:english_reading_app/config/localization/string_constants.dart';

@immutable
final class HandleFirebaseAuthError {
  static String convertErrorMsg({required String errorCode}) {
    switch (errorCode) {
      case 'invalid-email':
        return StringConstants.invalidEmail;
      case 'invalid-recipient-email':
        return StringConstants.invalidRecipientEmail;
      case 'user-not-found':
        return StringConstants.userNotFound;
      case 'wrong-password':
        return StringConstants.wrongPassword;
      case 'email-already-in-use':
        return StringConstants.emailAlreadyInUse;
      case 'user-disabled':
        return StringConstants.userDisabled;
      case 'operation-not-allowed':
        return StringConstants.operationNotAllowed;
      case 'weak-password':
        return StringConstants.weakPassword;
      case 'account-exists-with-different-credential':
        return StringConstants.accountExistsWithDifferentCredential;
      case 'invalid-credential':
        return StringConstants.invalidCredential;
      case 'requires-recent-login':
        return StringConstants.requiresRecentLogin;
      case 'network-request-failed':
        return StringConstants.networkRequestFailed;
      case 'too-many-requests':
        return StringConstants.tooManyRequests;
      case 'user-token-expired':
        return StringConstants.userTokenExpired;
      case 'invalid-verification-code':
        return StringConstants.invalidVerificationCode;
      case 'invalid-verification-id':
        return StringConstants.invalidVerificationId;
      case 'quota-exceeded':
        return StringConstants.quotaExceeded;
      case 'app-not-authorized':
        return StringConstants.appNotAuthorized;
      case 'keychain-error':
        return StringConstants.keychainError;
      case 'internal-error':
        return StringConstants.internalError;
      case 'invalid-api-key':
        return StringConstants.invalidApiKey;
      case 'app-deleted':
        return StringConstants.appDeleted;
      case 'app-disabled':
        return StringConstants.appDisabled;
      case 'deleted-account':
        return StringConstants.deletedAccount;
      case 'invalid-user-token':
        return StringConstants.invalidUserToken;
      case 'user-mismatch':
        return StringConstants.userMismatch;
      case 'credential-already-in-use':
        return StringConstants.credentialAlreadyInUse;
      case 'operation-cancelled':
        return StringConstants.operationCancelled;
      case 'permission-denied':
        return StringConstants.permissionDenied;
      case 'unavailable':
        return StringConstants.unavailable;
      case 'deadline-exceeded':
        return StringConstants.deadlineExceeded;
      case 'not-found':
        return StringConstants.notFound;
      case 'already-exists':
        return StringConstants.alreadyExists;
      case 'resource-exhausted':
        return StringConstants.resourceExhausted;
      case 'failed-precondition':
        return StringConstants.failedPrecondition;
      case 'aborted':
        return StringConstants.aborted;
      case 'out-of-range':
        return StringConstants.outOfRange;
      case 'unimplemented':
        return StringConstants.unimplemented;
      case 'data-loss':
        return StringConstants.dataLoss;
      case 'unauthenticated':
        return StringConstants.unauthenticated;
      default:
        return StringConstants.unexpectedError;
    }
  }
}
