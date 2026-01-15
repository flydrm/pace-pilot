import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinEntryRequest {
  const PinEntryRequest({
    required this.title,
    required this.primaryLabel,
    this.secondaryLabel,
    this.requireConfirmation = false,
    this.hintText = '6 位数字（允许 0 开头）',
  });

  final String title;
  final String primaryLabel;
  final String? secondaryLabel;
  final bool requireConfirmation;
  final String hintText;
}

class PinEntrySheet extends StatefulWidget {
  const PinEntrySheet({super.key, required this.request});

  final PinEntryRequest request;

  @override
  State<PinEntrySheet> createState() => _PinEntrySheetState();
}

class _PinEntrySheetState extends State<PinEntrySheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _pinController;
  late final TextEditingController _confirmController;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    _confirmController = TextEditingController();
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                request.title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                request.hintText,
                style: const TextStyle(color: Colors.black54),
              ),
              if (request.requireConfirmation) ...[
                const SizedBox(height: 4),
                const Text(
                  '提示：PIN 丢失将无法恢复，请务必记住。',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                textInputAction:
                    request.requireConfirmation ? TextInputAction.next : TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                obscureText: true,
                decoration: InputDecoration(
                  labelText: request.primaryLabel,
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => _validatePin(v),
              ),
              if (request.requireConfirmation) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _confirmController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6),
                  ],
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: request.secondaryLabel ?? '再次输入 PIN',
                    border: const OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final base = _validatePin(v);
                    if (base != null) return base;
                    if (_pinController.text != _confirmController.text) {
                      return '两次 PIN 不一致';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop<String?>(null),
                      child: const Text('取消'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(
                      onPressed: _submit,
                      child: const Text('确定'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(_pinController.text);
  }

  String? _validatePin(String? value) {
    final v = (value ?? '').trim();
    if (!RegExp(r'^[0-9]{6}$').hasMatch(v)) return 'PIN 必须是恰好 6 位数字';
    return null;
  }
}

