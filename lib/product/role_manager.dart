class RoleManager {
  static bool canAccessAdminPanel(String role) {
    return role == 'admin'; // Admin sadece erişebilsin
  }

  static bool canManageDepartments(String role) {
    return role == 'admin' ||
        role == 'department_head'; // Admin ve Departman Sorumlusu
  }

  static bool canManageTasks(String role) {
    return role == 'admin' ||
        role == 'department_head'; // Admin ve Departman Sorumlusu
  }

  static bool canViewEmployeeProfile(String role) {
    return role == 'admin' ||
        role == 'department_head' ||
        role == 'employee'; // Tüm kullanıcılar görebilsin
  }
}
