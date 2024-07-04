enum StateType {
  initial,
  loading,
  error,
  success,
  getOtp,
  showOtpBottomSheet,
  showOtpBottomSheetForgetPass,
  closeOtpSheet,
  showSnackBar,
  navigate,
  closeAndPerformTask,
  closeBottomSheet,
  showEnableAutoInvestmentBottomSheet,
  closeEnableAutoInvestmentBottomSheet,
  markOpportunityAsFav,
  investmentSaved,
  downloadingDoc,
  downloadingDocDone,
  navigateBackToSettings,
  showReactivationBottomSheet,
  closeReactivationBottomSheet,
  userBlocked,
  askForAppUpdate,
  deviceJailBreak,
  vpnConnected
}

enum ErrorType {
  inline,
  dialog,
  other,
  unauthorized,
  none,
  markOppAsFavError,
  userBlocked,
}

enum RouterType { go, push, pop }

class RouterState<T> {
  RouterState({
    required this.routerType,
    required this.pagePath,
    this.extra,
    this.message,
  });

  final RouterType routerType;
  final String pagePath;
  T? extra;
  dynamic message;
}

class ScreenState<T> {
  ScreenState({
    this.data,
    this.error,
    this.showOtpSheet = false,
    required this.stateType,
    this.errorType = ErrorType.none,
  });

  ScreenState.initial()
      : stateType = StateType.initial,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.navigate(this.data)
      : stateType = StateType.navigate,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.closeOtpSheet()
      : stateType = StateType.closeOtpSheet,
        showOtpSheet = false,
        errorType = ErrorType.none;

  ScreenState.closeBottomSheet()
      : stateType = StateType.closeBottomSheet,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.closeAndPerformTask()
      : stateType = StateType.closeAndPerformTask,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.loading()
      : stateType = StateType.loading,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.success(this.data, {this.showOtpSheet})
      : stateType = StateType.success,
        errorType = ErrorType.none;
  ScreenState.showOtpBottomSheet({this.showOtpSheet})
      : stateType = StateType.showOtpBottomSheet,
        errorType = ErrorType.none;
  ScreenState.showOtpBottomSheetForgetPass({this.showOtpSheet})
      : stateType = StateType.showOtpBottomSheet,
        errorType = ErrorType.none;
  ScreenState.getOtp()
      : stateType = StateType.getOtp,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.error(this.error, this.errorType)
      : stateType = StateType.error,
        showOtpSheet = false;
  ScreenState.unathorized()
      : stateType = StateType.error,
        showOtpSheet = false,
        errorType = ErrorType.unauthorized;
  ScreenState.markOppoAsFav()
      : stateType = StateType.markOpportunityAsFav,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.investmentSaved()
      : stateType = StateType.investmentSaved,
        showOtpSheet = false,
        errorType = ErrorType.none;

  ScreenState.showAutoInvestmentSheet()
      : stateType = StateType.showEnableAutoInvestmentBottomSheet,
        showOtpSheet = true,
        errorType = ErrorType.none;
  ScreenState.closeAutoInvestmentSheet()
      : stateType = StateType.closeEnableAutoInvestmentBottomSheet,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.showAccountReactivationSheet()
      : stateType = StateType.showReactivationBottomSheet,
        showOtpSheet = true,
        errorType = ErrorType.none;
  ScreenState.closeAccountReactivationSheet()
      : stateType = StateType.closeReactivationBottomSheet,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.downloadingDoc()
      : stateType = StateType.downloadingDoc,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.downloadingDocDone()
      : stateType = StateType.downloadingDocDone,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.showSnackBarError(this.error, this.errorType)
      : stateType = StateType.showSnackBar,
        showOtpSheet = false;
  ScreenState.navigateBackToSettings()
      : stateType = StateType.navigateBackToSettings,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.askForAppUpdate()
      : stateType = StateType.askForAppUpdate,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.deviceJailBreak()
      : stateType = StateType.deviceJailBreak,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.vpnConnected()
      : stateType = StateType.vpnConnected,
        showOtpSheet = false,
        errorType = ErrorType.none;
  ScreenState.userBlocked(
      this.error,
      this.errorType,
      )   : stateType = StateType.userBlocked,
        showOtpSheet = false;

  final StateType stateType;
  final ErrorType errorType;
  final bool? showOtpSheet;

  T? data;
  dynamic error;
}
