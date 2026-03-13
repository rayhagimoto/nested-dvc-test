# Experiment Visibility Test

I ran the following commands to create two DVC example directories:

```bash
./setup-example.sh 1
./setup-example.sh 2
```

This script clones the same example project into two sibling directories, removes the cloned `.git/` and `.dvc/` metadata, initializes DVC in subdir mode, pulls data, and runs a named experiment:

```bash
dvc init --subdir
dvc exp run -n "exp-<suffix>"
```

The resulting directories are:

```text
cool-example-1
cool-example-2
```

## Important detail

These are not isolated Git repositories. Both directories live under the same parent Git repository, whose `.git/` directory is at the project root:

```text
../.git
```

Because DVC experiments are tied to Git state, experiments created from the same commit are visible from either subdirectory when they share that same Git root.

## What happens in practice

If `exp-1` is run from `cool-example-1` and `exp-2` is run from `cool-example-2`, then `dvc exp show` from either directory shows both experiments, not just the one created in that directory.

## Result

The experiments are **not isolated** across `cool-example-1` and `cool-example-2`.

| Directory        | Visible Experiments |
| ---------------- | ------------------- |
| `cool-example-1` | `exp-1`, `exp-2`    |
| `cool-example-2` | `exp-1`, `exp-2`    |

## Conclusion

Running `dvc init --subdir` in sibling directories does not create experiment isolation when those directories still share the same parent `.git/` repository. The visibility is shared at the Git repository level, so experiments run from the same commit appear from either subdirectory.
