class Endpoints {
  Endpoints._();

  // static const loginUser = '/Auth/user/login?Email=sha%40gmail.com&Password=Flutter%401';
  static const loginUser = '/Auth/user/login';
  static const signupUser = '/Auth/u/r/Signup';
  static const loginWithGoogle = '/Auth/u/login/GoogleAuth';
  static const sigInWithGoogle = '/Auth/r/GoogleAuth';
  static const switchRoles = '/Auth/swap-role';

  static const forgotPassword = '/Auth/u/ForgetPassword';
  static const otpVerification = '/Auth/otpverification';
  static const resetPassword = '/Auth/u/ResetPassword';
  static const resendPassword = '/Auth/resend-otp';
  static const registerDeviceToken = '/OnDemand/teacher/registerDeviceToken';

  static const logout = '/auth/logout';
  static const chronicList = '/GetChronicCond';
  static const physicalList = '/GetPhysicalCond';
  static const saveStudentProileData = '/SaveDetProfStd';

  static const selectRole = '/Auth/select-role';

  static const getAllPoses = '/Pose/GetAll';
  static const getPoseDetails = '/Pose/GetPoseDetails';
  static const getAllYogaStyles = '/Style/GetAll';
  static const getStyleDetails = '/Style/GetStyleDetails';
  static const getTopRatedTeachers = '/GetTopRatedTeacher';
  static const getPreviousTeachers = '/MyPreviousTeachersOnUserId';
  static const changeOnlineStatusForTeacher = '/ChangeOnlineStatusForTeacher';
  static const getOnlineStatusForTeacher = '/checkOnline';
  static const getTeacherSchedule = '/GetTeacherDetailSchedule';
  static const preBookingSession = '/session/pre-booking';

  static const signupTeacher = '/RegisterTeacher';
  static const teacherDetailInfo = '/TeacherDetailInfo';

  static const guide = '/Guide/GetGuideData';

  static const guideDetail = '/Guide/GetDetails';

  static const onDemandOnlineTeachers = '/OnDemand/on-demand-teacher';
  static const onDemandOnlineTeachersBySearch =
      '/OnDemand/OnDemandAdvanceSearch';
  static const onDemandStudentBooking = '/OnDemand/OnDemandBooking';
  static const teacherResponseToBookSession = '/TeacherBooking/accept-booking';
  static const bookingAcceptedRejected = '/session/BookingAcceptedOrNot';
  static const getBookingofStudents = '/session/GetbookingByTeacherId/All';

  static const myClassesStudent = '/MyClasses/student-get';
  static const myClassesTeacher = '/MyClasses/teacher-get';
  static const upComingClassesHome = '/MyClasses/upcoming-class';
  static const getNoOfSessions = '/static-api';
  static const cancelBooking = '/TeacherBooking/cancel-booking';
  static const acceptBooking = '/TeacherBooking/accept-booking';
  static const rescheduleBooking = '/MyClasses/Booking/ReSchdule/new';
  static const rescheduleTeacherDetails = '/MyClasses/Booking/ForReschdule';

  static const addSchedule = '/t/AddSchedule';

  static const stdChangePasswd = '/Auth/u/req/ChangePassword';
  static const deleteAccountStudent = '/Auth/user-delete';
  static const deleteAccountTeacher = '/Auth/teacher-delete';

  static const learnMossYogaData = '/HelpAndSupport/Get_LearnMossYoga';
  static const faqs = '/HelpAndSupport/Get_FAQs';
  static const feedback = '/Auth/send-feedback';

  static const studentPtofileDetails = '/GetDetailProfileOfStd';
  static const updateStudentPtofileDetails = '/student-update';

  static const teacherPtofileDetails = '/GetTeacherProfile';
  static const updateTeacherPtofileDetails = '/UpdateTeacherProfile';

  //STATic
  static const youMayLike = '/static/you-may-also-like';

  ///Static intents
  static const paymentIntent = '/Payment/create-payment-intent';
  static const capturePayment = '/Payment/capture-payment';

  //Notification
  static const notification = '/Notification/GetByUser';

  //Total Earning
  static const totalEarningTeacher = '/TotalEarning';
}
