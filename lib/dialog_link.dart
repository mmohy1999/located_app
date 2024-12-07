import 'package:flutter/material.dart';

class DialogLink extends StatelessWidget {
   DialogLink({super.key});
   final _formKey = GlobalKey<FormState>();
   final TextEditingController _linkController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Get Postilion From Google Link',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                const SizedBox(height: 3),
                const Text('⚠ Not Support Short Link',style: TextStyle(fontSize: 14),),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _linkController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(labelText: 'Url'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'URl is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        Navigator.of(context).pop(_linkController.text);
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
