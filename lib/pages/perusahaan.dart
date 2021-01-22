import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PerusahaanPage extends StatefulWidget {
  final String title;
  final String alamat;
  final String deskripsi;
  final String posisi;
  final String website;
  final String persyaratan;
  final String url;

  PerusahaanPage(
      {this.title,
      this.alamat,
      this.posisi,
      this.website,
      this.persyaratan,
      this.deskripsi,
      this.url});

  @override
  _PerusahaanPageState createState() => _PerusahaanPageState();
}

class _PerusahaanPageState extends State<PerusahaanPage> {
  String _website;

  @override
  initState() {
    setWebsiteURI();
    super.initState();
  }

  void setWebsiteURI() {
    setState(() {
      _website = widget.website;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      child: Image.network(
                        widget.url,
                        fit: BoxFit.cover,
                      ),
                    ),
                    ListTile(
                      title: Text(
                        widget.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        widget.deskripsi,
                      ),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('Alamat'),
                      subtitle: Text(widget.alamat),
                    ),
                  ],
                ),
              ),
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('Persyaratan'),
                      subtitle: Text(widget.persyaratan),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setWebsiteURI();
                    _launchURL();
                  },
                  child: Text('Kunjungi Website'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    final url = _website;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
