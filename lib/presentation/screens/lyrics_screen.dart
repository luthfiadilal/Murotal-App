import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/surah_detail/surah_detail_bloc.dart';
import '../blocs/surah_detail/surah_detail_state.dart';

class LyricsScreen extends StatelessWidget {
  const LyricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF013226),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 32),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Lirik (Ayat)', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: BlocBuilder<SurahDetailBloc, SurahDetailState>(
        builder: (context, state) {
          if (state is SurahDetailLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFD3AA58)));
          } else if (state is SurahDetailError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          } else if (state is SurahDetailLoaded) {
            final ayahs = state.surah.ayahs;
            if (ayahs == null || ayahs.isEmpty) {
              return const Center(child: Text('Tidak ada lirik / ayat.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: ayahs.length,
              itemBuilder: (context, index) {
                final ayah = ayahs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        ayah.text ?? '',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontSize: 28,
                          height: 1.8,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Ayat ${ayah.numberInSurah}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFD3AA58),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Memuat lirik...'));
        },
      ),
    );
  }
}
