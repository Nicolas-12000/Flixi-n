import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:movies/domain/movie.dart';
import 'package:movies/presentation/state/favorites_manager.dart';

class FavoriteButton extends StatefulWidget {
  final Movie movie;

  const FavoriteButton({super.key, required this.movie});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritesManager = Provider.of<FavoritesManager>(context);
    final isFav = favoritesManager.isFavorite(widget.movie.id);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withAlpha((0.9 * 255).round()),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.2 * 255).round()),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              favoritesManager.toggleFavorite(widget.movie);
              _controller.forward(from: 0);
              setState(() {});
            },
            customBorder: CircleBorder(),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
