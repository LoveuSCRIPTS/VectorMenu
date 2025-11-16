# coords

Simple FiveM coordinate helper with NUI vector picker.

## Features

- Commands `vector3` and `vector4` copy your current ped coords/heading.
- Command `vector` opens an NUI menu to choose Vector3 or Vector4.
- After choosing, a line from the camera with a dot at the end shows the target point.
- Press `H` to copy the target point as `vector3(...)` or `vector4(...)`.
- Press `X` to cancel the selection.
- Uses clipboard via `ox_lib` when available.

## Configuration

Currently the script is standalone-only.

`config/config.lua` is included only for future simple options (for example custom keys or toggles). You do not need to change anything for basic usage.

## Installation

1. Put this folder into your `resources` directory (e.g. `resources/[local]/coords`).
2. Ensure `ox_lib` is started before this resource if you want clipboard support.
3. Add to `server.cfg`:

```cfg
ensure coords
```

## Usage

- `/vector3` – copy your ped position as `vector3`.
- `/vector4` – copy your ped position + heading as `vector4`.
- `/vector`
  - Opens NUI with Vector3/Vector4 choice.
  - Aim with your camera; a line and dot show the target.
  - Press `H` to copy, `X` to cancel.
