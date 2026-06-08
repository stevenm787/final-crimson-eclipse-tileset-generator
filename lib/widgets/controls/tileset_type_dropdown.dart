import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/tileset_specs.dart';
import '../../models/tileset_type.dart';
import '../../state/app_state.dart';

/// A dropdown for selecting the RPG Maker MZ tileset sheet type.
class TilesetTypeDropdown extends StatelessWidget {
  const TilesetTypeDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);

    // Group tileset types by category.
    final Map<String, List<TilesetType>> grouped = {};
    for (final t in kTilesetTypes) {
      grouped.putIfAbsent(t.category, () => []).add(t);
    }

    final List<DropdownMenuItem<TilesetType>> items = [];
    for (final entry in grouped.entries) {
      // Category header.
      items.add(
        DropdownMenuItem<TilesetType>(
          enabled: false,
          value: null,
          child: Text(
            entry.key.toUpperCase(),
            style: TextStyle(
              color: theme.colorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 1.5,
            ),
          ),
        ),
      );

      for (final tilesetType in entry.value) {
        final dims = tilesetType.getDimensions(appState.selectedTileSize);
        items.add(
          DropdownMenuItem<TilesetType>(
            value: tilesetType,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'RPG Maker MZ - ${tilesetType.name.split(' - ').first}',
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${tilesetType.purpose.split(' ').first} (${dims.width}x${dims.height})',
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 11),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return DropdownButtonFormField<TilesetType>(
      initialValue: appState.selectedTilesetType,
      decoration: const InputDecoration(labelText: 'Tileset Type'),
      isExpanded: true,
      dropdownColor: theme.colorScheme.surface,
      menuMaxHeight: 400,
      items: items,
      onChanged: (tilesetType) {
        if (tilesetType != null) {
          appState.selectedTilesetType = tilesetType;
        }
      },
    );
  }
}
