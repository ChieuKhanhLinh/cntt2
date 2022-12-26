mixin CommonValidation {
  // Login validation
  String? validateLoginEmail(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng điền email của bạn!';
    }
    if (!value.contains('@') || !value.contains('.com')) {
      return 'Email không hợp lệ. Vui lòng thử lại';
    }
    return null;
  }

  String? validateLoginPassword(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập mật khẩu của bạn!';
    }
    return null;
  }

  // Sign up validation
  String? validateSignUpName(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập tên của bạn!';
    }
    return null;
  }

  String? validateSignUpEmail(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập địa chỉ email của bạn!';
    }
    if (!value.contains('@') || !value.contains('.com')) {
      return 'Email không hợp lệ! Vui lòng thử lại.';
    }
    return null;
  }

  String? validateSignUpPhone(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập số điện thoại của bạn';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Số điện thoại không hợp lệ. Vui lòng thử lại.';
    }
    return null;
  }

  String? validateSignUpPassword(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập mật khẩu.';
    }
    if (value.length < 6) {
      return 'Mật khẩu cần ít nhất 6 kí tự.';
    }
    return null;
  }

  String? validateEditOldPassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your old password';
    }
    return null;
  }

  String? validateEditNewPassword(String? value) {
    if (value!.isEmpty) {
      return 'Please enter your new password';
    }
    return null;
  }

  String? validateEditConfirmPassWord(String? value) {
    if (value!.isEmpty) {
      return 'Vui lòng nhập mật khẩu của bạn để xác nhận.';
    }
    return null;
  }
}
