import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CharacterListShimmer extends StatelessWidget {
  const CharacterListShimmer({super.key, this.itemCount = 8});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surface;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Shimmer.fromColors(
            baseColor: base,
            highlightColor: highlight,
            child: Container(
              height: 112,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CharacterPaginationShimmer extends StatelessWidget {
  const CharacterPaginationShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surface;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
