import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    loadNextPage();
  }

  void loadNextPage() async {
    if (isLoading || isLastPage) return;
    isLoading = true;

    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();

    isLoading = false;

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final favoriteMovies = ref
        .watch(favoriteMoviesProvider)
        .values
        .toList(); //solo los valores en una lista

    if (favoriteMovies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_outline_sharp, size: 60, color: colors.primary),
            Text(
              "Ohh no",
              style: TextStyle(fontSize: 30, color: colors.primary),
            ),
            const Text(
              "No tienes películas favoritas",
              style: TextStyle(fontSize: 20, color: Colors.black45),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton.tonal(
                onPressed: () => context.go("/home/0"),
                child: const Text("Empieza a buscar"))
          ],
        ),
      );
    }

    return Scaffold(
        // ignore: prefer_const_constructors
        body: MovieMasonry(loadNextPage: loadNextPage, movies: favoriteMovies));
  }
}
