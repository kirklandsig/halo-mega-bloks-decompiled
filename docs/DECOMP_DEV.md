# decomp.dev progress report

[decomp.dev](https://decomp.dev) charts a decompilation from an
[objdiff](https://github.com/encounter/objdiff) progress report. This project
can't run `objdiff-cli report generate` (its checker compiles single objects
with the Xbox 360 compiler and compares them with the retail executable), so
it writes the same report format itself.

The format is
[`objdiff-core/protos/report.proto`](https://github.com/encounter/objdiff/blob/main/objdiff-core/protos/report.proto)
(report version 2; see the [decomp.dev guide](https://decomp.wiki/tools/decomp-dev)).
decomp.dev reads a JSON report uploaded as a GitHub Actions artifact named
`<version>_report`. Byte counts are JSON strings; function counts and
percentages are JSON numbers.

## What this repo exports

```
python tools/decomp_dev_export.py -o build/report.json
```

It reads `config/functions.csv` and `config/status.csv` only.

- **Top-level measures and the `nspace` category:** the game-tier functions
  whose owner is `nspace`, the decomp's target. One unit per object.
- **The `game` category:** every game-tier function. Epic's functions of an
  object are a second unit, `<object> [epic]`.

| `status.csv` | In the report |
| --- | --- |
| `matched` | Full size counts as matched code. Fuzzy match 100. |
| `near`, or no row (`todo`) | Counted in the total only. Fuzzy match 0. |

Data is not compared: the data totals are `"0"` and their percentages 0.
Functions are named `function_<va>`.

## The workflow

`.github/workflows/decomp-dev.yml` runs on every push to `main`, writes the
report and uploads it as the artifact `retail_report` (holding
`report.json`). It needs no secrets and none of the build's files.

## Registering the project

A maintainer does this once, on decomp.dev:

1. Sign in at [decomp.dev](https://decomp.dev) with GitHub and add the project
   at [decomp.dev/manage/new](https://decomp.dev/manage/new)
   (`kirklandsig/halo-mega-bloks-decompiled`).
2. Install the decomp.dev GitHub app on the repository, so it can read the
   workflow's artifacts.
