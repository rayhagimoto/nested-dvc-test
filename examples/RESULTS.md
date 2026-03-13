# Experiment Isolation Test

I ran the following commands to create two independent DVC example repositories:

```
$ ./setup-example.sh 1 && ./setup-example.sh 2
```

This script clones the example repo, initializes a DVC repository in subdir mode, pulls the data, commits the workspace, and runs a DVC experiment named according to the provided argument.

The result is two directories:

```
cool-example-1
cool-example-2
```

I then checked whether experiments created in one repository were visible in the other.

---

# Repository 1

Command:

```
$ cd cool-example-1
$ dvc exp show
```

Output:

```
> ────────────────────────────────────────────────────────────────────────────────>
>  Experiment            Created    avg_prec.train   avg_prec.test   roc_auc.train>
> ────────────────────────────────────────────────────────────────────────────────>
>  workspace             -                 0.97437           0.925         0.98667>
>  main                  07:06 PM          0.97437           0.925         0.98667>
>  └── 52e7519 [exp-1]   07:06 PM          0.97437           0.925         0.98667>
> ────────────────────────────────────────────────────────────────────────────────>
```

Observed experiment:

```
exp-1
```

---

# Repository 2

Command:

```
$ cd ../cool-example-2
$ dvc exp show
```

Output:

```
> ────────────────────────────────────────────────────────────────────────────────>
>  Experiment            Created    avg_prec.train   avg_prec.test   roc_auc.train>
> ────────────────────────────────────────────────────────────────────────────────>
>  workspace             -                 0.97437           0.925         0.98667>
>  main                  07:06 PM          0.97437           0.925         0.98667>
>  └── 1b68f84 [exp-2]   07:06 PM          0.97437           0.925         0.98667>
> ────────────────────────────────────────────────────────────────────────────────>
```

Observed experiment:

```
exp-2
```

---

# Result

Each repository only shows the experiment that was executed within that repository:

| Repository       | Visible Experiment |
| ---------------- | ------------------ |
| `cool-example-1` | `exp-1`            |
| `cool-example-2` | `exp-2`            |

The experiment from one repository is **not visible in the other**, confirming that experiments are isolated between the two independent DVC repositories.

