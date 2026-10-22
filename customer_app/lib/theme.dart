import 'package:flutter/material.dart';

/// Meeloc design tokens (same as the UI design).
class MC {
  static const green = Color(0xFF16A34A);
  static const greenDark = Color(0xFF0F8A3C);
  static const teal = Color(0xFF13A57A);
  static const orange = Color(0xFFF97316);
  static const red = Color(0xFFEF4444);
  static const blue = Color(0xFF1E6FE8);
  static const navy = Color(0xFF1E3A8A);
  static const star = Color(0xFFF5A623);
  static const text = Color(0xFF111827);
  static const sub = Color(0xFF6B7280);
  static const line = Color(0xFFE5E7EB);
  static const bg = Color(0xFFF7F8FA);
  static const field = Color(0xFFF1F3F6);
  static const adminNavy = Color(0xFF12324A);
}

ThemeData meelocTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: MC.green, primary: MC.green),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        foregroundColor: MC.text,
        titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: MC.text),
      ),
    );

/// Grey rounded search bar. With [onTap] it acts as a button (opens search page).
class MSearchBar extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool autofocus;
  const MSearchBar({super.key, required this.hint, this.onTap, this.onChanged, this.controller, this.autofocus = false});
  @override
  Widget build(BuildContext context) => Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(color: MC.field, borderRadius: BorderRadius.circular(12)),
        child: Row(children: [
          const Icon(Icons.search, size: 20, color: MC.sub),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: autofocus,
              readOnly: onTap != null,
              onTap: onTap,
              onChanged: onChanged,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(fontSize: 13, color: MC.sub),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ]),
      );
}

/// Full width green button.
class MPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color color;
  const MPrimaryButton({super.key, required this.label, this.onTap, this.color = MC.green});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onTap ?? () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ),
      );
}

/// Full width outlined button.
class MOutlineButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  const MOutlineButton({super.key, required this.label, this.icon, this.onTap});
  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton(
          onPressed: onTap ?? () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: MC.text,
            side: const BorderSide(color: MC.line),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (icon != null) ...[Icon(icon, size: 20), const SizedBox(width: 8)],
            Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
          ]),
        ),
      );
}

/// Menu row with leading icon, title, optional red badge and chevron.
class MMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final int? badge;
  final VoidCallback? onTap;
  const MMenuTile({super.key, required this.icon, required this.title, this.badge, this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap ?? () => mSnack(context, title),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: MC.line))),
          child: Row(children: [
            Icon(icon, size: 21, color: MC.text),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15, color: MC.text))),
            if (badge != null)
              Container(
                width: 22,
                height: 22,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: MC.red, shape: BoxShape.circle),
                child: Text('$badge', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              )
            else
              const Icon(Icons.chevron_right, color: MC.sub),
          ]),
        ),
      );
}

/// Rounded logo square used for Meeloc Business / Partner / Admin.
class MLogo extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  const MLogo({super.key, this.icon = Icons.storefront, this.color = MC.green, this.size = 30});
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(size * .28)),
        child: Icon(icon, color: Colors.white, size: size * .62),
      );
}

void mSnack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg), duration: const Duration(seconds: 1)));
}

/// Simple empty state.
class MEmpty extends StatelessWidget {
  final IconData icon;
  final String text;
  const MEmpty({super.key, required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 70),
        child: Column(children: [
          Icon(icon, size: 60, color: MC.line),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(color: MC.sub)),
        ]),
      );
}

/// Labeled outlined text field used in forms.
class MField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final int maxLines;
  final String? hint;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;
  const MField({
    super.key,
    required this.label,
    required this.controller,
    this.keyboard,
    this.maxLines = 1,
    this.hint,
    this.suffix,
    this.readOnly = false,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboard,
            maxLines: maxLines,
            readOnly: readOnly,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: hint,
              isDense: true,
              suffixIcon: suffix,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: MC.line)),
            ),
          ),
        ]),
      );
}

Future<bool> mConfirm(BuildContext context, String title, String msg, {String ok = 'Yes'}) async {
  final r = await showDialog<bool>(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [
        TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.pop(c, true), child: Text(ok)),
      ],
    ),
  );
  return r ?? false;
}
