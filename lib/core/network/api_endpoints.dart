class ApiEndpoints {
  // Base URL for AayupOnes HRMS Backend / Admin Panel
  static const String baseUrl = 'https://api.hrms.aayup.com/api/v1';

  // Auth & Employee
  static const String login = '$baseUrl/auth/login';
  static const String verifyToken = '$baseUrl/auth/verify';
  static const String userProfile = '$baseUrl/employee/profile';
  static const String changePassword = '$baseUrl/employee/change-password';

  // Attendance & Time
  static const String punchIn = '$baseUrl/attendance/punch-in';
  static const String punchOut = '$baseUrl/attendance/punch-out';
  static const String attendanceLogs = '$baseUrl/attendance/logs';
  static const String shiftRoster = '$baseUrl/attendance/roster';
  static const String regularization = '$baseUrl/attendance/regularize';

  // Leaves & Holidays
  static const String leaveBalances = '$baseUrl/leave/balances';
  static const String applyLeave = '$baseUrl/leave/apply';
  static const String leaveHistory = '$baseUrl/leave/history';
  static const String holidayList = '$baseUrl/company/holidays';

  // Work & Timesheets
  static const String myTasks = '$baseUrl/work/tasks';
  static const String logTimesheet = '$baseUrl/work/log-timesheet';

  // Payroll & Claims
  static const String payslips = '$baseUrl/payroll/payslips';
  static const String downloadPayslip = '$baseUrl/payroll/download';
  static const String expenseClaims = '$baseUrl/claims/expenses';
  static const String submitClaim = '$baseUrl/claims/submit';

  // Manager Approvals
  static const String managerPendingApprovals = '$baseUrl/manager/pending-approvals';
  static const String managerAction = '$baseUrl/manager/action';
  static const String teamAttendance = '$baseUrl/manager/team-attendance';

  // Support
  static const String helpdeskTickets = '$baseUrl/helpdesk/tickets';
  static const String createTicket = '$baseUrl/helpdesk/create';
  static const String companyDirectory = '$baseUrl/company/directory';
}
