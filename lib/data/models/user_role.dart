enum UserRole {
  Teacher,
  Student,
  None,
  Both,
}

class UserRoleModel {
  final UserRole userRole;

  UserRoleModel({required this.userRole});
}
