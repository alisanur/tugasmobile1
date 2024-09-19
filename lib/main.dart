import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulir Pendaftaran',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  String nama = '';
  String tanggalLahir = '';
  String agama = '';
  String jenisKelamin = '';
  String alamat = '';

  List<String> agamaList = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Buddha',
    'Konghucu'
  ];
  List<String> jenisKelaminList = ['Laki-laki', 'Perempuan'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulir Pendaftaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'Formulir Pendaftaran',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi nama Anda';
                  }
                  return null;
                },
                onSaved: (value) {
                  nama = value!;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Lahir (DD-MM-YYYY)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi tanggal lahir Anda';
                  }
                  // Tambahkan validasi format tanggal jika diperlukan
                  return null;
                },
                onSaved: (value) {
                  tanggalLahir = value!;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Agama',
                  border: OutlineInputBorder(),
                ),
                items: agamaList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    agama = value!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon pilih agama Anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Jenis Kelamin'),
              ...jenisKelaminList.map((String value) {
                return RadioListTile<String>(
                  title: Text(value),
                  value: value,
                  groupValue: jenisKelamin,
                  onChanged: (newValue) {
                    setState(() {
                      jenisKelamin = newValue!;
                    });
                  },
                );
              }),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Alamat',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi alamat Anda';
                  }
                  return null;
                },
                onSaved: (value) {
                  alamat = value!;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      jenisKelamin.isNotEmpty) {
                    _formKey.currentState!.save();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          nama: nama,
                          tanggalLahir: tanggalLahir,
                          agama: agama,
                          jenisKelamin: jenisKelamin,
                          alamat: alamat,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Mohon lengkapi semua field')),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultPage extends StatelessWidget {
  final String nama;
  final String tanggalLahir;
  final String agama;
  final String jenisKelamin;
  final String alamat;

  const ResultPage({
    super.key,
    required this.nama,
    required this.tanggalLahir,
    required this.agama,
    required this.jenisKelamin,
    required this.alamat,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Pendaftaran'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildInfoRow('Nama', nama),
              _buildInfoRow('Tanggal Lahir', tanggalLahir),
              _buildInfoRow('Agama', agama),
              _buildInfoRow('Jenis Kelamin', jenisKelamin),
              _buildInfoRow('Alamat', alamat),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
