[![Mod downloads](https://img.shields.io/badge/dynamic/json?color=orange&label=Factorio&query=downloads_count&suffix=%20downloads&url=https%3A%2F%2Fmods.factorio.com%2Fapi%2Fmods%2Fnegative_space)](https://mods.factorio.com/mod/negative_space)

# Negative Space

A mod for [Factorio](https://factorio.com/) that adds a negative space entity
for marking where empty space must be in blueprints that removes entities after
the blueprint is super forced placed. Optionally automatically adds negative
space around belts or fluid pipes.

Features include:

* A spawnable negative space entity that is placeable on the ground, but when
  placed from a blueprint deletes itself.
* Super force building a blueprint will remove any entity in the way of
  negative space.
* An option to automatically add negative space around belts when creating
  blueprints (also works for copy paste).
* Same as above, but for fluid pipes.
* Customizing the style and color of the graphic.

![Thumbnail](https://raw.githubusercontent.com/Rycieos/factorio-negative-space/main/thumbnail.png)

### Experimental

This mod has not been extensively tested, so please report any issues.

#### Known issues:

* Some undo or redo actions involving a negative space (not auto-generated
  negative space) break the undo history.

### Getting help

For bug reports or specific feature requests, please [open a new
issue](https://github.com/Rycieos/factorio-negative-space/issues/new/choose).
Please check if your issue has already been reported before opening a new one.

For questions or anything else, please [open a new
discussion](https://github.com/Rycieos/factorio-negative-space/discussions/new/choose).
