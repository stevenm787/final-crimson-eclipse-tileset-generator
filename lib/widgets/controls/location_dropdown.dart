import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/locations.dart';
import '../../models/location.dart';
import '../../state/app_state.dart';

/// A dropdown that lists all locations grouped by category.
class LocationDropdown extends StatelessWidget {
  const LocationDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final grouped = locationsByCategory;
    final theme = Theme.of(context);

    // Build flat list of DropdownMenuItems with category headers.
    final List<DropdownMenuItem<Location>> items = [];
    for (final entry in grouped.entries) {
      // Category header (disabled).
      items.add(
        DropdownMenuItem<Location>(
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

      // Location items under this category.
      for (final location in entry.value) {
        final subtitle = location.culturalInspiration ??
            location.element ??
            location.sin ??
            location.theme ??
            '';
        items.add(
          DropdownMenuItem<Location>(
            value: location,
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    location.name,
                    style: theme.textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
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

    return DropdownButtonFormField<Location>(
      initialValue: appState.selectedLocation,
      decoration: const InputDecoration(labelText: 'Location'),
      isExpanded: true,
      dropdownColor: theme.colorScheme.surface,
      menuMaxHeight: 400,
      items: items,
      onChanged: (location) {
        if (location != null) {
          appState.selectedLocation = location;
        }
      },
      hint: Text(
        'Select a location...',
        style: theme.textTheme.bodySmall,
      ),
    );
  }
}
