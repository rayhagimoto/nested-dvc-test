# Nested DVC Test 

This repo explores project organizations for monorepos that rely on DVC for large file data management.

In this project I will try a few different setups.

1. DVC is initialized at the top root
2. DVC is not initialized at the project root, only in individual examples.

A common structure that I will use is 

```
```text
.
└── root/
    └── examples/
        ├── cool-examples-1/
        │   ├── README.md
        │   ├── dvc.yaml
        │   ├── data
        │   ├── results/
        │   │   ├── train/
        │   │   │   └── metrics.json
        │   │   └── evaluate/
        │   │       └── metrics.json
        │   └── src/
        │       ├── prepare.py
        │       ├── train.py
        │       └── evaluate.py
        └── cool-example-2/
            └── ...                      # more of the same
```

So I want to know if I should put `.dvc/` folders inside of the `cool-examples` or if I should have them at the top level.

One workflow that I desire is the ability to do `dvc repro examples/cool-example-i/dvc.yaml` to reproduce results locally.
```

To enable local notebook rendering on `git push`, run `bash scripts/install-git-hooks.sh` once in your clone. That configures the repo-managed pre-push hook in [`.githooks/pre-push`](/home/ray/code/explore/nested-dvc-test/.githooks/pre-push), which runs [`scripts/render_interactive_notebook.sh`](/home/ray/code/explore/nested-dvc-test/scripts/render_interactive_notebook.sh) before each push and blocks the push if rendered notebook artifacts changed.
