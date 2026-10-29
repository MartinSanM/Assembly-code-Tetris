# ZX Spectrum 48K Tetris (Z80 Assembly)

A classic **Tetris** implementation written entirely in **Z80 Assembly** for the **Sinclair ZX Spectrum 48K**. The game renders directly into ZX Spectrum video memory (`0x4000` bitmap pattern and `0x5800` color attribute memory) with custom 8x8 block textures, real-time collision detection, next-piece preview, and animated line clearing.

---

## Features

- **High-Resolution Block Textures:** Initializes the ZX Spectrum screen bitmap (`0x4000`–`0x57FF`) with an 8x8 beveled block pattern (`hrBKG`), allowing attribute manipulation at `0x5800` to render textured tetromino blocks.
- **Full Tetromino Set & Rotations:** Includes all 7 classic tetrominoes (`O`, `I`, `Z`, `S`, `L`, `J`, `T`) with dedicated ZX Spectrum color attributes and linked-list rotation pointers.
- **Next-Piece Preview Box:** Displays the upcoming randomly selected tetromino in a side preview window (`X: 23..29, Y: 3..8`) using the Z80 DRAM Refresh Register (`R`) for pseudo-random number generation.
- **Collision Detection & Move Rollback:** Validates boundaries and existing blocks before locking moves, rolling back invalid translations or rotations via `undo.asm`.
- **Line Clearing & Visual Flash:** Detects completed horizontal rows, highlights cleared lines with a bright flashing attribute mask (`%10111101`), pauses briefly, and shifts upper rows down.
- **Game Over Indication:** Sets the ZX Spectrum screen border to red (`OUT ($FE), A`) when a newly spawned tetromino collides at the top of the board.

---

## Controls

The game reads the ZX Spectrum keyboard matrix directly via hardware port `$FE` (`$FBFE` and `$FDFE`):

| Key | Action |
| :---: | :--- |
| **W** | Rotate tetromino counter-clockwise |
| **A** | Move tetromino left |
| **S** | Hard drop (instantly drops piece to lowest valid position) |
| **D** | Move tetromino right |

---

## Project Structure

| File | Description |
| :--- | :--- |
| `template.asm` | Main entry point (`ORG $8000`), game loop, state machine, and module includes. |
| `highResBackground.asm` | Populates bitmap VRAM (`$4000`, size `$1800`) with an 8x8 tile graphic (`blockgraph`). |
| `board.asm` | Draws the main 10-column playfield border (`X: 10..21`, `Y: 0..23`) and next-piece preview box. |
| `keyboard.asm` | Direct hardware port scanning (`IN A, (C)`) for `W`, `A`, `S`, `D` keys and movement dispatch. |
| `tetro.asm` | Renders (`drawTetro`), clears (`clearT`), and checks collisions (`checkPlace`) for active pieces. |
| `tetromino_blocks.asm` | Data structures, rotation pointer tables, and 2D bitmasks for all 7 tetrominoes. |
| `nextpiece.asm` | Pseudo-random piece generator (`LD A, R`) and coordinate helpers for spawning and previewing. |
| `fall.asm` | Handles gravity ticks and vertical collision checks. |
| `lineremove.asm` | Scans rows (`checkLine`), flashes completed lines (`clearLine`), and shifts rows down (`copyline`). |
| `singlepixel.asm` | Low-level VRAM attribute (`0x5800 + Y*32 + X`) read/write utilities (`DOTXYC`, `DOTXYCopy`, `GetPixel`). |
| `undo.asm` | Reverts the last translation or rotation (`reverse`) when a collision is detected. |
| `template.bin` | Pre-assembled Z80 machine code binary ready to load at `$8000` (`32768`). |

---

## Building & Running

### Prerequisites
- **[sjasmplus](https://github.com/z00m128/sjasmplus)** (Z80 cross-assembler supporting `DEVICE ZXSPECTRUM48` and `SLDOPT`).
- A ZX Spectrum emulator such as **[Fuse](https://fuse-emulator.sourceforge.net/)**, **ZEsarUX**, or **DeZog** (VS Code extension).

### Assembling from Source
Run `sjasmplus` on `template.asm` to generate the binary or snapshot:

```bash
sjasmplus --raw=template.bin template.asm
```

### Running in an Emulator
1. Open your ZX Spectrum 48K emulator (e.g., **Fuse** or **ZEsarUX**).
2. Load `template.bin` into memory address **`32768`** (`$8000`).
3. Execute the program from BASIC using:
   ```basic
   RANDOMIZE USR 32768
   ```

---

## Technical Architecture

- **Memory Map:**
  - `$4000 - $57FF`: ZX Spectrum Display File (initialized with `blockgraph` 8x8 tiles).
  - `$5800 - $5AFF`: Color Attribute File (`32 x 24` grid used as the primary coordinate space).
  - `$8000 (`32768`)`: Program origin (`begin`) with interrupts disabled (`DI`) and stack pointer at `RAMTOP` (`$0000`).
- **Tetromino Data Format (`tetromino_blocks.asm`):**
  - Byte `0`: Color attribute (`PAPER` color value before `x8` shift in `calculateColor`).
  - Byte `1` (`offsetBY`): Height of piece bounding box.
  - Byte `2` (`offsetBX`): Width of piece bounding box.
  - Bytes `3..4` (`ptrOffsetRL`): 16-bit pointer to counter-clockwise rotated state.
  - Bytes `5..6` (`ptrOffsetRR`): 16-bit pointer to clockwise rotated state.
  - Bytes `7+` (`offsetData`): Row-major `0`/`1` occupancy matrix (`BY * BX` bytes).
