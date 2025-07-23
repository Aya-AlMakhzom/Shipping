import 'package:flutter/material.dart';
import '../model/QuestionModel.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) getLabel;
  final IconData? Function(T)? getIcon;
  final ValueChanged<T?> onChanged;
  final bool isError;

  const CustomDropdownFormField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.getLabel,
    required this.onChanged,
    this.getIcon,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        border: Border.all(
          color: isError ? Colors.redAccent.shade100 : Colors.transparent,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<T>(
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isError ? Colors.redAccent.shade100 : Color(0xFF334EAC)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        isExpanded: true,
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF334EAC)),
        items: items.map((item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Row(
              children: [
                if (getIcon != null && getIcon!(item) != null) ...[
                  Icon(getIcon!(item), color: const Color(0xFF334EAC)),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    getLabel(item),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: onChanged,
        menuMaxHeight: 184,
      ),
    );
  }
}

class CustomCheckboxGroup extends StatelessWidget {
  final String label;
  final List<OptionModel> options;
  final List<int> selectedIds;
  final ValueChanged<List<int>> onChanged;

  const CustomCheckboxGroup({
    super.key,
    required this.label,
    required this.options,
    required this.selectedIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ...options.map((opt) => CheckboxListTile(
          activeColor:Color(0xFF334EAC) ,
              value: selectedIds.contains(opt.id),
              title: Text(opt.value),
              onChanged: (checked) {
                final newList = List<int>.from(selectedIds);
                if (checked == true) {
                  newList.add(opt.id);
                } else {
                  newList.remove(opt.id);
                }
                onChanged(newList);
              },
            ))
      ],
    );
  }
}

Widget buildQuestionField({
  required QuestionModel q,
  required dynamic answer,
  required Function(dynamic) onChanged,
}) {
  switch (q.type) {
    case 'select':
      return CustomDropdownFormField<int>(
        label: q.question,
        value: answer as int?,
        items: q.options.map((e) => e.id).toList(),
        getLabel: (id) => q.options.firstWhere((o) => o.id == id).value,
        onChanged: onChanged,
      );
    case 'radio':
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(q.question, style: const TextStyle(fontWeight: FontWeight.bold)),
          ...q.options.map((opt) => RadioListTile<int>(
               activeColor: Color(0xFF334EAC),
                value: opt.id,
                groupValue: answer as int?,
                title: Text(opt.value),
                onChanged: onChanged,
              ))
        ],
      );
    case 'checkbox':
      return CustomCheckboxGroup(
        label: q.question,
        options: q.options,
        selectedIds: (answer as List<int>? ?? []),
        onChanged: onChanged,
      );
    case 'text':
    default:
      return TextFormField(
        decoration: InputDecoration(
          labelText: q.question,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        initialValue: answer as String? ?? '',
        onChanged: onChanged,
      );
  }
}
