document.addEventListener("DOMContentLoaded", () => {
  // 各フィールドを取得
  const nameField = document.getElementById("user_name");
  const emailField = document.getElementById("user_email");
  const passwordField = document.getElementById("user_password");
  const passwordConfirmationField = document.getElementById("user_password_confirmation");

  const validateField = (field, validations) => {
    const errorContainer = field.nextElementSibling;
    let isValid = true;
    let errorMessage = "";

    validations.forEach((validation) => {
      if (!validation.check(field.value)) {
        isValid = false;
        errorMessage = validation.message;
      }
    });

    if (isValid) {
      field.classList.remove("is-invalid");
      field.classList.add("is-valid");
      errorContainer.textContent = ""; // エラーメッセージをクリア
    } else {
      field.classList.remove("is-valid");
      field.classList.add("is-invalid");
      errorContainer.textContent = errorMessage;
    }
  };

  // 各フィールドにイベントリスナーを追加
  if (nameField) {
    nameField.addEventListener("input", () => {
      validateField(nameField, [
        { check: (value) => value.trim() !== "", message: "名前を入力してください。" },
        { check: (value) => value.length <= 20, message: "名前は20文字以内で入力してください。" },
      ]);
    });
  }

  if (emailField) {
    emailField.addEventListener("input", () => {
      validateField(emailField, [
        { check: (value) => value.trim() !== "", message: "メールアドレスを入力してください。" },
        { check: (value) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value), message: "有効なメールアドレスを入力してください。" },
      ]);
    });
  }

  if (passwordField) {
    passwordField.addEventListener("input", () => {
      validateField(passwordField, [
        { check: (value) => value.trim() !== "", message: "パスワードを入力してください。" },
        { check: (value) => value.length >= 6, message: "パスワードは6文字以上で入力してください。" },
        { check: (value) => /[a-z]/.test(value) && /[0-9]/.test(value), message: "パスワードは英数字を含む必要があります。" },
      ]);
    });
  }

  if (passwordConfirmationField) {
    passwordConfirmationField.addEventListener("input", () => {
      validateField(passwordConfirmationField, [
        {
          check: (value) => value === passwordField.value,
          message: "パスワードが一致しません。",
        },
      ]);
    });
  }
});