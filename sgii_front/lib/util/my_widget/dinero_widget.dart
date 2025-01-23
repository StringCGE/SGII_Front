import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sgii_front/util/common/mi_formato.dart';

class DineroWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String currencyText;
  final String? Function(String?)? validator;
  final bool readOnly;

  DineroWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.currencyText,
    required this.validator,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            readOnly: readOnly,
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              prefixText: '$currencyText  ',
              prefixStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.grey),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              MiFormateador(r'^\d+([.,]\d{0,2})?$'),
            ],
            validator: validator,
          ),
        ],
      ),
    );
  }
}


class LineDineroWidget extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final double labelWidth;
  final String currencyText;
  final bool readOnly;

  LineDineroWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.currencyText,
    this.labelWidth = 100,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    String pattern =  r'^\d+([.,]\d{0,2})?$';

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.cyan[50],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              labelText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 30,
              child: TextFormField(
                readOnly: readOnly,
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  prefixText: '$currencyText  ',
                  prefixStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 3,
                    horizontal: 8,
                  ),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  MiFormateador(pattern),
                ],
                validator: validator,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}






class GroupWidget extends StatelessWidget {
  final String labelText;
  final List<Widget> children;

  GroupWidget({
    super.key,
    required this.labelText,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.cyan[50],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(labelText != '')Text(
            labelText,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if(labelText != '')const SizedBox(height: 8),
          Column(
            children: children,
          ),
        ],
      ),
    );
  }
}


