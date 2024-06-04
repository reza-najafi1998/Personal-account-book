int customCompare(String a, String b) {
  // اولویت رشته‌های فارسی
  if (a.contains(RegExp(r'[\u0600-\u06FF]')) &&
      !b.contains(RegExp(r'[\u0600-\u06FF]'))) {
    return -1;
  } else if (!a.contains(RegExp(r'[\u0600-\u06FF]')) &&
      b.contains(RegExp(r'[\u0600-\u06FF]'))) {
    return 1;
  }

  // اولویت رشته‌های لاتین
  if (a.contains(RegExp(r'[a-zA-Z]')) && !b.contains(RegExp(r'[a-zA-Z]'))) {
    return -1;
  } else if (!a.contains(RegExp(r'[a-zA-Z]')) &&
      b.contains(RegExp(r'[a-zA-Z]'))) {
    return 1;
  }

  // اولویت اعداد
  if (a.contains(RegExp(r'[0-9]')) && !b.contains(RegExp(r'[0-9]'))) {
    return -1;
  } else if (!a.contains(RegExp(r'[0-9]')) &&
      b.contains(RegExp(r'[0-9]'))) {
    return 1;
  }

  // در صورتی که هیچ یک از شرایط بالا برقرار نبود، از مقایسه معمولی استفاده می‌کنیم
  return a.compareTo(b);
}