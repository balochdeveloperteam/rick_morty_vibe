import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rick_morty_browser/features/characters/domain/entities/character.dart';

class CharacterCard extends StatelessWidget {
  const CharacterCard({
    super.key,
    required this.character,
    required this.onFavoriteTap,
  });

  final Character character;
  final VoidCallback onFavoriteTap;

  Color _statusColor(BuildContext context) {
    switch (character.status.toLowerCase()) {
      case 'alive':
        return Colors.green.shade600;
      case 'dead':
        return Colors.red.shade600;
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: character.image,
                  width: 88,
                  height: 88,
                  fit: BoxFit.cover,
                  placeholder: (context, _) => Container(
                    width: 88,
                    height: 88,
                    color: scheme.surfaceContainerHighest,
                    child: const Center(
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                  errorWidget: (context, _, _) => Container(
                    width: 88,
                    height: 88,
                    color: scheme.surfaceContainerHighest,
                    child: Icon(Icons.broken_image_outlined, color: scheme.outline),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      character.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _statusColor(context),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '${character.status} · ${character.species}',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: character.isFavorite ? 'Remove from favorites' : 'Add to favorites',
                onPressed: onFavoriteTap,
                icon: Icon(
                  character.isFavorite ? Icons.star : Icons.star_border,
                  color: character.isFavorite ? Colors.amber.shade700 : scheme.outline,
                ),
              ),
            ],
          ),
        ),
    );
  }
}
